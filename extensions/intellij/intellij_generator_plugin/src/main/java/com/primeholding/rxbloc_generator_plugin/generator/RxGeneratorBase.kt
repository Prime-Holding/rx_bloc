package com.primeholding.rxbloc_generator_plugin.generator

import com.google.common.io.CharStreams
import com.fleshgrinder.extensions.kotlin.*
import org.apache.commons.lang.text.StrSubstitutor
import java.io.InputStreamReader
import java.lang.RuntimeException

abstract class RxGeneratorBase(private val name: String,
                               withDefaultStates: Boolean,
                               includeExtensions: Boolean,
                               includeNullSafety: Boolean,
                               templateName: String) {

    abstract fun fileName(): String
    abstract fun contextDirectoryName(): String

    abstract fun generate(): String

    fun pascalCase(): String = name.toUpperCamelCase().replace("Bloc", "")
    fun snakeCase() = name.toLowerSnakeCase().replace("_bloc", "")
    fun featureDirectoryName() = "feature_" + snakeCase()
    fun fileExtension() = "dart"
}