package com.primeholding.rxbloc_generator_plugin.generator.components

import com.primeholding.rxbloc_generator_plugin.generator.RxTestGeneratorBase
import com.primeholding.rxbloc_generator_plugin.generator.parser.Bloc

class RxTestBlocGoldenGenerator(val name: String, projectName: String, bloc: Bloc) :
RxTestGeneratorBase(name, templateName = "bloc_golden", projectName = projectName, bloc = bloc) {

    override fun fileName() = "${snakeCase()}_golden.${fileExtension()}"
    override fun contextDirectoryName(): String = "view"
}