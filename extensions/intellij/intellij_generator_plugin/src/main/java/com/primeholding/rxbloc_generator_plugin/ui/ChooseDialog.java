package com.primeholding.rxbloc_generator_plugin.ui;

import com.android.annotations.Nullable;
import com.intellij.openapi.ui.ComboBox;
import com.intellij.openapi.ui.DialogWrapper;

import javax.swing.*;
import java.awt.*;

public class ChooseDialog<T> extends DialogWrapper {

    private final ComboBox<T> comboBox;

    public ChooseDialog(ComboBox<T> comboBox, String typeOfStuffToChoose) {
        super(true);
        this.comboBox = comboBox;
        setTitle("Choose " + typeOfStuffToChoose);
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