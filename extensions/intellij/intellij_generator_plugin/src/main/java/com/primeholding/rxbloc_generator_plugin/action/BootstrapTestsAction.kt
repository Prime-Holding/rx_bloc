package com.primeholding.rxbloc_generator_plugin.action

import com.intellij.openapi.actionSystem.AnAction
import com.intellij.openapi.actionSystem.AnActionEvent
import com.intellij.openapi.application.runWriteAction
import com.intellij.openapi.vfs.VirtualFile
import com.intellij.testFramework.VfsTestUtil
import java.io.File

///path - relative to the lib folder + list of items that the bloc uses.
data class Bloc(
    val fileName: String,
    val relativePath: String,
    val states: List<String>,
    val repos: MutableList<String>,
    val services: MutableList<String>
)

class BootstrapTestsAction : AnAction() {
    override fun actionPerformed(e: AnActionEvent?) {
        e?.project?.baseDir?.let {

            //the folder that contains lib, test, etc...
            val baseProjectDir = it
            val lib = baseProjectDir.findChild("lib")
            val test = baseProjectDir.findChild("test")

            if (lib != null && test != null) {
                val parsedLib = analyzeLib(lib)
                writeItIntoTests(test, parsedLib, it.name)
            }

        }
    }

    private fun writeItIntoTests(testFolder: VirtualFile, blocs: List<Bloc>, projectName: String) {
        val blocFileExt = "_bloc.dart"
        runWriteAction {
            blocs.forEach { bloc ->

                val featureFolder =
                    testFolder.createChildDirectory(this, "feature_" + bloc.fileName.replace("_bloc.dart", ""))

                var folder = featureFolder.createChildDirectory(this, "factory")
                var testFile: VirtualFile =
                    folder.createChildData(this, bloc.fileName.replace(blocFileExt, "_factory.dart"))

                writeTestFactory(testFile, bloc, projectName)

                folder = featureFolder.createChildDirectory(this, "mock")
                testFile = folder.createChildData(this, bloc.fileName.replace(blocFileExt, "_mock.dart"))

                writeTestMock(testFile, bloc, projectName)

                folder = featureFolder.createChildDirectory(this, "view")
                testFile = folder.createChildData(this, bloc.fileName.replace(blocFileExt, "_golden.dart"))

                writeGoldenTest(testFile, bloc, projectName)

                val blocsFolder = featureFolder.createChildDirectory(this, "blocs")
                testFile = blocsFolder.createChildData(this, bloc.fileName.replace(blocFileExt, "_test.dart"))

                writeBlockTest(testFile, bloc, projectName)
            }
        }
    }

    private fun analyzeLib(libFolder: VirtualFile): List<Bloc> {
        val list = ArrayList<Bloc>()
        var bloc: Bloc?

        val repos: MutableList<String> = mutableListOf()
        val services: MutableList<String> = mutableListOf()

        libFolder.children.forEach { libChild ->
            if (libChild.isDirectory && libChild.name.startsWith("feature_")) {
                libChild.findChild("blocs")?.let { blocFolder ->
                    val blocFile = blocFolder.findChild(libChild.name.replace("feature_", "") + "_bloc.dart")
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

    private fun extractBloc(notNullBlocFile: VirtualFile): Bloc? {

        if (!notNullBlocFile.exists() || notNullBlocFile.isDirectory) {
            return null
        }
        val states: MutableList<String> = mutableListOf()
        val repos: MutableList<String> = mutableListOf()
        val services: MutableList<String> = mutableListOf()

        val text = File(notNullBlocFile.path).readText()
        getValueBetween(text, "States {", "}")?.let { stateText ->
            stateText.lines().forEach { line ->
                getValueBetween(line, "> get ", ";")?.let { stateVariableName ->
                    states.add(stateVariableName)
                }
            }
        }
        return Bloc(
            fileName = notNullBlocFile.name,
            relativePath = notNullBlocFile.path.substring(
                notNullBlocFile.path.indexOf("lib") + 3
            ),
            states = states,
            repos = repos,
            services = services
        )
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


    private fun writeBlockTest(testFile: VirtualFile, bloc: Bloc, projectName: String) {
        val test = com.primeholding.rxbloc_generator_plugin.generator.components.RxTestBlocGenerator(
            name = bloc.fileName.replace(".dart", ""), projectName = projectName, bloc = bloc
        )
        VfsTestUtil.overwriteTestData(testFile.path, test.generate())
    }

    private fun writeGoldenTest(testFile: VirtualFile, bloc: Bloc, projectName: String) {
        val test = com.primeholding.rxbloc_generator_plugin.generator.components.RxTestBlocGoldenGenerator(
            name = bloc.fileName.replace(".dart", ""), projectName = projectName, bloc = bloc
        )
        VfsTestUtil.overwriteTestData(testFile.path, test.generate())
    }

    private fun writeTestMock(testFile: VirtualFile, bloc: Bloc, projectName: String) {
        val test = com.primeholding.rxbloc_generator_plugin.generator.components.RxTestBlocMockGenerator(
            name = bloc.fileName.replace(".dart", ""), projectName = projectName, bloc = bloc
        )
        VfsTestUtil.overwriteTestData(testFile.path, test.generate())
    }

    private fun writeTestFactory(testFile: VirtualFile, bloc: Bloc, projectName: String) {
        val test = com.primeholding.rxbloc_generator_plugin.generator.components.RxTestBlocFactoryGenerator(
            name = bloc.fileName.replace(".dart", ""), projectName = projectName, bloc = bloc
        )
        VfsTestUtil.overwriteTestData(testFile.path, test.generate())
    }
}