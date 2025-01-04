package com.primeholding.rxbloc_generator_plugin.generator.parser

import com.intellij.openapi.vfs.VfsUtil
import com.intellij.openapi.vfs.VirtualFile
import com.primeholding.rxbloc_generator_plugin.intention_action.BlocWrapWithIntentionAction
import java.io.File

class Utils {

    companion object {

        fun getConstructorFields(
            text: String,
            className: String,
            constructorFields: MutableMap<String, String>,
            constructorNamedFields: MutableMap<String, Boolean>
        ) {
            getValueBetween(text, "${className}(", ")")?.let { constructorFieldsText ->
                analyzeConstructor(constructorFieldsText, constructorFields, constructorNamedFields)
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
        }

        private fun analyzeConstructor(
            constructorFieldsText: String,
            constructorFields: MutableMap<String, String>,
            constructorNamedFields: MutableMap<String, Boolean>
        ) {

            fun parseRequiredFields(constructorFieldsText: String) {

                val split = constructorFieldsText.split(",")
                split.forEach {
                    if (it.contains("this.")) {
                        constructorFields[it.replace("this.", "").trim()] = ""
                    } else {
                        val definition = it.trim().split(" ")
                        if (definition.size == 2) constructorFields[definition[1].trim()] = definition[0].trim()
                    }
                }
            }

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

        private fun removeNonFinalOrEmptyFields(constructorFields: MutableMap<String, String>) {
            val keysSet = ArrayList(constructorFields.keys)
            keysSet.forEach {
                if (constructorFields[it].isNullOrEmpty()) {
                    constructorFields.remove(it)
                }
            }
        }

        fun extractBloc(notNullBlocFile: VirtualFile): TestableClass? {

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
            getConstructorFields(text, blockName, constructorFields, constructorNamedFields)
            removeNonFinalOrEmptyFields(constructorFields)

            return TestableClass(
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

        fun analyzeLib(libFolder: VirtualFile): List<TestableClass> {
            val list = ArrayList<TestableClass>()

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

            list.sortWith { bloc1, bloc2 ->
                val file1 = (if (bloc1.isLib) "lib_" else "feature_") + bloc1.file.name
                val file2 = (if (bloc2.isLib) "lib_" else "feature_") + bloc2.file.name

                file1.compareTo(file2)
            }
            return list
        }

        private fun scanFolder(
            libFolder: VirtualFile,
            allowedPrefixes: List<String>,
            list: ArrayList<TestableClass>,
            repos: MutableList<String>,
            services: MutableList<String>
        ) {
            var bloc: TestableClass?
            libFolder.children.forEach { libChild ->
                if (libChild.isDirectory && startsWithAnyOf(libChild.name, allowedPrefixes)) {
                    libChild.findChild("blocs")?.let { blocFolder ->
                        bloc = analyzeFolderForBloc(blocFolder, libChild, allowedPrefixes)
                        if (bloc != null) {
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

        fun analyzeFolderForBloc(
            blocFolder: VirtualFile, libChild: VirtualFile, allowedPrefixes: List<String>
        ): TestableClass? {
            val blocFile = blocFolder.findChild(replaceAllPrefixes(libChild.name, allowedPrefixes) + "_bloc.dart")
            blocFile?.let { notNullBlocFile ->
                return extractBloc(notNullBlocFile)
            }
            return null
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

        fun unCheckExisting(libFolder: VirtualFile, selected: ArrayList<TestableClass>) {
            val parent = libFolder.parent
            val testFolder = parent.findChild("test")
            if (testFolder?.isDirectory == true) {
                testFolder.children.forEach { libChild ->
                    if (libChild.name.startsWith("feature_") || libChild.name.startsWith("lib_")) {
                        selected.removeIf { x: TestableClass ->
                            x.file.name == libChild.name.replace("feature_", "").replace("lib_", "") + "_bloc.dart"
                        }
                    }
                }
            }

        }

        fun getMethods(text: String, className: String): List<ClassMethod> {
            val result = mutableListOf<ClassMethod>()

            val indexOf = text.lastIndexOf(className)
            if (indexOf == -1) {
                //something is fishy, no class name is found in the file.
            } else {
                val indexOf1 = text.indexOf("\n", indexOf)
                if (indexOf1 > 0) {
                    //This is taken as expected - for all methods to be after the constructor
                    val substringLines = text.substring(indexOf1 + 1).split("\n")

                    substringLines.forEach { line ->
                        if (line.startsWith("  ") && !line.startsWith("    ")
                            && line.contains("(")
                        ) {
                            val open = line.indexOf("(")
                            val name = line.substring((line.substring(0, open)).lastIndexOf(" "), open).trim()
                            if (!name.startsWith("_")) {
                                result.add(
                                    ClassMethod(
                                        name = name,
                                        constructorFieldNamedNames = mutableMapOf(),
                                        constructorFieldNames = mutableListOf(),
                                        constructorFieldTypes = mutableListOf(),
                                        returnedType = ""
                                    )
                                )
                            }

                        }
                    }
                }
            }
            return result
        }

        fun getClassName(file: VirtualFile): String {
            val text = File(file.path).readText().split("\n")
            val start = "class "
            text.forEach { line ->
                if (line.startsWith(start)) {

                    var end = line.indexOf(" ", start.length)
                    if (end == -1) {
                        end = line.length
                    }
                    return line.substring(start.length, end).trim()
                }
            }
            return file.name
        }

        fun fixRelativeImports(
            importLine: String,
            appFolder: VirtualFile,
            file: VirtualFile
        ): String {
            var result = ""
            if (importLine.contains("..")) {

                val testPath = file.parent.path.replace("${appFolder.path}${File.separator}lib${File.separator}", "")
                    .replace("\\", "/").split("/")
                val countDots = importLine.split("..").size - 1
                var theMiddlePath = ""
                for (i in countDots until testPath.size) {
                    theMiddlePath += "${testPath[i - countDots]}/"
                }

                result = "import 'package:${appFolder.name}/${theMiddlePath}${
                    importLine.substring(
                        importLine.lastIndexOf("../") + 3, importLine.lastIndexOf('\'')
                    )
                }';"
            } else {
                if (importLine.startsWith("import 'package:")) {
                    result = importLine
                } else {
                    val indexStart = importLine.indexOf('\'')
                    if (indexStart != -1) {
                        val indexEnd = importLine.indexOf('\'', indexStart + 1)

                        if (indexEnd != -1) {
                            result = "import 'package:${appFolder.name}/${
                                file.path.replace(
                                    "${appFolder.path}${File.separator}lib${File.separator}",
                                    ""
                                ).replace(file.name, importLine.substring(indexStart + 1, indexEnd))
                            }';".replace("\\", "/")
                        }
                    }
                }
            }
            return result
        }

        fun baseDir(basePath: String): VirtualFile {
            return VfsUtil.findFileByIoFile(File(basePath), false)!!
        }

    }


}