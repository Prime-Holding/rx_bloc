package com.primeholding.rxbloc_generator_plugin.generator

import com.primeholding.rxbloc_generator_plugin.generator.components.*

object RxListBlocGeneratorFactory {
    fun getBlocGenerators(
        name: String
    ): List<RxGeneratorBase> {
        return listOf(RxBlocListGenerator(name), RxBlocListExtensionGenerator(name), RxGeneratedBlocListGenerator(name))
    }
}