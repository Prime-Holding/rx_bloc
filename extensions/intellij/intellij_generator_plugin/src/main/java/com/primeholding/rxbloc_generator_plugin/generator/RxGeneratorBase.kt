package com.primeholding.rxbloc_generator_plugin.generator

import com.fleshgrinder.extensions.kotlin.toLowerCamelCase
import com.fleshgrinder.extensions.kotlin.toLowerSnakeCase
import com.fleshgrinder.extensions.kotlin.toUpperCamelCase

abstract class RxGeneratorBase(private val name: String) {

    abstract fun fileName(): String
    abstract fun contextDirectoryName(): String

    abstract fun generate(): String

    fun variableCase(): String = name.toLowerCamelCase().replace("Bloc", "")
    fun pascalCase(): String = name.toUpperCamelCase().replace("Bloc", "")
    fun snakeCase() = name.toLowerSnakeCase().replace("_bloc", "")
    fun featureDirectoryName() = "feature_" + snakeCase()
    fun fileExtension() = "dart"
}