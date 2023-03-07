package com.primeholding.rxbloc_generator_plugin.generator.components

import com.primeholding.rxbloc_generator_plugin.generator.RxTestGeneratorBase
import com.primeholding.rxbloc_generator_plugin.generator.parser.TestableClass

class RxTestBlocMockGenerator(val name: String, projectName: String, bloc: TestableClass) :
    RxTestGeneratorBase(name, templateName = "bloc_mock", projectName = projectName, bloc = bloc) {

    override fun fileName() = "${snakeCase()}_mock.${fileExtension()}"
    override fun contextDirectoryName(): String = "mock"
}