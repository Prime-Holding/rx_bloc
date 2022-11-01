package com.primeholding.rxbloc_generator_plugin.generator

import com.fleshgrinder.extensions.kotlin.toLowerCamelCase
import com.fleshgrinder.extensions.kotlin.toUpperCamelCase
import com.google.common.io.CharStreams
import com.primeholding.rxbloc_generator_plugin.parser.Bloc
import org.apache.commons.lang.text.StrSubstitutor
import java.io.InputStreamReader
import java.lang.RuntimeException

abstract class RxTestGeneratorBase(
    name: String,
    private val projectName: String,
    templateName: String,
    private val bloc: Bloc
) : RxGeneratorBase(name) {

    private val TEMPLATE_BLOC_DOLLAR_PASCAL_CASE = "bloc_dollar_pascal_case"
    private val TEMPLATE_BLOC_PASCAL_CASE = "bloc_pascal_case"
    private val TEMPLATE_BLOC_FIELD_CASE = "bloc_field_case"
    private val TEMPLATE_BLOC_SNAKE_CASE = "bloc_snake_case"
    private val TEMPLATE_PROJECT_NAME = "project_name"

    private val TEMPLATE_BLOC_INITIALIZATION_PARAMETERS = "bloc_parameters_initialization_with_repos"
    private val TEMPLATE_PASS_AS_PAREMETERS_REPOS = "pass_as_parameters_repositories"
    private val TEMPLATE_REPO_INITIALIZATION = "initialization_of_repositories"

    private val TEMPLATE_DECLARATION_OF_REPOS = "declaration_of_repositories"
    private val TEMPLATE_REPO_CLASS_LIST = "repository_class_list"
    private val TEMPLATE_REPO_IMPORT_DECLARATIONS = "repository_import_declarations"
    private val TEMPLATE_BLOC_STATES_WHEN_MOCK = "bloc_states_when"


    private val templateString: String
    private val templateValues: MutableMap<String, String>

    init {
        templateValues = mutableMapOf(
            TEMPLATE_BLOC_PASCAL_CASE to pascalCase(),
            TEMPLATE_BLOC_DOLLAR_PASCAL_CASE to dollarPascalCase(),
            TEMPLATE_BLOC_SNAKE_CASE to snakeCase(),
            TEMPLATE_BLOC_FIELD_CASE to variableCase(),
            TEMPLATE_PROJECT_NAME to projectName,
            TEMPLATE_BLOC_INITIALIZATION_PARAMETERS to generateBlocInitializationParameters(),
            TEMPLATE_REPO_INITIALIZATION to generateRepoInitialization(),
            TEMPLATE_PASS_AS_PAREMETERS_REPOS to generatePassAsParameters(),
            TEMPLATE_DECLARATION_OF_REPOS to generateDeclarationOfRepos(),
            TEMPLATE_REPO_CLASS_LIST to generateRepoClassList(),
            TEMPLATE_REPO_IMPORT_DECLARATIONS to generateRepoImportDeclarations(),
            TEMPLATE_BLOC_STATES_WHEN_MOCK to generateBlocStatesWhenMock()
        )
        try {

            val resource = "/templates/rx_bloc_tests/$templateName.dart.template"
            val resourceAsStream = RxTestGeneratorBase::class.java.getResourceAsStream(resource)
            templateString = CharStreams.toString(InputStreamReader(resourceAsStream, Charsets.UTF_8))
        } catch (e: Exception) {
            throw RuntimeException(e)
        }
    }



    private fun generateBlocStatesWhenMock(): String {
        val sb = StringBuilder()
        bloc.states.forEach {
            sb.append("\n")
            sb.append("  when(blocMock.states.${it}).thenAnswer(\n")
            sb.append("    (_) => Stream.value(false),\n")
            //the value could be derived from the state if it gets parsed, (or at least for the common data types).
            sb.append("  );\n")
        }
        return sb.toString()
    }
    private fun generateRepoImportDeclarations(): String {
        val sb = StringBuilder()
        bloc.repos.forEach {
            sb.append("import 'package:${projectName}/base/repositories/${it}_repository.dart';\n")
        }
        return sb.toString()
    }


    private fun generateRepoClassList(): String {
        val sb = StringBuilder()
        bloc.repos.forEach {
            sb.append("${it.toUpperCamelCase()}Repository,")
        }
        return sb.toString()
    }

    private fun generateDeclarationOfRepos(): String {
        val sb = StringBuilder()
        bloc.repos.forEach {
            sb.append("late ${it.toUpperCamelCase()}Repository ${it.toLowerCamelCase()}RepositoryMock;\n")
        }
        return sb.toString()
    }


    private fun generateRepoInitialization(): String {
        val sb = StringBuilder()
        bloc.repos.forEach {
            sb.append("${it.toLowerCamelCase()}RepositoryMock = Mock${it.toUpperCamelCase()}Repository();\n")
        }
        return sb.toString()
    }

    private fun generatePassAsParameters(): String {
        val sb = StringBuilder()
        bloc.repos.forEach {
            sb.append("${it.toLowerCamelCase()}RepositoryMock: ${it.toLowerCamelCase()}RepositoryMock,")
        }
        return sb.toString()
    }

    private fun generateBlocInitializationParameters(): String {
        val sb = StringBuilder()
        bloc.repos.forEach {
            sb.append("required ${it.toUpperCamelCase()}Repository ${it.toLowerCamelCase()}RepositoryMock,")
        }

        return sb.toString()
    }

    override fun generate(): String {
        val substitutor = StrSubstitutor(templateValues)
        return substitutor.replace(templateString)
    }

    private fun dollarPascalCase(): String = "$" + pascalCase()
}