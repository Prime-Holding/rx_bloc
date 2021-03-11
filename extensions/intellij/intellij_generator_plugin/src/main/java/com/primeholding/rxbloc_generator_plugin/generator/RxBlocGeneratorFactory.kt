package com.primeholding.rxbloc_generator_plugin.generator

import com.primeholding.rxbloc_generator_plugin.generator.components.RxBlocExtensionGenerator
import com.primeholding.rxbloc_generator_plugin.generator.components.RxGeneratedBlocGenerator

object RxBlocGeneratorFactory {
    fun getBlocGenerators(
        name: String,
        useEquatable: Boolean,
        includeExtensions: Boolean,
        includeNullSafety: Boolean
    ): List<RxBlocGeneratorBase> {
        val bloc = com.primeholding.rxbloc_generator_plugin.generator.components.RxBlocGenerator(
            name,
            useEquatable,
            includeExtensions,
            includeNullSafety)
        val generatedBloc = RxGeneratedBlocGenerator(
            name,
            useEquatable,
            includeExtensions,
            includeNullSafety
        )
        if(includeExtensions) {
            val blocExtensions = RxBlocExtensionGenerator(name,
                useEquatable,
                includeExtensions,
                includeNullSafety
            )
            return listOf(bloc, generatedBloc, blocExtensions)
        }
        return listOf(bloc, generatedBloc)
    }
}