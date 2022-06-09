package com.primeholding.rxbloc_generator_plugin.generator.components

import com.primeholding.rxbloc_generator_plugin.generator.RxBlocGeneratorBase

class RxBlocGenerator(
    name: String,
    withDefaultStates: Boolean,
    includeExtensions: Boolean,
    includeNullSafety: Boolean
) : RxBlocGeneratorBase(
    name,
    withDefaultStates,
    includeExtensions,
    includeNullSafety,
    templateName = "rx_bloc"
) {
    override fun fileName() = "${snakeCase()}_bloc.${fileExtension()}"
    override fun contextDirectoryName(): String = "blocs"
}