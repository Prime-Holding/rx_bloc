package com.primeholding.rxbloc_generator_plugin.generator.components

import com.primeholding.rxbloc_generator_plugin.generator.RxBlocGeneratorBase

class RxBlocExtensionGenerator(
    blocName: String,
    blocShouldUseEquatable: Boolean,
    includeExtensions: Boolean,
    includeNullSafety: Boolean
) : RxBlocGeneratorBase(
    blocName,
    blocShouldUseEquatable,
    includeExtensions,
    includeNullSafety,
    templateName = "rx_bloc_extensions"
) {

    override fun fileName() = "${snakeCase()}_bloc_extensions.${fileExtension()}"
    override fun contextDirectoryName(): String = "blocs"
}