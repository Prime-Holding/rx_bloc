package com.primeholding.rxbloc_generator_plugin.generator.components

import com.primeholding.rxbloc_generator_plugin.parser.Bloc
import com.primeholding.rxbloc_generator_plugin.generator.RxTestGeneratorBase

class RxTestBlocGenerator(name: String, projectName: String, bloc: Bloc) :
    RxTestGeneratorBase(name, templateName = "bloc_test", projectName = projectName, bloc = bloc) {

    override fun fileName() = "${snakeCase()}_bloc_test.${fileExtension()}"
    override fun contextDirectoryName(): String = "blocs"
}