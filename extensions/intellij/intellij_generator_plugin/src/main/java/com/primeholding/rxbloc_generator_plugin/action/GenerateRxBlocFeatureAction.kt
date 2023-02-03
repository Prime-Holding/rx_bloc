package com.primeholding.rxbloc_generator_plugin.action

import com.intellij.openapi.actionSystem.*
import com.intellij.openapi.application.ApplicationManager
import com.intellij.openapi.command.CommandProcessor
import com.intellij.openapi.fileTypes.PlainTextLanguage
import com.intellij.openapi.project.Project
import com.intellij.openapi.ui.Messages
import com.intellij.psi.PsiDirectory
import com.intellij.psi.PsiDocumentManager
import com.intellij.psi.PsiFile
import com.intellij.psi.PsiFileFactory
import com.primeholding.rxbloc_generator_plugin.generator.RxBlocFeatureGeneratorFactory
import com.primeholding.rxbloc_generator_plugin.generator.RxGeneratorBase
import com.primeholding.rxbloc_generator_plugin.generator.components.RxPageGenerator


class GenerateRxBlocFeatureAction : AnAction(), GenerateRxBlocDialog.Listener {

    private lateinit var dataContext: DataContext

    override fun actionPerformed(e: AnActionEvent) {
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
            presentation.isEnabled = true
        }
    }

    private fun generate(mainSourceGenerators: List<RxGeneratorBase>) {
        val project = CommonDataKeys.PROJECT.getData(dataContext)
        val view = LangDataKeys.IDE_VIEW.getData(dataContext)
        val directory = view?.orChooseDirectory

        if (mainSourceGenerators.isNotEmpty()) {
            val featureDirectory = directory?.findSubdirectory(mainSourceGenerators[0].featureDirectoryName())

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

        var file: PsiFile? = null

        ApplicationManager.getApplication().runWriteAction {
            CommandProcessor.getInstance().executeCommand(
                project,
                {
                    mainSourceGenerators.forEach {
                        val featureDirectory = createDir(directory!!, it.featureDirectoryName())
                        val featureBlocDirectory = createDir(featureDirectory, it.contextDirectoryName())
                        if (it is RxPageGenerator) {
                            file = createSourceFile(project!!, it, featureBlocDirectory)
                        } else {
                            createSourceFile(project!!, it, featureBlocDirectory)
                        }
                    }
                },
                "Generate a new RxBloc Feature",
                null
            )
        }
        if (file != null && project != null) {
            file!!.virtualFile
            //TODO this does not open it properly
//            FileEditorManager.getInstance(project)
//                .openFile(file!!.virtualFile, true)
        }
    }

    private fun createSourceFile(project: Project, generator: RxGeneratorBase, directory: PsiDirectory): PsiFile? {
        val fileName = generator.fileName()
        val existingPsiFile = directory.findFile(fileName)
        if (existingPsiFile != null) {
            val document = PsiDocumentManager.getInstance(project).getDocument(existingPsiFile)
            document?.insertString(document.textLength, "\n" + generator.generate())
            return null
        }
        val psiFile = PsiFileFactory.getInstance(project)
            .createFileFromText(fileName, PlainTextLanguage.INSTANCE, generator.generate())

        if (psiFile != null) {
            directory.add(psiFile)
        }
        return psiFile
    }

    private fun createDir(baseDirectory: PsiDirectory, name: String): PsiDirectory {
        var featureDirectory = baseDirectory.findSubdirectory(name)

        if (featureDirectory == null) {
            featureDirectory = baseDirectory.createSubdirectory(name)
        }

        return featureDirectory
    }
}