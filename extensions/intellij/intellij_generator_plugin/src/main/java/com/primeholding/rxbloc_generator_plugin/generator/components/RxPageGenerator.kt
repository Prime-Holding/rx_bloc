package com.primeholding.rxbloc_generator_plugin.generator.components

import com.primeholding.rxbloc_generator_plugin.generator.RxPageGeneratorBase

class RxPageGenerator(
    name: String,
    withDefaultStates: Boolean,
    includeExtensions: Boolean,
    includeNullSafety: Boolean
) : RxPageGeneratorBase(
    name,
    withDefaultStates,
    includeExtensions,
    includeNullSafety,
    templateName = "page"
) {
    override fun fileName() = "${snakeCase()}_page.${fileExtension()}"
    override fun contextDirectoryName(): String = "views"
}