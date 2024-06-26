package com.primeholding.rxbloc_generator_plugin.action

import com.intellij.openapi.actionSystem.AnAction
import com.intellij.openapi.actionSystem.AnActionEvent
import com.intellij.openapi.actionSystem.DataKeys
import com.intellij.openapi.command.WriteCommandAction
import com.intellij.openapi.fileEditor.FileEditorManager
import com.intellij.openapi.project.Project
import com.intellij.openapi.ui.Messages
import com.intellij.openapi.util.io.FileUtil
import com.intellij.openapi.vfs.VirtualFile
import com.primeholding.rxbloc_generator_plugin.generator.parser.TestableClass
import com.primeholding.rxbloc_generator_plugin.generator.parser.Utils
import com.primeholding.rxbloc_generator_plugin.ui.ChooseBlocsDialog
import java.io.File


class BootstrapTestsAction : AnAction() {
    override fun update(e: AnActionEvent?) {
        super.update(e)
        val files = e?.dataContext?.getData(CommonDataKeys.VIRTUAL_FILE_ARRAY)
        var isVisible = false

        val numberFiles = (files?.size ?: 0)
        if (numberFiles == 1) {
            val file = files!!.first()
            if (isChooseBlogsDialog(file)) {
                isVisible = true
            } else if (isBlocFolder(file)) {
                isVisible = true
            }
        } else if (numberFiles > 1) {
            for (file in files!!) {
                if (isBlocFolder(file)) {
                    isVisible = true
                    break
                }
            }
        }
        e?.presentation?.isVisible = isVisible
    }

    private fun isBlocFolder(file: VirtualFile): Boolean {
        // is folder
        if (file.isDirectory) {
            var containsBloc = false
            var containsView = false
            file.children.forEach {
                //check for bloc
                if (it.isDirectory && it.name == "blocs") {
                    containsBloc = true
                }
                //check for view
                if (it.isDirectory && (
                            it.name == "views" ||
                                    it.name == "ui_components" ||
                                    it.name == "ui" ||
                                    it.name == "components" ||
                                    it.name == "widgets")
                ) {
                    containsView = true
                }
            }
            return containsBloc && containsView
        }
        return false
    }

    private fun isChooseBlogsDialog(file: VirtualFile): Boolean {
        if (file.isDirectory && (file.name == "lib" || file.name == "src" || file.name == "test")) {
            return true
        }
        return false
    }

    override fun actionPerformed(e: AnActionEvent?) {

        val allowedPrefixes = listOf("feature_", "lib_")

        e?.project?.basePath?.let { baseDir ->

            var isShowDialog = false
            val files = e.dataContext.getData(CommonDataKeys.VIRTUAL_FILE_ARRAY)


            val potentialBlocFolders = mutableListOf<VirtualFile>()

            val numberFiles = files!!.size
            if (numberFiles == 1) {
                val file = files.first()
                if (isChooseBlogsDialog(file)) {
                    isShowDialog = true
                } else if (isBlocFolder(file)) {
                    potentialBlocFolders.add(file)
                }
            } else if (numberFiles > 1) {
                for (file in files) {
                    if (isBlocFolder(file)) {
                        potentialBlocFolders.add(file)
                    }
                }
            }
            val trueBaseDir = Utils.baseDir(baseDir)
            val test = trueBaseDir.findChild("test")
                ?: //TODO make the folder or show dialog
                return

            if (isShowDialog) {
                //the folder that contains lib, test, etc...

                val lib = trueBaseDir.findChild("lib")

                if (lib != null) {
                    val parsedLib = Utils.analyzeLib(lib)
                    val selected = ArrayList(parsedLib)
                    Utils.unCheckExisting(lib, selected) //TODO change this as it uses side effect of pass by reference

                    val dialog = ChooseBlocsDialog(parsedLib, selected)
                    val showAndGet = dialog.showAndGet()
                    if (showAndGet) {
                        writeItIntoTests(test, selected, trueBaseDir.name, e.project!!, dialog.includeDiMocks())
                    }
                }
            } else {
                val list = ArrayList<TestableClass>()
                potentialBlocFolders.forEach { file ->
                    Utils.analyzeFolderForBloc(file.findChild("blocs")!!, file, allowedPrefixes)?.let { list.add(it) }

                }
                if (list.isEmpty()) {
                    Messages.showMessageDialog(
                        "No BloCs Found in the selected direcoty that follow naming convention",
                        "No Blocs",
                        null
                    )
                    return
                }
                writeItIntoTests(test, list, trueBaseDir.name, e.project!!, true)//potentially choose the flag
            }
        }
    }

