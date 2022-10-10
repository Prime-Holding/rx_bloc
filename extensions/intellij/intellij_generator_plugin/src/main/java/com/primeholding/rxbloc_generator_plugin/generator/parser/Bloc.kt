package com.primeholding.rxbloc_generator_plugin.generator.parser

///path - relative to the lib folder + list of items that the bloc uses.
data class Bloc(
    val fileName: String,
    val relativePath: String,
    val stateVariableNames: List<String>,
    val stateVariableTypes: List<String>,
    val stateIsConnectableStream: List<Boolean>,
    val repos: MutableList<String>,
    val services: MutableList<String>,
    val constructorFieldNames: MutableList<String>,
    val constructorFieldNamedNames: MutableMap<String, Boolean>,
    val constructorFieldTypes: MutableList<String>,
    val isLib: Boolean
)