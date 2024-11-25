package com.primeholding.rxbloc_generator_plugin.action;

import com.intellij.openapi.ui.DialogWrapper;
import org.jetbrains.annotations.Nullable;

import javax.swing.*;

public class GenerateRxBlocTestDialog extends DialogWrapper {

    private final Listener listener;
    private JPanel contentPane;
    private JComboBox<String> testLibrarySelection;

    public GenerateRxBlocTestDialog(final Listener listener) {
        super(null);
        this.listener = listener;
        init();
    }

    @Nullable
    @Override
    protected JComponent createCenterPanel() {
        return contentPane;
    }

    @Override
    protected void doOKAction() {
        super.doOKAction();
        this.listener.onGenerateBlocTestClicked(
                GenerateRxBlocTestDialog.TestLibrary.values()[testLibrarySelection.getSelectedIndex()]
        );
    }

    public enum TestLibrary {
        Alchemist, GoldenToolkit
    }

    public interface Listener {
        void onGenerateBlocTestClicked(
                GenerateRxBlocTestDialog.TestLibrary selectedTestLibrary
        );
    }
}
