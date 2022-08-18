package com.primeholding.rxbloc_generator_plugin.intention_action;

import com.intellij.codeInsight.intention.IntentionAction;
import com.intellij.codeInsight.intention.PsiElementBaseIntentionAction;
import com.intellij.openapi.application.ApplicationManager;
import com.intellij.openapi.command.WriteCommandAction;
import com.intellij.openapi.editor.*;
import com.intellij.openapi.project.Project;
import com.intellij.openapi.ui.ComboBox;
import com.intellij.openapi.ui.Messages;
import com.intellij.openapi.util.TextRange;
import com.intellij.openapi.vfs.VirtualFile;
import com.intellij.psi.PsiDocumentManager;
import com.intellij.psi.PsiElement;
import com.intellij.psi.PsiFile;
import com.intellij.psi.codeStyle.CodeStyleManager;
import com.intellij.util.IncorrectOperationException;
import com.primeholding.rxbloc_generator_plugin.generator.parser.Bloc;
import com.primeholding.rxbloc_generator_plugin.generator.parser.Utils;
import com.primeholding.rxbloc_generator_plugin.ui.ChooseDialog;
import org.jetbrains.annotations.NotNull;
import org.jetbrains.annotations.Nullable;

public abstract class BlocWrapWithIntentionAction extends PsiElementBaseIntentionAction implements IntentionAction {

    final static String BLOCS_DIRECTORY = "blocs";
    final SnippetType snippetType;
    PsiElement callExpressionElement;

    public BlocWrapWithIntentionAction(SnippetType snippetType) {
        this.snippetType = snippetType;
    }

    /**
     * Returns text for name of this family of intentions.
     * It is used to externalize "auto-show" state of intentions.
     * It is also the directory name for the descriptions.
     *
     * @return the intention family name.
     */
    @NotNull
    public String getFamilyName() {
        return getText();
    }

    /**
     * Checks whether this intention is available at the caret offset in file - the caret must sit on a widget call.
     * If this condition is met, this intention's entry is shown in the available intentions list.
     *
     * <p>Note: this method must do its checks quickly and return.</p>
     *
     * @param project    a reference to the Project object being edited.
     * @param editor     a reference to the object editing the project source
     * @param psiElement a reference to the PSI element currently under the caret
     * @return {@code true} if the caret is in a literal string element, so this functionality should be added to the
     * intention menu or {@code false} for all other types of caret positions
     */
    public boolean isAvailable(@NotNull Project project, Editor editor, @Nullable PsiElement psiElement) {
        if (psiElement == null) {
            return false;
        }

        final PsiFile currentFile = getCurrentFile(project, editor);
        if (currentFile != null && !currentFile.getName().endsWith(".dart")) {
            return false;
        }

        if (!psiElement.toString().equals("PsiElement(IDENTIFIER)")) {
            return false;
        }

        callExpressionElement = WrapHelper.callExpressionFinder(psiElement);
        return callExpressionElement != null;
    }

    /**
     * Called when user selects this intention action from the available intentions list.
     *
     * @param project a reference to the Project object being edited.
     * @param editor  a reference to the object editing the project source
     * @param element a reference to the PSI element currently under the caret
     * @throws IncorrectOperationException Thrown by underlying (Psi model) write action context
     *                                     when manipulation of the psi tree fails.
     */
    public void invoke(@NotNull Project project, Editor editor, @NotNull PsiElement element) throws IncorrectOperationException {
        Runnable runnable = () -> invokeSnippetAction(project, editor, snippetType);
        WriteCommandAction.runWriteCommandAction(project, runnable);
    }

