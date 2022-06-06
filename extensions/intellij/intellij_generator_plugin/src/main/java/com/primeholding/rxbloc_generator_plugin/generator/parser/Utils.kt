package com.primeholding.rxbloc_generator_plugin.generator.parser

import com.intellij.openapi.vfs.VirtualFile
import java.io.File

class Utils {

    companion object {
        fun extractBloc(notNullBlocFile: VirtualFile): Bloc? {

            if (!notNullBlocFile.exists() || notNullBlocFile.isDirectory) {
                return null
            }
            val stateVariableNames: MutableList<String> = mutableListOf()
            val stateVariableTypes: MutableList<String> = mutableListOf()
            val repos: MutableList<String> = mutableListOf()
            val services: MutableList<String> = mutableListOf()

            val text = File(notNullBlocFile.path).readText()
            getValueBetween(text, "States {", "}")?.let { stateText ->
                stateText.lines().forEach { line ->
                    getValueBetween(line, "Stream<", "> get")?.let { stateVariableType ->
                        stateVariableTypes.add(stateVariableType)
                    }

                    getValueBetween(line, "> get ", ";")?.let { stateVariableName ->
                        stateVariableNames.add(stateVariableName)
                    }
                }
            }
            return Bloc(
                fileName = notNullBlocFile.name,
                relativePath = notNullBlocFile.path.substring(
                    notNullBlocFile.path.indexOf("lib") + 3
                ),
                stateVariableNames = stateVariableNames,
                stateVariableTypes = stateVariableTypes,
                repos = repos,
                services = services
            )
        }

        fun analyzeLib(libFolder: VirtualFile): List<Bloc> {
            val list = ArrayList<Bloc>()
            var bloc: Bloc?

            val repos: MutableList<String> = mutableListOf()
            val services: MutableList<String> = mutableListOf()

            val allowedPrefixes = listOf("feature_", "lib_")

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

            return list
        }

        private fun replaceAllPrefixes(name: String, allowedPrefixes: List<String>): String {

            var temp = name
            allowedPrefixes.forEach {
                temp = temp.replace(it, "")
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

    }
}