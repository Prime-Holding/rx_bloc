package com.primeholding.rxbloc_generator_plugin.generator.components

import com.primeholding.rxbloc_generator_plugin.generator.RxListBlocGeneratorBase

class RxBlocListExtensionGenerator(
    blocName: String
) : RxListBlocGeneratorBase(
    blocName,
    templateName = "rx_list_bloc_extensions"
) {

    override fun fileName() = "${snakeCase()}_list_bloc_extensions.${fileExtension()}"
    override fun contextDirectoryName(): String = "rx_list_bloc"
}