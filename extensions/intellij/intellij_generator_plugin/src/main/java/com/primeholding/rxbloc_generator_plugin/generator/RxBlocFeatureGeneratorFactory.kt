package com.primeholding.rxbloc_generator_plugin.generator

object RxBlocFeatureGeneratorFactory {
    fun getBlocGenerators(
        name: String,
        withDefaultStates: Boolean,
        includeExtensions: Boolean,
        includeNullSafety: Boolean
    ): List<RxGeneratorBase> {

        val blocClasses = RxBlocGeneratorFactory.getBlocGenerators(name, withDefaultStates, includeExtensions, includeNullSafety)

        val dependencies = com.primeholding.rxbloc_generator_plugin.generator.components.RxDependenciesGenerator(
            name,
            withDefaultStates,
            includeExtensions,
            includeNullSafety)

        val page = com.primeholding.rxbloc_generator_plugin.generator.components.RxPageGenerator(
            name,
            withDefaultStates,
            includeExtensions,
            includeNullSafety)


        return blocClasses + listOf(dependencies, page)
    }
}