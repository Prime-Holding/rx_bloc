package com.primeholding.rxbloc_generator_plugin.generator.components

import com.primeholding.rxbloc_generator_plugin.action.GenerateRxBlocDialog.RoutingIntegration
import com.primeholding.rxbloc_generator_plugin.generator.RxDependenciesGeneratorBase

class RxDependenciesGenerator(
    name: String,
    routingIntegration: RoutingIntegration,
    includeLocalService: Boolean
) : RxDependenciesGeneratorBase(
    name,
    routingIntegration = routingIntegration,
    includeLocalService = includeLocalService
) {
    override fun fileName() =
        "${snakeCase()}_${if (routingIntegrationFlag == RoutingIntegration.AutoRoute) "" else "page_with_"}dependencies.${fileExtension()}"

    override fun contextDirectoryName(): String = "di"
}