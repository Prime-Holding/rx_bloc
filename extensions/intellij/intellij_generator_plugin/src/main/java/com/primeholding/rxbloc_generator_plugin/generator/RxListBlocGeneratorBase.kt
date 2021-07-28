package com.primeholding.rxbloc_generator_plugin.generator

import com.google.common.io.CharStreams
import com.fleshgrinder.extensions.kotlin.*
import org.apache.commons.lang.text.StrSubstitutor
import java.io.InputStreamReader
import java.lang.RuntimeException

abstract class RxListBlocGeneratorBase(private val name: String,
                                       templateName: String): RxGeneratorBase(name) {

    private val TEMPLATE_BLOC_DOLLAR_PASCAL_CASE = "bloc_dollar_pascal_case"
    private val TEMPLATE_BLOC_PASCAL_CASE = "bloc_pascal_case"
    private val TEMPLATE_BLOC_SNAKE_CASE = "bloc_snake_case"

    private val templateString: String
    private val templateValues: MutableMap<String, String>

    init {
        templateValues = mutableMapOf(
            TEMPLATE_BLOC_PASCAL_CASE to pascalCase(),
            TEMPLATE_BLOC_DOLLAR_PASCAL_CASE to dollarPascalCase(),
            TEMPLATE_BLOC_SNAKE_CASE to snakeCase()
        )
        try {
            val resource = "/templates/rx_list_bloc/$templateName.dart.template"
            val resourceAsStream = RxListBlocGeneratorBase::class.java.getResourceAsStream(resource)
            templateString = CharStreams.toString(InputStreamReader(resourceAsStream, Charsets.UTF_8))
        } catch (e: Exception) {
            throw RuntimeException(e)
        }
    }

    override fun generate(): String {
        val substitutor = StrSubstitutor(templateValues)
        return substitutor.replace(templateString)
    }

    private fun dollarPascalCase(): String = "$" + pascalCase()
}