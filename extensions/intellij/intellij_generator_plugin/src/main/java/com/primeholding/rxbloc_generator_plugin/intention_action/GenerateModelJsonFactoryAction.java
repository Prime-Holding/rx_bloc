package com.primeholding.rxbloc_generator_plugin.intention_action;

import com.intellij.codeInsight.intention.impl.BaseIntentionAction;
import com.intellij.openapi.editor.Editor;
import com.intellij.openapi.project.Project;
import com.intellij.psi.PsiFile;
import com.intellij.util.IncorrectOperationException;
import org.jetbrains.annotations.Nls;
import org.jetbrains.annotations.NotNull;

public class GenerateModelJsonFactoryAction extends BaseIntentionAction {
    @Nls(capitalization = Nls.Capitalization.Sentence)
    @NotNull
    @Override
    public String getFamilyName() {
        return getText();
    }

    @Override
    public boolean isAvailable(@NotNull Project project, Editor editor, PsiFile file) {
        if (file.getName().endsWith("model.dart")) {

            String text = editor.getDocument().getText();
            return text.contains("@JsonSerializable()") && !text.contains(".fromJson(Map<String, dynamic> json");
        }
        return false;
    }

    @Override
    public void invoke(@NotNull Project project, Editor editor, PsiFile file) throws IncorrectOperationException {
        /*
        TODO add json factories
       factory AbcModel.fromJson(Map<String, dynamic> json) => _$AbcModelFromJson(json);
       Map<String, dynamic> toJson() => _$AbcModelToJson(this);
         */
    }
}
