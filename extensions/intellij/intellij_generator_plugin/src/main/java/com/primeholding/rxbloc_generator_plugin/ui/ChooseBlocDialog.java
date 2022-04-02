package com.primeholding.rxbloc_generator_plugin.ui;

import com.android.annotations.Nullable;
import com.intellij.openapi.ui.ComboBox;
import com.intellij.openapi.ui.DialogWrapper;
import com.primeholding.rxbloc_generator_plugin.parser.Bloc;

import javax.swing.*;
import java.awt.*;

public class ChooseBlocDialog extends DialogWrapper {

    private final ComboBox<String> comboBox;

    public ChooseBlocDialog(ComboBox<String> comboBox) {
        super(true); // use current window as parent
        this.comboBox = comboBox;
        setTitle("Choose Bloc State");
        init();
    }

    @Nullable
    @Override
    protected JComponent createCenterPanel() {
        JPanel dialogPanel = new JPanel(new BorderLayout());

        dialogPanel.add(comboBox, BorderLayout.CENTER);

        return dialogPanel;
    }
}