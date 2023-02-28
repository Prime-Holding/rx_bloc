package com.primeholding.rxbloc_generator_plugin.generator.components

import com.primeholding.rxbloc_generator_plugin.generator.RxBlocGeneratorBase

class RxBlocGenerator(
    name: String,
    withDefaultStates: Boolean,
    includeLocalService: Boolean
) : RxBlocGeneratorBase(
    name,
    withDefaultStates,
    includeLocalService,
    templateName = if (includeLocalService) "rx_bloc_with_service" else "rx_bloc"
) {
    override fun fileName() = "${snakeCase()}_bloc.${fileExtension()}"
    override fun contextDirectoryName(): String = "blocs"
}