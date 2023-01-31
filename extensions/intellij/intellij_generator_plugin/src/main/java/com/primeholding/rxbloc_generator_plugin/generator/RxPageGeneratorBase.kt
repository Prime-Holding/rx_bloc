@file:Suppress("PrivatePropertyName")

package com.primeholding.rxbloc_generator_plugin.generator

import com.google.common.io.CharStreams
import org.apache.commons.lang.text.StrSubstitutor
import java.io.InputStreamReader
import java.lang.RuntimeException

abstract class RxPageGeneratorBase(
    name: String,
    withDefaultStates: Boolean,
    includeAutoRoute: Boolean,
    templateName: String
) : RxGeneratorBase(name) {

    private val TEMPLATE_FEATURE_PASCAL_CASE = "feature_pascal_case"
    private val TEMPLATE_FEATURE_SNAKE_CASE = "feature_snake_case"

    private val includeAutoRouteFlag: Boolean
    private val templateString: String
    private val templateValues: MutableMap<String, String> = mutableMapOf(
        TEMPLATE_FEATURE_PASCAL_CASE to pascalCase(),
        TEMPLATE_FEATURE_SNAKE_CASE to snakeCase()
    )

    init {
        includeAutoRouteFlag = includeAutoRoute
        try {
            val templateFolder = StringBuilder()

            if (withDefaultStates) {
                templateFolder.append("views_with_default_states")
            } else {
                templateFolder.append("views")
            }

            val resource = "/templates/${templateFolder}/$templateName.dart.template"
            val resourceAsStream = RxBlocGeneratorBase::class.java.getResourceAsStream(resource)
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