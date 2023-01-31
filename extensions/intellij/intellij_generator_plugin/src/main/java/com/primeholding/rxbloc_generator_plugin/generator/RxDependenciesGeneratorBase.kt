@file:Suppress("PrivatePropertyName")

package com.primeholding.rxbloc_generator_plugin.generator

import com.google.common.io.CharStreams
import org.apache.commons.lang.text.StrSubstitutor
import java.io.InputStreamReader
import java.lang.RuntimeException

abstract class RxDependenciesGeneratorBase(
    name: String,
    includeAutoRoute: Boolean
) : RxGeneratorBase(name) {

    private val TEMPLATE_FEATURE_PASCAL_CASE = "feature_pascal_case"
    private val TEMPLATE_FEATURE_SNAKE_CASE = "feature_snake_case"

    private val templateString: String
    protected val includeAutoRouteFlag: Boolean
    private val templateValues: MutableMap<String, String> = mutableMapOf(
        TEMPLATE_FEATURE_PASCAL_CASE to pascalCase(),
        TEMPLATE_FEATURE_SNAKE_CASE to snakeCase()
    )

    init {
        this.includeAutoRouteFlag = includeAutoRoute

        try {
            val resource = "/templates/di/${if (includeAutoRouteFlag) "" else "with_"}dependencies.dart.template"
            println(resource)
            val resourceAsStream = RxDependenciesGeneratorBase::class.java.getResourceAsStream(resource)
            templateString = CharStreams.toString(InputStreamReader(resourceAsStream, Charsets.UTF_8))
        } catch (e: Exception) {
            throw RuntimeException(e)
        }
    }

    override fun generate(): String {
        val substitute = StrSubstitutor(templateValues)
        return substitute.replace(templateString)
    }
}