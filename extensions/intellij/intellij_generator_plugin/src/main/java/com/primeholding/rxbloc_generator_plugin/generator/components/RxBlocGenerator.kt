package com.primeholding.rxbloc_generator_plugin.generator.components

import com.primeholding.rxbloc_generator_plugin.generator.RxBlocGeneratorBase

class RxBlocGenerator(
    name: String,
    withDefaultStates: Boolean,
    includeExtensions: Boolean
) : RxBlocGeneratorBase(
    name,
    withDefaultStates,
    includeExtensions,
    templateName = "rx_bloc"
) {
    override fun fileName() = "${snakeCase()}_bloc.${fileExtension()}"
    override fun contextDirectoryName(): String = "blocs"
}