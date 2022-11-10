package com.primeholding.rxbloc_generator_plugin.generator.components

import com.primeholding.rxbloc_generator_plugin.generator.RxTestGeneratorBase
import com.primeholding.rxbloc_generator_plugin.generator.parser.Bloc

class RxTestBlocGenerator(name: String, projectName: String, bloc: Bloc, includeDiMocks: Boolean) :
    RxTestGeneratorBase(
        name,
        templateName = "bloc_test",
        projectName = projectName,
        bloc = bloc,
        includeDiMocks = includeDiMocks
    ) {

    override fun fileName() = "${snakeCase()}_bloc_test.${fileExtension()}"
    override fun contextDirectoryName(): String = "blocs"
}