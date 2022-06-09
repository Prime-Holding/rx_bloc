package com.primeholding.rxbloc_generator_plugin.generator.components

import com.primeholding.rxbloc_generator_plugin.generator.RxListBlocGeneratorBase

class RxBlocListGenerator(
    name: String
) : RxListBlocGeneratorBase(
    name,
    templateName = "rx_list_bloc"
) {
    override fun fileName() = "${snakeCase()}_list_bloc.${fileExtension()}"
    override fun contextDirectoryName(): String = "rx_list_bloc"
}