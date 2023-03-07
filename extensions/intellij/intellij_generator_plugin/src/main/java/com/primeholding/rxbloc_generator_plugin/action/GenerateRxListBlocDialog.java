package com.primeholding.rxbloc_generator_plugin.action;

import com.intellij.openapi.ui.DialogWrapper;

import org.jetbrains.annotations.Nullable;

import javax.swing.JComponent;
import javax.swing.JPanel;
import javax.swing.JTextField;

public class GenerateRxListBlocDialog extends DialogWrapper {

    private final Listener listener;
    private JTextField blocNameTextField;
    private JPanel contentPanel;

    public GenerateRxListBlocDialog(final Listener listener) {
        super(null);
        this.listener = listener;
        init();
        setTitle("Create RxBloc List");
    }

    @Nullable
    @Override
    protected JComponent createCenterPanel() {
        return contentPanel;
    }

    @Override
    protected void doOKAction() {
        super.doOKAction();
        this.listener.onGenerateBlocClicked(
                blocNameTextField.getText()
        );
    }

    @Nullable
    @Override
    public JComponent getPreferredFocusedComponent() {
        return blocNameTextField;
    }

    public interface Listener {
        void onGenerateBlocClicked(
                String blocName
        );
    }
}
