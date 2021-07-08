package com.primeholding.rxbloc_generator_plugin.intention_action;

import org.jetbrains.annotations.NotNull;

public class BlocWrapWithBlocResultBuilderIntentionAction extends BlocWrapWithIntentionAction {
    public BlocWrapWithBlocResultBuilderIntentionAction() {
        super(SnippetType.RxResultBuilder);
    }

    /**
     * If this action is applicable, returns the text to be shown in the list of intention actions available.
     */
    @NotNull
    public String getText() {
        return "Wrap with RxResultBuilder";
    }
}
