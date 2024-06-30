@file:Suppress("PrivatePropertyName")

package com.primeholding.rxbloc_generator_plugin.generator

import com.fleshgrinder.extensions.kotlin.toLowerCamelCase
import com.fleshgrinder.extensions.kotlin.toLowerSnakeCase
import com.fleshgrinder.extensions.kotlin.toUpperCamelCase
import com.google.common.io.CharStreams
import com.intellij.openapi.vfs.VirtualFile
import com.primeholding.rxbloc_generator_plugin.generator.parser.TestableClass
import com.primeholding.rxbloc_generator_plugin.generator.parser.Utils
import org.apache.commons.text.StringSubstitutor
import java.io.File
import java.io.InputStreamReader
import java.lang.RuntimeException

abstract class RxTestGeneratorBase(
    name: String,
    private val projectName: String,
    templateName: String,
    private val bloc: TestableClass,
    includeDiMocks: Boolean = true
) : RxGeneratorBase(name) {

    private val TEMPLATE_BLOC_DOLLAR_PASCAL_CASE = "bloc_dollar_pascal_case"
    private val TEMPLATE_BLOC_PASCAL_CASE = "bloc_pascal_case"
    private val TEMPLATE_BLOC_FIELD_CASE = "bloc_field_case"
    private val TEMPLATE_BLOC_SNAKE_CASE = "bloc_snake_case"
    private val TEMPLATE_PROJECT_NAME = "project_name"

    private val TEMPLATE_BLOC_INITIALIZATION_PARAMETERS = "bloc_parameters_initialization_with_repos"
    private val TEMPLATE_PASS_AS_PARAMETERS_REPOS = "pass_as_parameters_repositories"
    private val TEMPLATE_REPO_INITIALIZATION = "initialization_of_repositories"

    private val TEMPLATE_DECLARATION_OF_REPOS = "declaration_of_repositories"
    private val TEMPLATE_REPO_CLASS_LIST = "repository_class_list"
    private val TEMPLATE_REPO_IMPORT_DECLARATIONS = "repository_import_declarations"
    private val TEMPLATE_BLOC_CONSTRUCTOR_IMPORTS = "imports_from_bloc_constructor"
    private val TEMPLATE_BLOC_STATE_IMPORTS = "imports_from_bloc_states"
    private val TEMPLATE_BLOC_STATES_WHEN_MOCK = "bloc_states_when"
    private val TEMPLATE_TEST_RX_BLOC_STATE_GROUP = "test_rxbloc_state_group"
    private val TEMPLATE_IMPORT_BLOC_FILE = "import_bloc_file"
    private val TEMPLATE_IMPORT_BLOC_PAGE_FILE = "import_bloc_page_file"
    private val TEMPLATE_BLOC_FOLDER_PREFIX = "bloc_folder_prefix"
    private val TEMPLATE_STATES_AS_OPTIONAL_PARAMETER = "states_as_optional_parameter"
    private val TEMPLATE_STATES_AS_PASSING_NAMED_PARAMETERS = "states_as_passing_named_parameters"


    private val TEMPLATE_bloc_initialization_fields_list = "_bloc_initialization_fields_list"
    private val TEMPLATE_late_bloc_initialization_fields = "late_bloc_initialization_fields"
    private val TEMPLATE_bloc_initialization_fields_mocks = "bloc_initialization_fields_mocks"
    private val TEMPLATE_initiate_bloc_initialization_fields_setUp = "initiate_bloc_initialization_fields"


    private val includeDiMocksFlag: Boolean
    private val templateString: String
    private val templateValues: MutableMap<String, String>

    init {
        includeDiMocksFlag = includeDiMocks
        templateValues = mutableMapOf(
            TEMPLATE_BLOC_PASCAL_CASE to pascalCase(),
            TEMPLATE_BLOC_DOLLAR_PASCAL_CASE to dollarPascalCase(),
            TEMPLATE_BLOC_SNAKE_CASE to snakeCase(),
            TEMPLATE_BLOC_FIELD_CASE to variableCase(),
            TEMPLATE_PROJECT_NAME to projectName,
            TEMPLATE_BLOC_INITIALIZATION_PARAMETERS to generateBlocInitializationParameters(),
            TEMPLATE_REPO_INITIALIZATION to generateRepoInitialization(),
            TEMPLATE_PASS_AS_PARAMETERS_REPOS to generatePassAsParameters(),
            TEMPLATE_DECLARATION_OF_REPOS to generateDeclarationOfRepos(),
            TEMPLATE_REPO_CLASS_LIST to generateRepoClassList(),
            TEMPLATE_REPO_IMPORT_DECLARATIONS to generateRepoImportDeclarations(),
            TEMPLATE_BLOC_CONSTRUCTOR_IMPORTS to generateBlocConstructorImports(bloc.file, bloc.constructorFieldTypes),
            TEMPLATE_BLOC_STATE_IMPORTS to generateBlocStateImports(),
            TEMPLATE_IMPORT_BLOC_FILE to generateImportBlocFile(),
            TEMPLATE_IMPORT_BLOC_PAGE_FILE to generateImportBlocPageFile(),
            TEMPLATE_BLOC_STATES_WHEN_MOCK to generateBlocStatesWhenMock(),
            TEMPLATE_TEST_RX_BLOC_STATE_GROUP to generateBlocStatesGroup(),
            TEMPLATE_BLOC_FOLDER_PREFIX to generateFolderPrefix(),
            TEMPLATE_STATES_AS_OPTIONAL_PARAMETER to generateStatesAsOptionalParameter(
                bloc.stateVariableNames,
                bloc.stateVariableTypes
            ),
            TEMPLATE_STATES_AS_PASSING_NAMED_PARAMETERS to generateStatesAsPassingNamedParameters(),

            TEMPLATE_bloc_initialization_fields_list to generateBlocInitializationFields(
                includeDiMocksFlag,
                bloc.constructorFieldNames,
                bloc.constructorFieldNamedNames
            ),
            TEMPLATE_late_bloc_initialization_fields to generateBlocFieldsLateDefinition(),
            TEMPLATE_bloc_initialization_fields_mocks to generateBlocInitializationOfMocks(),
            TEMPLATE_initiate_bloc_initialization_fields_setUp to generateBlocSetup()


        )
        try {

            val resource = "/templates/rx_bloc_tests/$templateName.dart.template"
            val resourceAsStream = RxTestGeneratorBase::class.java.getResourceAsStream(resource)
            @Suppress(
                "UnstableApiUsage", "NULLABILITY_MISMATCH_BASED_ON_JAVA_ANNOTATIONS",
                "NULLABILITY_MISMATCH_BASED_ON_JAVA_ANNOTATIONS"
            )
            templateString = CharStreams.toString(InputStreamReader(resourceAsStream, Charsets.UTF_8))
        } catch (e: Exception) {
            throw RuntimeException(e)
        }
    }


    private fun generateImportBlocFile(): String {
        val indexOfLibInThePath = bloc.file.path.lastIndexOf("${projectName}${File.separator}lib")
        if (indexOfLibInThePath == -1) {
            return ""
        }
        val rootPathToLib =
            bloc.file.path.substring(0, indexOfLibInThePath + "${projectName}${File.separator}lib".length)
        return "import 'package:${projectName}${
            bloc.file.path.replace(
                rootPathToLib,
                ""
            )
        }';".replace("\\", "/")
    }

    private fun generateImportBlocPageFile(): String =
        generateImportBlocFile().replace(
            "blocs/${bloc.file.name}",
            "views/${bloc.file.name.replace("_bloc.dart", "_page.dart")}"
        )

    private fun generateBlocStatesGroup(): String {
        val sb = StringBuilder()
        bloc.stateVariableNames.forEachIndexed { index, it ->

            sb.append("\n")
            sb.append("  group('test ${bloc.file.name.toLowerSnakeCase()} state ${it}', () {\n")
            sb.append("      rxBlocTest<${pascalCase()}BlocType, ${bloc.stateVariableTypes[index]}>('test ${bloc.file.name.toLowerSnakeCase()} state ${it}',\n")
            sb.append("      build: () async {\n")
            sb.append("          _defineWhen();\n")
            sb.append("       return ${variableCase()}Bloc();\n")
            sb.append("      },\n")
            sb.append("      act: (bloc) async {},\n")
            sb.append("      state: (bloc) => bloc.states.${it},\n")
            sb.append("      expect: []);\n")
            sb.append("  });\n")

        }
        return sb.toString()
    }

    private fun generateBlocStatesWhenMock(): String {
        val sb = StringBuilder()
        bloc.stateVariableNames.forEachIndexed { index, it ->
            if (bloc.stateIsConnectableStream[index]) {
                sb.append("  final ${it}State = ")
                if (bloc.stateVariableTypes[index] != "void") {
                    sb.append("(${it} != null\n")
                    sb.append("          ? Stream.value(${it})\n")
                    sb.append("          : ")
                }
                sb.append("const Stream<${bloc.stateVariableTypes[index]}>.empty()")
                if (bloc.stateVariableTypes[index] != "void") {
                    sb.append(")\n    ")
                }
                sb.append(".publishReplay(maxSize: 1)\n")
                sb.append("    ..connect();\n")
            } else {
                sb.append("\n")
                sb.append("  final ${it}State = ")

                if (bloc.stateVariableTypes[index] != "void") {
                    sb.append(" $it != null\n")
                    sb.append("    ? Stream.value(${it}).shareReplay(maxSize: 1)\n")
                    sb.append("    : ")
                }
                sb.append("const Stream<${bloc.stateVariableTypes[index]}>.empty();\n")
                sb.append("\n")
            }
        }
        sb.append("\n")
        bloc.stateVariableNames.forEach { it ->
            sb.append("  when(statesMock.${it}).thenAnswer((_) => ${it}State);\n")
        }
        return sb.toString()
    }

    private fun generateFolderPrefix(): String {
        return if (bloc.isLib) "lib" else "feature"
    }

    private fun generateBlocFieldsLateDefinition(): String {
        val sb = StringBuilder()

        if (includeDiMocksFlag) {
            bloc.constructorFieldNames.forEachIndexed { index, it ->
                sb.append("  late ${bloc.constructorFieldTypes[index]} ${it};\n")
            }
        } else {
            sb.append("//TODO\n")
        }
        return sb.toString()
    }

    private fun isMockable(type: String): Boolean {
        return !(listOf("int", "double", "String").contains(type))
    }

    private fun generateBlocInitializationOfMocks(): String {
        val sb = StringBuilder()
        if (includeDiMocksFlag) {
            sb.append("@GenerateMocks([\n")
            bloc.constructorFieldTypes.forEach {
                if (isMockable(it)) {
                    sb.append("        $it,\n")
                }
            }
            sb.append("])\n")
        } else {
            sb.append("//TODO @GeneratedMocks([])\n")
        }
        return sb.toString()
    }

    private fun generateBlocSetup(): String {
        val sb = StringBuilder()
        if (includeDiMocksFlag) {
            bloc.constructorFieldNames.forEachIndexed { index, it ->

                if (isMockable(bloc.constructorFieldTypes[index])) {
                    sb.append("    $it = Mock${bloc.constructorFieldTypes[index]}();\n")
                }
            }
        } else {
            sb.append("//TODO\n")
        }
        return sb.toString()
    }

    private fun generateStatesAsPassingNamedParameters(): String {
        val sb = StringBuilder()
        bloc.stateVariableNames.forEachIndexed { index, it ->
            if (bloc.stateVariableTypes[index] != "void") {
                sb.append("            $it: $it,\n")
            }
        }
        return sb.toString()
    }

    private fun searchInSubTypes(lines: List<String>, type: String, libFolder: VirtualFile): String {
        val sb = StringBuilder()
        val indexOfOpen = type.indexOf("<")
        if (indexOfOpen != -1) {
            val indexOfClose = type.indexOf(">", indexOfOpen)

            if (indexOfClose != -1) {
                var subType = type.substring(indexOfOpen + 1, indexOfClose)

                if (subType.contains("<")) {
                    sb.append(searchInSubTypes(lines, subType, libFolder))
                    subType = subType.substring(0, subType.indexOf("<"))
                    appendImportIfFound(sb, libFolder, subType, lines)
                } else {
                    appendImportIfFound(sb, libFolder, subType, lines)
                }
            }
        }

        return sb.toString()
    }

    private fun appendImportIfFound(
        sb: StringBuilder,
        libFolder: VirtualFile,
        needle: String,
        lines: List<String>
    ) {
        val snake = needle.trim().replace("?", "").toLowerSnakeCase()
        lines.forEach { line ->
            if (line.contains("import '") && line.contains("$snake.dart")) {
                sb.appendln(
                    Utils.fixRelativeImports(line, libFolder, bloc.file)
                )
            }
        }
    }

    private fun generateBlocStateImports(): String {
        val lines = File(bloc.file.path).readText().lines()
        val libFolder = findLibFolder(bloc.file)
        val sb = StringBuilder()
        if (libFolder != null) {

            var resultAdded = false
            var paginatedListAdded = false

            bloc.stateVariableTypes.forEach {
                if (it.contains("Result<") && !resultAdded) {
                    resultAdded = true
                    sb.appendln("import 'package:rx_bloc/rx_bloc.dart';")
                }
                if (it.contains("PaginatedList<") && !paginatedListAdded) {
                    paginatedListAdded = true
                    sb.appendln("import 'package:rx_bloc_list/models.dart';")
                }
                sb.append(searchInSubTypes(lines, it, libFolder.parent))
            }

            bloc.stateVariableTypes.forEach {
                appendImportIfFound(sb, libFolder.parent, it, lines)
            }
        }
        return sb.toString()
    }

    private fun generateBlocConstructorImports(file: VirtualFile, constructorFieldTypes: MutableList<String>): String {
        val sb = StringBuilder()

        val lines = File(file.path).readText().lines()
        val libFolder = findLibFolder(file)

        if (libFolder != null) {
            lines.forEach { line ->
                constructorFieldTypes.forEach {
                    val snake = it.toLowerSnakeCase()
                    if (line.contains("import '")) {

                        if (line.contains("$snake.dart")) {
                            sb.appendln(Utils.fixRelativeImports(line, libFolder.parent, file))
                        }

                        if (snake.endsWith("bloc_type") && line.contains(
                                "${
                                    snake.replace(
                                        "bloc_type",
                                        "bloc"
                                    )
                                }.dart"
                            )
                        ) {
                            sb.appendln(Utils.fixRelativeImports(line, libFolder.parent, file))
                        }
                    }
                }
            }
        }
        var resultAdded = false
        var paginatedListAdded = false

        bloc.constructorFieldTypes.forEach {
            if (it.contains("Result<") && !resultAdded) {
                resultAdded = true
                sb.appendln("import 'package:rx_bloc/rx_bloc.dart';")
            }
            if (it.contains("PaginatedList<") && !paginatedListAdded) {
                paginatedListAdded = true
                sb.appendln("import 'package:rx_bloc_list/models.dart';")
            }
        }
        return sb.toString()
    }

    private fun findLibFolder(file: VirtualFile): VirtualFile? {
        if (file.name == "lib") {
            return file
        }
        return findLibFolder(file.parent)
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
        val substitutor = StringSubstitutor(templateValues)
        return substitutor.replace(templateString)
    }

    private fun dollarPascalCase(): String = "$" + pascalCase()

    companion object {
        fun generateStatesAsOptionalParameter(
            stateVariableNames: List<String>,
            stateVariableTypes: List<String>
        ): String {
            val sb = StringBuilder()
            stateVariableNames.forEachIndexed { index, _ ->
                if (stateVariableTypes[index] != "void") {
                    sb.append("  ${stateVariableTypes[index]}${if (stateVariableTypes[index].endsWith("?")) "" else "?"} ${stateVariableNames[index]},\n")
                }
            }
            return sb.toString()
        }

        fun generateBlocInitializationFields(
            includeDiMocksFlag: Boolean,
            constructorFieldNames: List<String>,
            constructorFieldNamedNames: MutableMap<String, Boolean>
        ): String {
            val sb = StringBuilder()

            if (includeDiMocksFlag) {
                constructorFieldNames.forEach {
                    if (!constructorFieldNamedNames.keys.contains(it))
                        sb.append("        $it,\n")
                }
                constructorFieldNamedNames.forEach {
                    sb.append("        ${it.key}: ${it.key},\n")
                }
            } else {
                sb.append("//TODO\n")
            }
            return sb.toString()
        }
    }
}