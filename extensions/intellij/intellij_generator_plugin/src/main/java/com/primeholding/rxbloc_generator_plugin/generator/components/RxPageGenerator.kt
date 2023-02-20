package com.primeholding.rxbloc_generator_plugin.generator.components

import com.primeholding.rxbloc_generator_plugin.action.GenerateRxBlocDialog
import com.primeholding.rxbloc_generator_plugin.generator.RxPageGeneratorBase

class RxPageGenerator(
    name: String,
    withDefaultStates: Boolean,
    routingIntegration: GenerateRxBlocDialog.RoutingIntegration
) : RxPageGeneratorBase(
    name,
    withDefaultStates,
    routingIntegration,
    templateName = "${if (routingIntegration == GenerateRxBlocDialog.RoutingIntegration.AutoRoute) "" else "no_autoroute_"}page"
) {
    override fun fileName() = "${snakeCase()}_page.${fileExtension()}"
    override fun contextDirectoryName(): String = "views"
}