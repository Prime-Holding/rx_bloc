package com.primeholding.rxbloc_generator_plugin.generator

object RxBlocFeatureGeneratorFactory {
    fun getBlocGenerators(
        name: String,
        withDefaultStates: Boolean,
        includeLocalService: Boolean,
        includeAutoRoute: Boolean
    ): List<RxGeneratorBase> {

        val blocClasses =
            RxBlocGeneratorFactory.getBlocGenerators(name, withDefaultStates, includeLocalService, includeAutoRoute)

        val dependencies = com.primeholding.rxbloc_generator_plugin.generator.components.RxDependenciesGenerator(
            name,
            includeAutoRoute,
            includeLocalService
        )

        val page = com.primeholding.rxbloc_generator_plugin.generator.components.RxPageGenerator(
            name,
            withDefaultStates,
            includeAutoRoute
        )

        return blocClasses + listOf(dependencies, page)
    }
}