    protected void invokeSnippetAction(@NotNull Project project, Editor editor, SnippetType snippetType) {
        final Document document = editor.getDocument();

        final PsiElement element = callExpressionElement;
        final TextRange elementSelectionRange = element.getTextRange();
        final int offsetStart = elementSelectionRange.getStartOffset();
        final int offsetEnd = elementSelectionRange.getEndOffset();

        if (!WrapHelper.isSelectionValid(offsetStart, offsetEnd)) {
            return;
        }

        String blocTypeDirectorySuggest = null;
        Bloc blocFromPath = null;
        PsiFile psiFile = PsiDocumentManager.getInstance(project).getPsiFile(document);

        if (psiFile != null) {
            VirtualFile vFile = psiFile.getOriginalFile().getVirtualFile();
            VirtualFile viewsDir = vFile.getParent();//by convention this should be called 'views' or "ui" or "ui_components".

            if (viewsDir.isDirectory()) {
                VirtualFile feature_dir = viewsDir.getParent();

                VirtualFile[] children = feature_dir.getChildren();
                for (VirtualFile file : children) {
                    if (file.isDirectory() && file.getName().equals(BLOCS_DIRECTORY)) {

                        String blocFileName = vFile.getName().replace("page.dart", "bloc.dart");

                        for (VirtualFile blocFile : file.getChildren()) {
                            if (blocFile.getName().equals(blocFileName)) {
                                blocTypeDirectorySuggest = (getBlocTypeFromFile(blocFile.getName()));
                                blocFromPath = Utils.Companion.extractBloc(blocFile);
                                break;
                            }
                        }

                        break;
                    }
                }
            }
        }
        final String selectedText = document.getText(TextRange.create(offsetStart, offsetEnd));
        String stateTypeDirectorySuggest = "";
        String stateVariableNameSuggest = "";

        if (blocFromPath != null && blocFromPath.getStateVariableTypes().size() > 0) {

            String filter = "";
            switch (snippetType) {
                case RxBlocBuilder:
                case RxBlocListener:
                case RxFormFieldBuilder:
                    // no custom filtering
                    break;
                case RxResultBuilder:
// Result builder - filter only states with result
                    filter = "Result<";
                    break;
                case RxPaginatedBuilder:
// Paginated List wrapping - Filter only paginated list
                    filter = "PaginatedList<";
                    break;
                case RxTextFormFieldBuilder:
// filter only string states from bloc
                    filter = "String";
                    break;
            }
            if (!filter.isEmpty()) {
                for (int i = blocFromPath.getStateVariableTypes().size() - 1; i >= 0; i--) {

                    if (!blocFromPath.getStateVariableTypes().get(i).startsWith(filter)) {
                        blocFromPath.getStateVariableNames().remove(i);
                        blocFromPath.getStateVariableTypes().remove(i);
                    }
                }
            }

            if (blocFromPath.getStateVariableNames().isEmpty()) {
                Messages.showMessageDialog(psiFile.getProject(), "No elements found matching the desired state type", "No Elements", null);
                return;
            } else if (blocFromPath.getStateVariableNames().size() == 1) {
                blocTypeDirectorySuggest = getBlocTypeFromFile(blocFromPath.getFileName());
                stateVariableNameSuggest = blocFromPath.getStateVariableNames().get(0);
                stateTypeDirectorySuggest = blocFromPath.getStateVariableTypes().get(0);
            } else {
                ComboBox<String> comboBox = new ComboBox<>(blocFromPath.getStateVariableNames().toArray(new String[0]));
                boolean isOK = new ChooseDialog<>(comboBox, "BloC State").showAndGet();
                int chooseState = comboBox.getSelectedIndex();
                if (isOK) {
                    blocTypeDirectorySuggest = getBlocTypeFromFile(blocFromPath.getFileName());
                    stateVariableNameSuggest = blocFromPath.getStateVariableNames().get(chooseState);
                    stateTypeDirectorySuggest = blocFromPath.getStateVariableTypes().get(chooseState);
                } else {
                    //Do nothing if canceled
                    return;
                }
            }
        }

        final String replaceWith = Snippets.getSnippet(snippetType, selectedText, blocTypeDirectorySuggest, stateTypeDirectorySuggest, stateVariableNameSuggest);

        // wrap the widget:
        WriteCommandAction.runWriteCommandAction(project, () -> document.replaceString(offsetStart, offsetEnd, replaceWith));

        checkImports(document, project, stateTypeDirectorySuggest);
        // place cursors to specify types:
        final String[] snippetArr = {Snippets.BLOC_SNIPPET_KEY};

        final CaretModel caretModel = editor.getCaretModel();
        caretModel.removeSecondaryCarets();

        for (String snippet : snippetArr) {
            if (!replaceWith.contains(snippet)) {
                continue;
            }

            final int caretOffset = offsetStart + replaceWith.indexOf(snippet);
            final VisualPosition visualPos = editor.offsetToVisualPosition(caretOffset);
            caretModel.addCaret(visualPos);

            // select snippet prefix keys:
            final Caret currentCaret = caretModel.getCurrentCaret();
            currentCaret.setSelection(caretOffset, caretOffset);
        }

        final Caret initialCaret = caretModel.getAllCarets().get(0);
        if (!initialCaret.hasSelection()) {
            // initial position from where was triggered the intention action
            caretModel.removeCaret(initialCaret);
        }

        // reformat file:
        ApplicationManager.getApplication().runWriteAction(() -> {
            PsiDocumentManager.getInstance(project).commitDocument(document);
            final PsiFile currentFile = getCurrentFile(project, editor);
            if (currentFile != null) {
                final String unformattedText = document.getText();
                final int unformattedLineCount = document.getLineCount();

                CodeStyleManager.getInstance(project).reformat(currentFile);
                final int formattedLineCount = document.getLineCount();

                // file was incorrectly formatted, revert formatting
                if (formattedLineCount > unformattedLineCount + 5) {
                    document.setText(unformattedText);
                    PsiDocumentManager.getInstance(project).commitDocument(document);
                }
            }
        });
    }

