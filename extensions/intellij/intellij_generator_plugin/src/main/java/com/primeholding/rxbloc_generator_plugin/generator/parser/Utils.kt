package com.primeholding.rxbloc_generator_plugin.generator.parser

import com.intellij.openapi.vfs.VirtualFile
import com.primeholding.rxbloc_generator_plugin.intention_action.BlocWrapWithIntentionAction
import java.io.File

class Utils {

    companion object {
        fun extractBloc(notNullBlocFile: VirtualFile): Bloc? {

            if (!notNullBlocFile.exists() || notNullBlocFile.isDirectory) {
                return null
            }
            val stateVariableNames: MutableList<String> = mutableListOf()
            val stateIsConnectableStream: MutableList<Boolean> = mutableListOf()
            val stateVariableTypes: MutableList<String> = mutableListOf()
            val services: MutableList<String> = mutableListOf()
            val repos: MutableList<String> = mutableListOf()
            val constructorFields: MutableMap<String, String> = mutableMapOf()
            val constructorNamedFields: MutableMap<String, Boolean> = mutableMapOf()

            val text = File(notNullBlocFile.path).readText()
            getValueBetween(text, "States {", "}")?.let { stateText ->
                stateText.lines().forEach { line ->
                    getValueBetween(line, "Stream<", "> get")?.let { stateVariableType ->
                        stateVariableTypes.add(stateVariableType)

                        stateIsConnectableStream.add(line.contains("ConnectableStream"))

                        getValueBetween(line, "> get ", ";")?.let { stateVariableName ->
                            stateVariableNames.add(stateVariableName)
                        }
                    }
                }
            }
            val blockName: String = BlocWrapWithIntentionAction.toCamelCase(
                notNullBlocFile.name.replace("page.dart", "").replace(".dart", "")
            )

            fun parseRequiredFields(constructorFieldsText: String) {

                val split = constructorFieldsText.split(",")
                split.forEach {
                    if (it.contains("this.")) {
                        constructorFields[it.replace("this.", "").trim()] = ""
                    } else {
                        val definition = it.trim().split(" ")
                        if (definition.size == 2)
                            constructorFields[definition[1].trim()] = definition[0].trim()
                    }
                }
            }

            getValueBetween(text, "${blockName}(", ")")?.let { constructorFieldsText ->
                if (constructorFieldsText.contains("{")) {

                    //contains named parameters
                    val mandatoryFields = constructorFieldsText.substring(0, constructorFieldsText.indexOf("{"))
                    parseRequiredFields(mandatoryFields)

                    val namedFieldsText = getValueBetween(constructorFieldsText, "{", "}")

                    namedFieldsText?.let { fieldsDef ->
                        val namedFields = fieldsDef.split(",")
                        namedFields.forEach { fieldDefWrap ->
                            var fieldDefWrap1 = fieldDefWrap
                            val isRequired = fieldDefWrap.contains("required ")
                            var value = ""
                            if (fieldDefWrap.contains("=")) {
                                value = fieldDefWrap.substring(fieldDefWrap.indexOf("=") + 1).trim()
                                fieldDefWrap1 = fieldDefWrap.substring(0, fieldDefWrap.indexOf("=")).trim()

                            }

                            val singleFieldDef = fieldDefWrap1.replace("required ", "").trim()
                            if (singleFieldDef.contains("this.")) {
                                constructorFields[singleFieldDef.replace("this.", "").trim()] = value
                                constructorNamedFields[singleFieldDef.replace("this.", "").trim()] = isRequired
                            } else {
                                val definition = singleFieldDef.trim().split(" ")
                                if (definition.size == 2) {
                                    constructorFields[definition[1].trim()] = definition[0].trim()
                                    constructorNamedFields[definition[1].trim()] = isRequired
                                }
                            }
                        }
                    }

                } else {
                    //contains only inline fields
                    parseRequiredFields(constructorFieldsText)
                }
            }
            val blocLines = text.split("\n")

            val keysSet = ArrayList(constructorFields.keys)
            blocLines.forEach { line ->
                keysSet.forEach {
                    if (line.contains(" $it") && line.contains("final ")) {

                        getValueBetween(line, "final ", " ${it};")?.let { value ->
                            constructorFields[it] = value
                        }

                    }
                }
            }
            keysSet.forEach {
                if (constructorFields[it]!!.isEmpty()) {
                    constructorFields.remove(it)
                }
            }
            return Bloc(
                file = notNullBlocFile,
                relativePath = notNullBlocFile.path.substring(
                    notNullBlocFile.path.indexOf("lib") + 3
                ),
                stateVariableNames = stateVariableNames,
                stateVariableTypes = stateVariableTypes,
                stateIsConnectableStream = stateIsConnectableStream,
                constructorFieldNames = constructorFields.keys.toMutableList(),
                constructorFieldTypes = constructorFields.values.toMutableList(),
                repos = repos,
                services = services,
                constructorFieldNamedNames = constructorNamedFields,
                isLib = notNullBlocFile.parent.parent.name.contains("lib_")
            )
        }

        fun analyzeLib(libFolder: VirtualFile): List<Bloc> {
            val list = ArrayList<Bloc>()

            val repos: MutableList<String> = mutableListOf()
            val services: MutableList<String> = mutableListOf()

            val allowedPrefixes = listOf("feature_", "lib_")

            scanFolder(libFolder, allowedPrefixes, list, repos, services)
            libFolder.findChild("src").let {

                it?.let {
                    if (it.isDirectory) {
                        scanFolder(it, allowedPrefixes, list, repos, services)
                    }
                }
            }

            list.sortWith(Comparator { bloc1, bloc2 ->
                val file1 = (if (bloc1.isLib) "lib_" else "feature_") + bloc1.file.name
                val file2 = (if (bloc2.isLib) "lib_" else "feature_") + bloc2.file.name

                file1.compareTo(file2)
            })
            return list
        }

        private fun scanFolder(
            libFolder: VirtualFile,
            allowedPrefixes: List<String>,
            list: ArrayList<Bloc>,
            repos: MutableList<String>,
            services: MutableList<String>
        ) {
            var bloc: Bloc?
            libFolder.children.forEach { libChild ->
                if (libChild.isDirectory && startsWithAnyOf(libChild.name, allowedPrefixes)) {
                    libChild.findChild("blocs")?.let { blocFolder ->
                        val blocFile =
                            blocFolder.findChild(replaceAllPrefixes(libChild.name, allowedPrefixes) + "_bloc.dart")
                        blocFile?.let { notNullBlocFile ->
                            bloc = extractBloc(notNullBlocFile)
                            bloc?.let { list.add(it) }
                        }
                    }
                }
                if (libChild.isDirectory && libChild.name == "base") {
                    val repositoriesFolder = libChild.findChild("repositories")
                    val servicesFolder = libChild.findChild("services")

                    repositoriesFolder?.let { reposFolder ->
                        reposFolder.children.forEach {
                            repos.add(it.name.replace("_repository.dart", ""))
                        }
                    }
                    servicesFolder?.let { sFolder ->
                        sFolder.children.forEach {
                            services.add(it.name.replace("_repository.dart", ""))
                        }
                    }

                }
            }
            list.forEach {
                it.repos.addAll(repos)
                it.services.addAll(services)
            }
        }

        private fun replaceAllPrefixes(name: String, allowedPrefixes: List<String>): String {

            var temp = name
            allowedPrefixes.forEach {
                temp = temp.replaceFirst(it, "")
            }
            return temp
        }

        private fun startsWithAnyOf(name: String, allowedPrefixes: List<String>): Boolean {
            allowedPrefixes.forEach {
                if (name.startsWith(it)) {
                    return true
                }
            }
            return false
        }


        private fun getValueBetween(text: String, from: String, to: String): String? {
            val start = text.indexOf(from)
            if (start != -1) {
                val toIndex = text.indexOf(to, start + from.length)

                if (toIndex != -1) {
                    return text.substring(start + from.length, toIndex)
                }
            }
            return null
        }

        fun unCheckExisting(libFolder: VirtualFile, selected: ArrayList<Bloc>) {
            val parent = libFolder.parent
            val testFolder = parent.findChild("test")
            if (testFolder?.isDirectory == true) {
                testFolder.children.forEach { libChild ->
                    if (libChild.name.startsWith("feature_") || libChild.name.startsWith("lib_")) {
                        selected.removeIf { x: Bloc ->
                            x.file.name == libChild.name.replace("feature_", "").replace("lib_", "") + "_bloc.dart"
                        }
                    }
                }
            }

        }
    }


}