package com.primeholding.rxbloc_generator_plugin.action;

import com.intellij.openapi.ui.DialogWrapper;
import org.jetbrains.annotations.Nullable;

import javax.swing.*;

public class GenerateRxBlocDialog extends DialogWrapper {

    private final Listener listener;
    private JTextField blocNameTextField;
    private JCheckBox withDefaultStates;
    private JPanel contentPanel;
    private JCheckBox includeLocalService;
    @SuppressWarnings("unused")
    private JLabel routingIntegration;
    private JComboBox<String> routingIntegrationSelection;

    public GenerateRxBlocDialog(final Listener listener, boolean hideAutoRoute) {
        super(null);
        this.listener = listener;
        if (hideAutoRoute) {
            routingIntegration.setVisible(false);
            routingIntegrationSelection.setVisible(false);
            routingIntegrationSelection.setSelectedIndex(RoutingIntegration.None.ordinal());
        } else {
            routingIntegrationSelection.setSelectedIndex(RoutingIntegration.GoRouter.ordinal());
        }
        init();
    }

    public GenerateRxBlocDialog(final Listener listener) {
        super(null);
        this.listener = listener;
        init();
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
                blocNameTextField.getText(),
                withDefaultStates.isSelected(),
                includeLocalService.isSelected(),
                RoutingIntegration.values()[routingIntegrationSelection.getSelectedIndex()]
        );
    }

    @Nullable
    @Override
    public JComponent getPreferredFocusedComponent() {
        return blocNameTextField;
    }

    public enum RoutingIntegration {
        GoRouter, AutoRoute, None
    }

    public interface Listener {
        void onGenerateBlocClicked(
                String blocName,
                boolean withDefaultStates,
                boolean includeLocalService,
                RoutingIntegration selectedRoutingIntegration
        );
    }
}