package com.primeholding.rxbloc_generator_plugin.action

import com.intellij.openapi.actionSystem.*
import com.intellij.openapi.application.ApplicationManager
import com.intellij.openapi.command.CommandProcessor
import com.intellij.openapi.fileEditor.FileEditorManager
import com.intellij.openapi.ui.Messages
import com.intellij.openapi.vfs.VirtualFile
import com.intellij.testFramework.VfsTestUtil
import com.primeholding.rxbloc_generator_plugin.generator.RxBlocFeatureGeneratorFactory
import com.primeholding.rxbloc_generator_plugin.generator.RxGeneratorBase
import com.primeholding.rxbloc_generator_plugin.generator.components.RxPageGenerator


class GenerateRxBlocFeatureAction : AnAction(), GenerateRxBlocDialog.Listener {

    private lateinit var dataContext: DataContext
    private lateinit var event: AnActionEvent

    override fun actionPerformed(e: AnActionEvent) {
        event = e
        val dialog = GenerateRxBlocDialog(this)
        dialog.show()
    }

    override fun onGenerateBlocClicked(
        blocName: String?,
        withDefaultStates: Boolean,
        includeLocalService: Boolean,
        includeAutoRoute: Boolean
    ) {
        blocName?.let { name ->
            val generators = RxBlocFeatureGeneratorFactory.getBlocGenerators(
                name,
                withDefaultStates,
                includeLocalService,
                includeAutoRoute
            )
            generate(generators)
        }
    }

    override fun update(e: AnActionEvent) {
        e.dataContext.let {
            this.dataContext = it
            val presentation = e.presentation


            val files = e.dataContext.getData(DataKeys.VIRTUAL_FILE_ARRAY)
            val isVisible = files != null && files.size == 1 && files[0].isDirectory

            presentation.isEnabled = isVisible
            presentation.isVisible = isVisible
        }
    }

    private fun generate(mainSourceGenerators: List<RxGeneratorBase>) {
        val project = CommonDataKeys.PROJECT.getData(dataContext)
        //contextually selected folders
        val files = event.dataContext.getData(DataKeys.VIRTUAL_FILE_ARRAY)



        if (mainSourceGenerators.isNotEmpty() && files != null && files.size == 1 && files[0].isDirectory) {
            val featureDirectory = files[0]?.findChild(mainSourceGenerators[0].featureDirectoryName())

            if (featureDirectory != null) {
                Messages.showMessageDialog(
                    "Feature ${
                        mainSourceGenerators[0].featureDirectoryName().replaceFirst("feature_", "")
                    } Already Exists!",
                    "Duplicate Feature",
                    null
                )
                return
            }
        }

        var file: VirtualFile? = null

        ApplicationManager.getApplication().runWriteAction {
            CommandProcessor.getInstance().executeCommand(
                project,
                {
                    mainSourceGenerators.forEach {
                        val featureDirectory = createDir(files!![0], it.featureDirectoryName())
                        val featureBlocDirectory = createDir(featureDirectory, it.contextDirectoryName())
                        if (it is RxPageGenerator) {
                            file = createSourceFile(it, featureBlocDirectory)
                        } else {
                            createSourceFile(it, featureBlocDirectory)
                        }
                    }
                },
                "Generate a new RxBloc Feature",
                null
            )
        }
        if (file != null && project != null) {
            //TODO this does not open it properly
            FileEditorManager.getInstance(project)
                .openFile(file!!, true)
        }
    }

    private fun createSourceFile(generator: RxGeneratorBase, directory: VirtualFile): VirtualFile? {
        val fileName = generator.fileName()
        val existingPsiFile = directory.findChild(fileName)
        if (existingPsiFile != null) {
            return null
        }

        val file = directory.createChildData(this, fileName)
        VfsTestUtil.overwriteTestData(file.path, generator.generate())

        return file
    }

    private fun createDir(baseDirectory: VirtualFile, name: String): VirtualFile {
        var featureDirectory = baseDirectory.findChild(name)

        if (featureDirectory == null) {
            featureDirectory = baseDirectory.createChildDirectory(this, name)
        }

        return featureDirectory
    }
}