package com.primeholding.rxbloc_generator_plugin.generator.components

import com.primeholding.rxbloc_generator_plugin.generator.RxBlocGeneratorBase

class RxGeneratedNullSafetyBlocGenerator(
    blocName: String,
    blocShouldUseEquatable: Boolean,
    includeExtensions: Boolean,
    includeNullSafety: Boolean
) : RxBlocGeneratorBase(
    blocName,
    blocShouldUseEquatable,
    includeExtensions,
    includeNullSafety,
    templateName = "rx_bloc_generated_null_safety"
) {

    override fun fileName() = "${snakeCase()}_bloc.rxb.g.${fileExtension()}"
}