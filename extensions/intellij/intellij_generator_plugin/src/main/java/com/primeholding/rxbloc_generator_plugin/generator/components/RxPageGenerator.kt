package com.primeholding.rxbloc_generator_plugin.generator.components

import com.primeholding.rxbloc_generator_plugin.generator.RxPageGeneratorBase

class RxPageGenerator(
    name: String,
    withDefaultStates: Boolean,
    includeAutoRoute: Boolean
) : RxPageGeneratorBase(
    name,
    withDefaultStates,
    includeAutoRoute,
    templateName = "${if (includeAutoRoute) "" else "no_autoroute_"}page"
) {
    override fun fileName() = "${snakeCase()}_page.${fileExtension()}"
    override fun contextDirectoryName(): String = "views"
}