    private void checkImports(Document document, Project project, String stateTypeDirectorySuggest) {

        boolean containsResult = stateTypeDirectorySuggest.contains("Result<");
        boolean containsPaginatedList = stateTypeDirectorySuggest.contains("PaginatedList<");

        boolean containsPaginatedListImport = document.getText().contains("package:rx_bloc_list/rx_bloc_list.dart");
        boolean containsResultImport = document.getText().contains("package:rx_bloc/rx_bloc.dart");

        if (containsResult && !containsResultImport) {
            WriteCommandAction.runWriteCommandAction(project, () -> document.insertString(0, "import 'package:rx_bloc/rx_bloc.dart';\n"));
        }
        if (containsPaginatedList && !containsPaginatedListImport) {
            WriteCommandAction.runWriteCommandAction(project, () -> document.insertString(0, "import 'package:rx_bloc_list/rx_bloc_list.dart';\n"));
        }

        switch (snippetType) {
            case RxBlocListener:
            case RxBlocBuilder:
                if (!document.getText().contains("package:flutter_rx_bloc/flutter_rx_bloc.dart")) {
                    WriteCommandAction.runWriteCommandAction(project, () -> document.insertString(0, "import 'package:flutter_rx_bloc/flutter_rx_bloc.dart';\n"));
                }
                break;
            case RxResultBuilder:
            case RxPaginatedBuilder:
//handled globally
                break;
            case RxFormFieldBuilder:
            case RxTextFormFieldBuilder:
                if (!document.getText().contains("package:flutter_rx_bloc/rx_form.dart")) {
                    WriteCommandAction.runWriteCommandAction(project, () -> document.insertString(0, "import 'package:flutter_rx_bloc/rx_form.dart';\n" +
                            (containsResult && !containsResultImport ? "import 'package:rx_bloc/rx_bloc.dart';\n" : "")));
                }
                break;

        }
    }

    private String getBlocTypeFromFile(String vFileName) {
        String s = vFileName.replace("page.dart", "").replace(".dart", "");
        return toCamelCase(s) + "Type";
    }


    /**
     * Indicates this intention action expects the Psi framework to provide the write action context for any changes.
     *
     * @return {@code true} if the intention requires a write action context to be provided or {@code false} if this
     * intention action will start a write action
     */
    public boolean startInWriteAction() {
        return true;
    }

    private PsiFile getCurrentFile(Project project, Editor editor) {
        return PsiDocumentManager.getInstance(project).getPsiFile(editor.getDocument());
    }

    public static String fixSpaceTwoDotsSwash(String init) {
        return init.replaceAll(" ", "_").replaceAll("-", "_").replaceAll(":", "_");
    }

    public static String toCamelCase(String init) {
        if (init == null) return null;

        init = fixSpaceTwoDotsSwash(init);
        StringBuilder ret = new StringBuilder(init.length());

        for (final String word : init.split(" ")) {
            if (!word.isEmpty()) {
                ret.append(word.substring(0, 1).toUpperCase());
                ret.append(word.substring(1).toLowerCase());
            }
            if (!(ret.length() == init.length())) ret.append(" ");
        }

        String[] split = ret.toString().split("_");
        ret = new StringBuilder();
        for (String string : split) {
            if (!string.isEmpty()) {
                ret.append(string.substring(0, 1).toUpperCase());
                ret.append(string.substring(1).toLowerCase());
            }
        }

        return ret.toString();
    }

}
