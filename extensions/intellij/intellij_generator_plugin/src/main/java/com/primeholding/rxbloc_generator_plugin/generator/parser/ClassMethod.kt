package com.primeholding.rxbloc_generator_plugin.generator.parser

data class ClassMethod(
    val name: String,
    val returnedType: String,
    val constructorFieldNames: MutableList<String>,
    val constructorFieldNamedNames: MutableMap<String, Boolean>,
    val constructorFieldTypes: MutableList<String>
)