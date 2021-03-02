package com.primeholding.rxbloc_generator_plugin.generator.components

import com.primeholding.rxbloc_generator_plugin.generator.RxBlocGeneratorBase

class RxBlocExtensionGenerator(
    blocName: String,
    blocShouldUseEquatable: Boolean,
    includeExtensions: Boolean
) : RxBlocGeneratorBase(blocName, blocShouldUseEquatable, includeExtensions, templateName = "rx_bloc_extensions") {

    override fun fileName() = "${snakeCase()}_bloc_extensions.${fileExtension()}"
}