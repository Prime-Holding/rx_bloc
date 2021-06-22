package com.primeholding.rxbloc_generator_plugin.generator.components

import com.primeholding.rxbloc_generator_plugin.generator.RxDependenciesGeneratorBase

class RxDependenciesGenerator(
    name: String,
    withDefaultStates: Boolean,
    includeExtensions: Boolean,
    includeNullSafety: Boolean
) : RxDependenciesGeneratorBase(
    name,
    withDefaultStates,
    includeExtensions,
    includeNullSafety,
    templateName = "dependencies"
) {
    override fun fileName() = "${snakeCase()}_dependencies.${fileExtension()}"
    override fun contextDirectoryName(): String = "di"
}