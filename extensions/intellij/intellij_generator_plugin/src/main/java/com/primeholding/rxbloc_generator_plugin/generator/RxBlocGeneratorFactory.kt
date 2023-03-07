package com.primeholding.rxbloc_generator_plugin.generator

import com.primeholding.rxbloc_generator_plugin.generator.components.RxBlocExtensionGenerator
import com.primeholding.rxbloc_generator_plugin.generator.components.RxBlocWithServiceGenerator
import com.primeholding.rxbloc_generator_plugin.generator.components.RxGeneratedNullSafetyBlocGenerator

object RxBlocGeneratorFactory {
    fun getBlocGenerators(
        name: String,
        withDefaultStates: Boolean,
        includeLocalService: Boolean
    ): List<RxGeneratorBase> {
        val bloc = com.primeholding.rxbloc_generator_plugin.generator.components.RxBlocGenerator(
            name,
            withDefaultStates,
            includeLocalService
        )

        val generatedBloc =
            RxGeneratedNullSafetyBlocGenerator(
                name,
                withDefaultStates,
                includeLocalService
            )

        return if (includeLocalService) {
            val blocExtensions = RxBlocWithServiceGenerator(
                name
            )
            listOf(bloc, generatedBloc, blocExtensions)
        } else {
            val blocExtensions = RxBlocExtensionGenerator(
                name,
                withDefaultStates,
                false
            )
            listOf(bloc, generatedBloc, blocExtensions)
        }
    }
}