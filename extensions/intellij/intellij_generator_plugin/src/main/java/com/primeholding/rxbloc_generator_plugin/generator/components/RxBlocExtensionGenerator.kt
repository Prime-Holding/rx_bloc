package com.primeholding.rxbloc_generator_plugin.generator.components

import com.primeholding.rxbloc_generator_plugin.generator.RxBlocGeneratorBase

class RxBlocExtensionGenerator(
    blocName: String,
    withDefaultStates: Boolean,
    includeLocalService: Boolean
) : RxBlocGeneratorBase(
    blocName,
    withDefaultStates,
    includeLocalService,
    templateName = "rx_bloc_extensions"
) {

    override fun fileName() = "${snakeCase()}_bloc_extensions.${fileExtension()}"
    override fun contextDirectoryName(): String = "blocs"
}