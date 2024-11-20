package com.primeholding.rxbloc_generator_plugin.generator.components

import com.primeholding.rxbloc_generator_plugin.generator.RxTestGeneratorBase
import com.primeholding.rxbloc_generator_plugin.generator.parser.TestableClass

class RxTestBlocFactoryGenerator(name: String,val templateName: String, val projectName: String, bloc: TestableClass) :
    RxTestGeneratorBase(name, templateName = templateName, projectName = projectName, bloc = bloc) {

    override fun fileName() = "${snakeCase()}_bloc_test.${fileExtension()}"
    override fun contextDirectoryName(): String = "factory"
}