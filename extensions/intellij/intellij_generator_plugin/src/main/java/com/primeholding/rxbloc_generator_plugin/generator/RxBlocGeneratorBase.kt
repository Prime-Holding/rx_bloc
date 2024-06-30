@file:Suppress("PrivatePropertyName")

package com.primeholding.rxbloc_generator_plugin.generator

import com.google.common.io.CharStreams
import org.apache.commons.text.StringSubstitutor
import java.io.InputStreamReader
import java.lang.RuntimeException

abstract class RxBlocGeneratorBase(
    name: String,
    withDefaultStates: Boolean,
    includeLocalService: Boolean,
    templateName: String
) : RxGeneratorBase(name) {

    private val TEMPLATE_BLOC_DOLLAR_PASCAL_CASE = "bloc_dollar_pascal_case"
    private val TEMPLATE_BLOC_PASCAL_CASE = "bloc_pascal_case"
    private val TEMPLATE_BLOC_SNAKE_CASE = "bloc_snake_case"
    private val TEMPLATE_BLOC_VARIABLE_CASE = "variable_case"

    private val templateString: String
    private val templateValues: MutableMap<String, String>

    init {
        templateValues = mutableMapOf(
            TEMPLATE_BLOC_PASCAL_CASE to pascalCase(),
            TEMPLATE_BLOC_DOLLAR_PASCAL_CASE to dollarPascalCase(),
            TEMPLATE_BLOC_SNAKE_CASE to snakeCase(),
            TEMPLATE_BLOC_VARIABLE_CASE to variableCase()
        )
        try {
            val templateFolder = StringBuilder()
            if (withDefaultStates) {
                if (includeLocalService) {
                    templateFolder.append("rx_bloc_with_default_states")
                } else {
                    templateFolder.append("rx_bloc_with_extensions_with_default_states")
                }
            } else {
                if (includeLocalService) {
                    templateFolder.append("rx_bloc")
                } else {
                    templateFolder.append("rx_bloc_with_extensions")
                }
            }

            val resource = "/templates/${templateFolder}/$templateName.dart.template"
            println(resource)
            val resourceAsStream = RxBlocGeneratorBase::class.java.getResourceAsStream(resource)
            templateString = CharStreams.toString(InputStreamReader(resourceAsStream, Charsets.UTF_8))
        } catch (e: Exception) {
            throw RuntimeException(e)
        }
    }

    override fun generate(): String {
        val substitute = StringSubstitutor(templateValues)
        return substitute.replace(templateString)
    }

    private fun dollarPascalCase(): String = "$" + pascalCase()
}