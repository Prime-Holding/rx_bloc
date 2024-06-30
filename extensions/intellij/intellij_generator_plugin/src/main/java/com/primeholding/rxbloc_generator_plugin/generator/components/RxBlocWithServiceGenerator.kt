@file:Suppress("PrivatePropertyName")

package com.primeholding.rxbloc_generator_plugin.generator.components

import com.google.common.io.CharStreams
import com.primeholding.rxbloc_generator_plugin.generator.RxBlocGeneratorBase
import com.primeholding.rxbloc_generator_plugin.generator.RxGeneratorBase
import org.apache.commons.text.StringSubstitutor
import java.io.InputStreamReader
import java.lang.RuntimeException

class RxBlocWithServiceGenerator(
    blocName: String
) : RxGeneratorBase(
    blocName
) {

    private val templateString: String
    private val templateValues: MutableMap<String, String>

    private val TEMPLATE_BLOC_PASCAL_CASE = "bloc_pascal_case"
    private val TEMPLATE_BLOC_SNAKE_CASE = "bloc_snake_case"

    init {
        templateValues = mutableMapOf(
            TEMPLATE_BLOC_PASCAL_CASE to pascalCase(),
            TEMPLATE_BLOC_SNAKE_CASE to snakeCase()
        )
        try {
            val resource = "/templates/rx_bloc_service/rx_bloc_service.dart.template"
            val resourceAsStream = RxBlocGeneratorBase::class.java.getResourceAsStream(resource)
            templateString = CharStreams.toString(InputStreamReader(resourceAsStream, Charsets.UTF_8))
        } catch (e: Exception) {
            throw RuntimeException(e)
        }
    }

    override fun fileName() = "${snakeCase()}_service.${fileExtension()}"
    override fun contextDirectoryName(): String = "services"

    override fun generate(): String {
        val substitute = StringSubstitutor(templateValues)
        return substitute.replace(templateString)
    }
}