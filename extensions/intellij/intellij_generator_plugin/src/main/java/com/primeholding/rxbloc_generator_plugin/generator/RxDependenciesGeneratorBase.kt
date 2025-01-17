@file:Suppress("PrivatePropertyName")

package com.primeholding.rxbloc_generator_plugin.generator

import com.google.common.io.CharStreams
import com.primeholding.rxbloc_generator_plugin.action.GenerateRxBlocDialog.RoutingIntegration
import org.apache.commons.text.StringSubstitutor
import java.io.InputStreamReader
import java.lang.RuntimeException

abstract class RxDependenciesGeneratorBase(
    name: String,
    routingIntegration: RoutingIntegration,
    includeLocalService: Boolean
) : RxGeneratorBase(name) {

    private val TEMPLATE_FEATURE_PASCAL_CASE = "feature_pascal_case"
    private val TEMPLATE_FEATURE_SNAKE_CASE = "feature_snake_case"

    private val templateString: String
    protected val routingIntegrationFlag: RoutingIntegration = routingIntegration
    private val includeLocalServiceFlag: Boolean = includeLocalService
    private val templateValues: MutableMap<String, String> = mutableMapOf(
        TEMPLATE_FEATURE_PASCAL_CASE to pascalCase(),
        TEMPLATE_FEATURE_SNAKE_CASE to snakeCase()
    )

    init {

        try {
            var prefix = ""
            if (routingIntegration == RoutingIntegration.AutoRoute) {
                if (includeLocalService) {
                    prefix = "autoroute_with_service_"
                }
            } else {
                prefix = "with_"
            }
            val resource =
                "/templates/di/${prefix}dependencies.dart.template"

            val resourceAsStream = RxDependenciesGeneratorBase::class.java.getResourceAsStream(resource)
            templateString = CharStreams.toString(InputStreamReader(resourceAsStream, Charsets.UTF_8))
        } catch (e: Exception) {
            throw RuntimeException(e)
        }
    }

    override fun generate(): String {
        val substitute = StringSubstitutor(templateValues)
        var result = substitute.replace(templateString)
        if (includeLocalServiceFlag) {
            result = result.replace("// ", "")
        }
        return result
    }
}