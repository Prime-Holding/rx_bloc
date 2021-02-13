package com.primeholding.rxbloc_generator_plugin.generator.components

import com.primeholding.rxbloc_generator_plugin.generator.RxBlocGeneratorBase

class RxBlocGenerator(
    name: String,
    useEquatable: Boolean
) : RxBlocGeneratorBase(name, useEquatable, templateName = "rx_bloc") {
    override fun fileName() = "${snakeCase()}_bloc.${fileExtension()}"
}