package com.primeholding.rxbloc_generator_plugin.action

import com.primeholding.rxbloc_generator_plugin.generator.RxBlocGeneratorFactory
import com.intellij.openapi.actionSystem.*
import com.intellij.openapi.application.ApplicationManager
import com.intellij.openapi.command.CommandProcessor
import com.intellij.openapi.fileTypes.PlainTextLanguage
import com.intellij.openapi.project.Project
import com.intellij.openapi.ui.Messages
import com.intellij.openapi.vfs.VirtualFile
import com.intellij.psi.*
import com.primeholding.rxbloc_generator_plugin.generator.RxGeneratorBase
import java.io.File

class GenerateRxBlocAction : AnAction(), GenerateRxBlocDialog.Listener {

    private lateinit var event: AnActionEvent
    private lateinit var dataContext: DataContext

    override fun actionPerformed(e: AnActionEvent) {
        event = e
        val dialog = GenerateRxBlocDialog(this, true)
        dialog.show()
    }

    override fun onGenerateBlocClicked(
        blocName: String?,
        withDefaultStates: Boolean,
        includeLocalService: Boolean,
        routingIntegration: GenerateRxBlocDialog.RoutingIntegration
    ) {
        blocName?.let { name ->
            val generators = RxBlocGeneratorFactory.getBlocGenerators(
                name,
                withDefaultStates,
                includeLocalService
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

            val file = directory?.findFile(mainSourceGenerators[0].fileName())
            if (file != null) {
                Messages.showMessageDialog(
                    "BloC ${
                        mainSourceGenerators[0].fileName()
                    } Already Exists!",
                    "Duplicate BloC",
                    null
                )
                return
            }
        }


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

    private fun createSourceFile(project: Project, generator: RxGeneratorBase, directory: PsiDirectory) {
        val fileName = generator.fileName()
        val existingPsiFile = directory.findFile(fileName)
        if (existingPsiFile != null) {
            val document = PsiDocumentManager.getInstance(project).getDocument(existingPsiFile)
            document?.insertString(document.textLength, "\n" + generator.generate())
            return
        }
        val psiFile = PsiFileFactory.getInstance(project)
            .createFileFromText(
                fileName,
                PlainTextLanguage.INSTANCE,
                fixSubPaths(generator.generate(), directory.virtualFile.parent)
            )
        directory.add(psiFile)
    }


    private fun fixSubPaths(code: String, featureSubDirectory: VirtualFile): String {
        var subPart = ""
        val libPath = "${event.project?.basePath}${File.separator}lib"

        if (featureSubDirectory.path.contains(libPath)) {
            val subPartCount = featureSubDirectory.path.replace(libPath, "")
                .replace("\\", "/").split("/").size
            for (i in 0 until subPartCount) {
                subPart += "../"
            }
        }
        return code.replace("../../base", "$subPart../../base")
    }
}