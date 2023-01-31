package com.primeholding.rxbloc_generator_plugin.generator

import com.primeholding.rxbloc_generator_plugin.generator.components.RxBlocExtensionGenerator
import com.primeholding.rxbloc_generator_plugin.generator.components.RxGeneratedBlocGenerator
import com.primeholding.rxbloc_generator_plugin.generator.components.RxGeneratedNullSafetyBlocGenerator

object RxBlocGeneratorFactory {
    fun getBlocGenerators(
        name: String,
        withDefaultStates: Boolean,
        includeExtensions: Boolean,
        includeNullSafety: Boolean
    ): List<RxGeneratorBase> {
        val bloc = com.primeholding.rxbloc_generator_plugin.generator.components.RxBlocGenerator(
            name,
            withDefaultStates,
            includeExtensions
        )

        val generatedBloc = if(includeNullSafety) {
            RxGeneratedNullSafetyBlocGenerator(
                name,
                withDefaultStates,
                includeExtensions
            )
        } else {
            RxGeneratedBlocGenerator(
                name,
                withDefaultStates,
                includeExtensions
            )
        }

        if(includeExtensions) {
            val blocExtensions = RxBlocExtensionGenerator(
                name,
                withDefaultStates,
                true
            )
            return listOf(bloc, generatedBloc, blocExtensions)
        }

        return listOf(bloc, generatedBloc)
    }
}