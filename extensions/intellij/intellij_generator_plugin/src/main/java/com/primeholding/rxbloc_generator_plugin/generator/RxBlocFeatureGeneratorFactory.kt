package com.primeholding.rxbloc_generator_plugin.generator

import com.primeholding.rxbloc_generator_plugin.action.GenerateRxBlocDialog.RoutingIntegration

object RxBlocFeatureGeneratorFactory {
    fun getBlocGenerators(
        name: String,
        withDefaultStates: Boolean,
        includeLocalService: Boolean,
        routingIntegration: RoutingIntegration
    ): List<RxGeneratorBase> {

        val blocClasses =
            RxBlocGeneratorFactory.getBlocGenerators(name, withDefaultStates, includeLocalService)

        val dependencies = com.primeholding.rxbloc_generator_plugin.generator.components.RxDependenciesGenerator(
            name,
            routingIntegration,
            includeLocalService
        )

        val page = com.primeholding.rxbloc_generator_plugin.generator.components.RxPageGenerator(
            name,
            withDefaultStates,
            routingIntegration
        )

        return blocClasses + listOf(dependencies, page)
    }
}