package com.primeholding.rxbloc_generator_plugin.generator.components

import com.primeholding.rxbloc_generator_plugin.generator.RxDependenciesGeneratorBase

class RxDependenciesGenerator(
    name: String,
    includeAutoRoute: Boolean
) : RxDependenciesGeneratorBase(
    name,
    includeAutoRoute = includeAutoRoute
) {
    override fun fileName() =
        "${snakeCase()}_${if (includeAutoRouteFlag) "" else "page_with_"}dependencies.${fileExtension()}"

    override fun contextDirectoryName(): String = "di"
}