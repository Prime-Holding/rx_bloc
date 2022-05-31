package com.primeholding.rxbloc_generator_plugin.action

import com.intellij.openapi.actionSystem.AnAction
import com.intellij.openapi.actionSystem.AnActionEvent
import com.intellij.openapi.application.runWriteAction
import com.intellij.openapi.vfs.VirtualFile
import com.intellij.testFramework.VfsTestUtil
import com.primeholding.rxbloc_generator_plugin.parser.Bloc
import com.primeholding.rxbloc_generator_plugin.parser.Utils
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

                val showAndGet = ChooseBlocsDialog(parsedLib, selected).showAndGet()
                if (showAndGet) {
                    writeItIntoTests(test, selected, it.name)
                }
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