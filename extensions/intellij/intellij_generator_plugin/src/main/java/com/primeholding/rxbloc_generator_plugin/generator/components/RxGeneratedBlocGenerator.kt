package com.primeholding.rxbloc_generator_plugin.generator.components

import com.primeholding.rxbloc_generator_plugin.generator.RxBlocGeneratorBase

class RxGeneratedBlocGenerator(
    blocName: String,
    withDefaultStates: Boolean,
    includeExtensions: Boolean
) : RxBlocGeneratorBase(
    blocName,
    withDefaultStates,
    includeExtensions,
    templateName = "rx_bloc_generated"
) {

    override fun fileName() = "${snakeCase()}_bloc.rxb.g.${fileExtension()}"
    override fun contextDirectoryName(): String = "blocs"
}