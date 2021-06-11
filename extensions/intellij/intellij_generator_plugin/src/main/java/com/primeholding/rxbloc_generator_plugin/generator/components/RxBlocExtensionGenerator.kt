package com.primeholding.rxbloc_generator_plugin.generator.components

import com.primeholding.rxbloc_generator_plugin.generator.RxBlocGeneratorBase

class RxBlocExtensionGenerator(
    blocName: String,
    withDefaultStates: Boolean,
    includeExtensions: Boolean,
    includeNullSafety: Boolean
) : RxBlocGeneratorBase(
    blocName,
    withDefaultStates,
    includeExtensions,
    includeNullSafety,
    templateName = "rx_bloc_extensions"
) {

    override fun fileName() = "${snakeCase()}_bloc_extensions.${fileExtension()}"
    override fun contextDirectoryName(): String = "blocs"
}