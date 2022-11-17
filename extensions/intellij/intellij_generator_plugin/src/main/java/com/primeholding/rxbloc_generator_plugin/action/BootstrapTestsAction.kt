package com.primeholding.rxbloc_generator_plugin.action

import com.intellij.openapi.actionSystem.AnAction
import com.intellij.openapi.actionSystem.AnActionEvent
import com.intellij.openapi.command.WriteCommandAction
import com.intellij.openapi.project.Project
import com.intellij.openapi.vfs.VirtualFile
import com.intellij.testFramework.VfsTestUtil
import com.primeholding.rxbloc_generator_plugin.generator.parser.Bloc
import com.primeholding.rxbloc_generator_plugin.generator.parser.Utils
import com.primeholding.rxbloc_generator_plugin.ui.ChooseBlocsDialog

class BootstrapTestsAction : AnAction() {
    override fun actionPerformed(e: AnActionEvent?) {
        e?.project?.baseDir?.let {

            //the folder that contains lib, test, etc...
            val baseProjectDir = it
            val lib = baseProjectDir.findChild("lib")
            val test = baseProjectDir.findChild("test")

            if (lib != null && test != null) {
                val parsedLib = Utils.analyzeLib(lib)
                val selected = ArrayList(parsedLib)
                Utils.unCheckExisting(lib, selected) //TODO change this as it uses side effect of pass by reference

                val dialog = ChooseBlocsDialog(parsedLib, selected)
                val showAndGet = dialog.showAndGet()
                if (showAndGet) {
                    writeItIntoTests(test, selected, it.name, e.project!!, dialog.includeDiMocks())
                }
            }

        }
    }

    private fun writeItIntoTests(
        testFolder: VirtualFile,
        blocs: List<Bloc>,
        projectName: String,
        project: Project,
        includeDiMocks: Boolean
    ) {
        val blocFileExt = "_bloc.dart"
        WriteCommandAction.runWriteCommandAction(project) {
            blocs.forEach { bloc ->

                val prefix = (if (bloc.isLib) "lib" else "feature")
                val featureFolder =
                    testFolder.createChildDirectory(
                        this,
                        prefix + "_" + bloc.file.name.replace("_bloc.dart", "")
                    )

                var folder = featureFolder.createChildDirectory(this, "factory")
                var testFile: VirtualFile =
                    folder.createChildData(this, bloc.file.name.replace(blocFileExt, "_factory.dart"))

                writeTestFactory(testFile, bloc, projectName)

                folder = featureFolder.createChildDirectory(this, "mock")
                testFile = folder.createChildData(this, bloc.file.name.replace(blocFileExt, "_mock.dart"))

                writeTestMock(testFile, bloc, projectName)

                folder = featureFolder.createChildDirectory(this, "view")
                testFile = folder.createChildData(this, bloc.file.name.replace(blocFileExt, "_golden_test.dart"))

                writeGoldenTest(testFile, bloc, projectName)

                val blocsFolder = featureFolder.createChildDirectory(this, "blocs")
                testFile = blocsFolder.createChildData(this, bloc.file.name.replace(blocFileExt, "_test.dart"))

                writeBlockTest(testFile, bloc, projectName, includeDiMocks)
            }
        }
    }


    private fun writeBlockTest(testFile: VirtualFile, bloc: Bloc, projectName: String, includeDiMocks: Boolean) {
        val test = com.primeholding.rxbloc_generator_plugin.generator.components.RxTestBlocGenerator(
            name = bloc.file.name.replace(".dart", ""),
            projectName = projectName,
            bloc = bloc,
            includeDiMocks = includeDiMocks
        )
        VfsTestUtil.overwriteTestData(testFile.path, test.generate())
    }

    private fun writeGoldenTest(testFile: VirtualFile, bloc: Bloc, projectName: String) {
        val test = com.primeholding.rxbloc_generator_plugin.generator.components.RxTestBlocGoldenGenerator(
            name = bloc.file.name.replace(".dart", ""), projectName = projectName, bloc = bloc
        )
        VfsTestUtil.overwriteTestData(testFile.path, test.generate())
    }

    private fun writeTestMock(testFile: VirtualFile, bloc: Bloc, projectName: String) {
        val test = com.primeholding.rxbloc_generator_plugin.generator.components.RxTestBlocMockGenerator(
            name = bloc.file.name.replace(".dart", ""), projectName = projectName, bloc = bloc
        )
        VfsTestUtil.overwriteTestData(testFile.path, test.generate())
    }

    private fun writeTestFactory(testFile: VirtualFile, bloc: Bloc, projectName: String) {
        val test = com.primeholding.rxbloc_generator_plugin.generator.components.RxTestBlocFactoryGenerator(
            name = bloc.file.name.replace(".dart", ""), projectName = projectName, bloc = bloc
        )
        VfsTestUtil.overwriteTestData(testFile.path, test.generate())
    }
}