    private fun writeItIntoTests(
        testFolder: VirtualFile,
        blocs: List<TestableClass>,
        projectName: String,
        project: Project,
        includeDiMocks: Boolean
    ) {
        val blocFileExt = "_bloc.dart"
        WriteCommandAction.runWriteCommandAction(project) {
            blocs.forEach { bloc ->
                val prefix = (if (bloc.isLib) "lib" else "feature")
                val featureTestFolder = prefix + "_" + bloc.file.name.replace("_bloc.dart", "")

                val oldFile = testFolder.findFileByRelativePath(featureTestFolder)

                if (oldFile != null && oldFile.exists()) {
                    Messages.showMessageDialog(
                        "Test Folder ${
                            oldFile.name
                        } Already Exists!",
                        "Duplicate Test",
                        null
                    )

                    return@runWriteCommandAction
                }
                val featureFolder =
                    testFolder.createChildDirectory(
                        this,
                        featureTestFolder
                    )

                var folder = featureFolder.createChildDirectory(this, "factory")
                var testFile: VirtualFile =
                    folder.createChildData(this, bloc.file.name.replace(blocFileExt, "_factory.dart"))

                writeTestFactory(testFile, bloc, projectName)
                FileEditorManager.getInstance(project).openFile(testFile, true)

                folder = featureFolder.createChildDirectory(this, "mock")
                testFile = folder.createChildData(this, bloc.file.name.replace(blocFileExt, "_mock.dart"))

                writeTestMock(testFile, bloc, projectName)
                FileEditorManager.getInstance(project).openFile(testFile, true)

                folder = featureFolder.createChildDirectory(this, "view")
                testFile = folder.createChildData(this, bloc.file.name.replace(blocFileExt, "_golden_test.dart"))

                writeGoldenTest(testFile, bloc, projectName)
                FileEditorManager.getInstance(project).openFile(testFile, true)


                val blocsFolder = featureFolder.createChildDirectory(this, "blocs")
                testFile = blocsFolder.createChildData(this, bloc.file.name.replace(blocFileExt, "_test.dart"))

                writeBlockTest(testFile, bloc, projectName, includeDiMocks)
                FileEditorManager.getInstance(project).openFile(testFile, true)
            }
        }
    }


    private fun writeTestMock(testFile: VirtualFile, bloc: TestableClass, projectName: String) {
        val test = com.primeholding.rxbloc_generator_plugin.generator.components.RxTestBlocMockGenerator(
            name = bloc.file.name.replace(".dart", ""), projectName = projectName, bloc = bloc
        )
        FileUtil.writeToFile(File(testFile.path), test.generate())
    }

    companion object {

        fun writeGoldenTest(testFile: VirtualFile, bloc: TestableClass, projectName: String) {
            val test = com.primeholding.rxbloc_generator_plugin.generator.components.RxTestBlocGoldenGenerator(
                name = bloc.file.name.replace(".dart", ""), projectName = projectName, bloc = bloc
            )
            FileUtil.writeToFile(File(testFile.path), test.generate())
        }

        fun writeTestFactory(testFile: VirtualFile, bloc: TestableClass, projectName: String) {
            val test = com.primeholding.rxbloc_generator_plugin.generator.components.RxTestBlocFactoryGenerator(
                name = bloc.file.name.replace(".dart", ""), projectName = projectName, bloc = bloc
            )
            FileUtil.writeToFile(File(testFile.path), test.generate())

        }

        fun writeBlockTest(
            testFile: VirtualFile,
            bloc: TestableClass,
            projectName: String,
            includeDiMocks: Boolean
        ) {
            val test = com.primeholding.rxbloc_generator_plugin.generator.components.RxTestBlocGenerator(
                name = bloc.file.name.replace(".dart", ""),
                projectName = projectName,
                bloc = bloc,
                includeDiMocks = includeDiMocks
            )
            FileUtil.writeToFile(File(testFile.path), test.generate())
        }

    }
}