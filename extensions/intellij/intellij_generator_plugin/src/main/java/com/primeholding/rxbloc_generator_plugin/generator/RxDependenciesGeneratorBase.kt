package com.primeholding.rxbloc_generator_plugin.generator

import com.google.common.io.CharStreams
import com.fleshgrinder.extensions.kotlin.*
import org.apache.commons.lang.text.StrSubstitutor
import java.io.InputStreamReader
import java.lang.RuntimeException

abstract class RxDependenciesGeneratorBase(private val name: String,
                                           templateName: String): RxGeneratorBase(name) {

    private val TEMPLATE_FEATURE_PASCAL_CASE = "feature_pascal_case"
    private val TEMPLATE_FEATURE_SNAKE_CASE = "feature_snake_case"

    private val templateString: String
    private val templateValues: MutableMap<String, String>

    init {
        templateValues = mutableMapOf(
            TEMPLATE_FEATURE_PASCAL_CASE to pascalCase(),
            TEMPLATE_FEATURE_SNAKE_CASE to snakeCase()
        )
        try {
            val resource = "/templates/di/dependencies.dart.template"
            val resourceAsStream = RxDependenciesGeneratorBase::class.java.getResourceAsStream(resource)
            templateString = CharStreams.toString(InputStreamReader(resourceAsStream, Charsets.UTF_8))
        } catch (e: Exception) {
            throw RuntimeException(e)
        }
    }

    override fun generate(): String {
        val substitutor = StrSubstitutor(templateValues)
        return substitutor.replace(templateString)
    }
}