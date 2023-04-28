package com.primeholding.rxbloc_generator_plugin.intention_action;

import com.intellij.codeInsight.intention.impl.BaseIntentionAction;
import com.intellij.openapi.command.WriteCommandAction;
import com.intellij.openapi.editor.*;
import com.intellij.openapi.project.Project;
import com.intellij.psi.PsiDocumentManager;
import com.intellij.psi.PsiFile;
import com.intellij.util.IncorrectOperationException;
import org.jetbrains.annotations.Nls;
import org.jetbrains.annotations.NotNull;

import static com.primeholding.rxbloc_generator_plugin.intention_action.BlocWrapWithIntentionAction.toCamelCase;

public class GenerateModelJsonFactoryAction extends BaseIntentionAction {


    @Nls(capitalization = Nls.Capitalization.Sentence)
    @NotNull
    @Override
    public String getFamilyName() {
        return "Generate json factories";
    }

    @Override
    public boolean isAvailable(@NotNull Project project, Editor editor, PsiFile file) {
        boolean result = false;
        if (file.getName().endsWith("model.dart")) {
            String text = getOpenEditorsText(editor);
            result = text.contains("@JsonSerializable()") && !text.contains(".fromJson(Map<String, dynamic> json");
        }
        if (result) {
            setText(getFamilyName());
        }
        return result;
    }

    /**
     * Get the text inside the editor. Left the method protected, so it could be overwritten in tests and to be more testable
     */
    @NotNull
    protected String getOpenEditorsText(Editor editor) {
        return editor.getDocument().getText();
    }

    protected void writeTextBack(String text, Project project, Editor editor) {
        WriteCommandAction.runWriteCommandAction(project, () -> {
            Document document = editor.getDocument();
            document.setText(text);
            PsiDocumentManager.getInstance(project).commitDocument(document);
        });
    }

    @Override
    public void invoke(@NotNull Project project, Editor editor, PsiFile file) throws IncorrectOperationException {
        String text = getOpenEditorsText(editor);
        String resultText = appendFactories(text, file.getName());
        if (!text.equals(resultText)) {
            writeTextBack(resultText, project, editor);
        }
    }

    @NotNull
    protected String appendFactories(@NotNull String text, String fileName) {
        fileName = toCamelCase(fileName.replace(".dart", ""));

        //first occurrence of closing parenthesis without indent
        int index = getIndexOfClosingTag(text);

        if (index != -1) {
            StringBuilder factories = new StringBuilder();

            factories.append("\n  factory ").append(fileName).append(".fromJson(Map<String, dynamic> json) => _$").append(fileName).append("FromJson(json);\n\n");
            factories.append("  Map<String, dynamic> toJson() => _$").append(fileName).append("ToJson(this);\n");

            text = new StringBuffer(text).insert(index, factories).toString();
        }
        // else if there is no closing parenthesis in the beginning of the row - it is not properly formatted

        return text;
    }

    /**
     * Note that this function assumes that the first definition of the model is placed first in the class.
     * If some enums or some other class is first in the file - it will get wrong index.
     *
     * @param multilineString - the source code
     * @return - the index of closing parenthesis
     */
    private int getIndexOfClosingTag(String multilineString) {
        String[] lines = multilineString.split("\n"); // split the multiline string into individual lines
        int index = -1;

        for (int i = 0; i < lines.length; i++) {
            String line = lines[i];
            if (line.startsWith("}")) {

                int calculatedIndex = 0;
                for (int j = 0; j < i; j++) {
                    calculatedIndex = calculatedIndex + lines[j].length() + 1;
                }
                index = calculatedIndex;
                break;
            }

        }
        return index;
    }
}

