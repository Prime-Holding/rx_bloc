package com.primeholding.rxbloc_generator_plugin.ui;

import com.android.annotations.Nullable;
import com.intellij.openapi.ui.ComboBox;
import com.intellij.openapi.ui.DialogWrapper;

import javax.swing.*;
import java.awt.*;

public class ChooseDialog extends DialogWrapper {

    private final JPanel content;

    public ChooseDialog(JPanel comboBox, String typeOfStuffToChoose) {
        super(true);
        this.content = comboBox;
        setTitle("Choose " + typeOfStuffToChoose);
        setModal(true);
        setOKButtonText("Choose");
        init();
    }

    @Nullable
    @Override
    protected JComponent createCenterPanel() {
        JPanel dialogPanel = new JPanel(new BorderLayout());

        dialogPanel.add(content, BorderLayout.CENTER);

        return dialogPanel;
    }
}