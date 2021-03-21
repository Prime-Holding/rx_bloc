package com.primeholding.rxbloc_generator_plugin.action

import com.primeholding.rxbloc_generator_plugin.generator.RxBlocGeneratorFactory
import com.primeholding.rxbloc_generator_plugin.generator.RxBlocGeneratorBase
import com.intellij.lang.java.JavaLanguage
import com.intellij.openapi.actionSystem.*
import com.intellij.openapi.application.ApplicationManager
import com.intellij.openapi.command.CommandProcessor
import com.intellij.openapi.project.Project
import com.intellij.psi.*

class GenerateRxBlocAction : AnAction(), GenerateRxBlocDialog.Listener {

    private lateinit var dataContext: DataContext

    override fun actionPerformed(e: AnActionEvent) {
        val dialog = GenerateRxBlocDialog(this)
        dialog.show()
    }

    override fun onGenerateBlocClicked(
        blocName: String?,
        shouldUseEquatable: Boolean,
        includeExtensions: Boolean,
        includeNullSafety: Boolean) {
        blocName?.let { name ->
            val generators = RxBlocGeneratorFactory.getBlocGenerators(
                name,
                shouldUseEquatable,
                includeExtensions,
                includeNullSafety
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

    protected fun generate(mainSourceGenerators: List<RxBlocGeneratorBase>) {
        val project = CommonDataKeys.PROJECT.getData(dataContext)
        val view = LangDataKeys.IDE_VIEW.getData(dataContext)
        val directory = view?.orChooseDirectory
        ApplicationManager.getApplication().runWriteAction {
            CommandProcessor.getInstance().executeCommand(
                project,
                {
                    mainSourceGenerators.forEach { createSourceFile(project!!, it, directory!!) }
                },
                "Generate a new RxBloc",
                null
            )
        }
    }

    private fun createSourceFile(project: Project, generator: RxBlocGeneratorBase, directory: PsiDirectory) {
        val fileName = generator.fileName()
        val existingPsiFile = directory.findFile(fileName)
        if (existingPsiFile != null) {
            val document = PsiDocumentManager.getInstance(project).getDocument(existingPsiFile)
            document?.insertString(document.textLength, "\n" + generator.generate())
            return
        }
        val psiFile = PsiFileFactory.getInstance(project)
            .createFileFromText(fileName, JavaLanguage.INSTANCE, generator.generate())
        directory.add(psiFile)
    }
}