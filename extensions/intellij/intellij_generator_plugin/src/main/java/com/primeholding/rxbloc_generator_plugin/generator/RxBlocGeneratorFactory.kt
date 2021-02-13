package com.primeholding.rxbloc_generator_plugin.generator

import com.primeholding.rxbloc_generator_plugin.generator.components.RxGeneratedBlocGenerator

object RxBlocGeneratorFactory {
    fun getBlocGenerators(name: String, useEquatable: Boolean): List<RxBlocGeneratorBase> {
        val bloc = com.primeholding.rxbloc_generator_plugin.generator.components.RxBlocGenerator(name, useEquatable)
        val generatedBloc = RxGeneratedBlocGenerator(name, useEquatable)
        return listOf(bloc, generatedBloc)
    }
}