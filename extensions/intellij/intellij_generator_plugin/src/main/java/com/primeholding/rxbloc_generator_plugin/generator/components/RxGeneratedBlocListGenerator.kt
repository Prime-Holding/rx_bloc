package com.primeholding.rxbloc_generator_plugin.generator.components

import com.primeholding.rxbloc_generator_plugin.generator.RxListBlocGeneratorBase

class RxGeneratedBlocListGenerator(
    name: String
) : RxListBlocGeneratorBase(
    name,
    templateName = "rx_list_bloc_generated_null_safety"
) {
    override fun fileName() = "${snakeCase()}_list_bloc.rxb.g.${fileExtension()}"
    override fun contextDirectoryName(): String = "rx_list_bloc"
}