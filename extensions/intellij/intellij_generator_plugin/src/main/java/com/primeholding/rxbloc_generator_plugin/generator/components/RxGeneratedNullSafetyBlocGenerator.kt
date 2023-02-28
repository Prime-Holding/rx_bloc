package com.primeholding.rxbloc_generator_plugin.generator.components

import com.primeholding.rxbloc_generator_plugin.generator.RxBlocGeneratorBase

class RxGeneratedNullSafetyBlocGenerator(
    blocName: String,
    withDefaultStates: Boolean,
    includeLocalService: Boolean
) : RxBlocGeneratorBase(
    blocName,
    withDefaultStates,
    includeLocalService,
    templateName = "rx_bloc_generated_null_safety"
) {

    override fun fileName() = "${snakeCase()}_bloc.rxb.g.${fileExtension()}"
    override fun contextDirectoryName(): String = "blocs"
}