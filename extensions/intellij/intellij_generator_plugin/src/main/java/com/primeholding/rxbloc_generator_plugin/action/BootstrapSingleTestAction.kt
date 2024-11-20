package com.primeholding.rxbloc_generator_plugin.action

import com.fleshgrinder.extensions.kotlin.toLowerCamelCase
import com.intellij.openapi.actionSystem.AnAction
import com.intellij.openapi.actionSystem.AnActionEvent
import com.intellij.openapi.actionSystem.CommonDataKeys
import com.intellij.openapi.command.CommandProcessor
import com.intellij.openapi.command.WriteCommandAction
import com.intellij.openapi.fileEditor.FileEditorManager
import com.intellij.openapi.project.Project
import com.intellij.openapi.ui.Messages
import com.intellij.openapi.util.io.FileUtil
import com.intellij.openapi.vfs.VfsUtil
import com.intellij.openapi.vfs.VirtualFile
import com.primeholding.rxbloc_generator_plugin.action.GenerateRxBlocTestDialog.TestLibrary
import com.primeholding.rxbloc_generator_plugin.generator.RxTestGeneratorBase
import com.primeholding.rxbloc_generator_plugin.generator.parser.Utils
import com.primeholding.rxbloc_generator_plugin.intention_action.BlocWrapWithIntentionAction
import java.io.File


class BootstrapSingleTestAction : AnAction(), GenerateRxBlocTestDialog.Listener {

    private var project: Project? = null
    private var selectedFile: VirtualFile? = null

    override fun update(e: AnActionEvent?) {
        super.update(e)
        val files = e?.dataContext?.getData(CommonDataKeys.VIRTUAL_FILE_ARRAY)
        var isVisible = false

        var file: VirtualFile?

        val end = files?.size ?: 0
        for (i in 0 until end) {
            file = files?.get(i)
            if (!file?.isDirectory!!) {
                if (isBlocFile(file)) {
                    e?.presentation?.text = "RxBloc Test"
                    isVisible = true
                    break
                }

                if (isServiceFile(file)) {
                    e?.presentation?.text = "Service Test"
                    isVisible = true
                    break
                }

                if (isRepositoryFile(file)) {
                    e?.presentation?.text = "Repository Test"
                    isVisible = true
                    break
                }

                if (isUIFile(file)) {
                    e?.presentation?.text = "Golden Test"
                    isVisible = true
                    break
                }
            }
        }
        e?.presentation?.isVisible = isVisible
    }

    override fun actionPerformed(e: AnActionEvent?) {

        project = e?.project
        val files = e?.dataContext?.getData(CommonDataKeys.VIRTUAL_FILE_ARRAY)

        var file: VirtualFile?

        if (project != null) {
            WriteCommandAction.runWriteCommandAction(project) {
                CommandProcessor.getInstance().executeCommand(
                    project, {
                        for (i in 0..files?.size!!) {
                            file = files[i]
                            if (!file!!.isDirectory) {
                                if (isBlocFile(file)) {
                                    generateBloc(file!!, project!!)
                                    break
                                }

                                if (isServiceFile(file)) {
                                    generateService(file!!, project!!)
                                    break
                                }

                                if (isRepositoryFile(file)) {
                                    generateRepository(file!!, project!!)
                                    break
                                }

                                if (isUIFile(file)) {
                                    selectedFile = file
                                    val dialog = GenerateRxBlocTestDialog(this)
                                    dialog.show()
                                    break
                                }
                            }
                        }
                    }, "Bootstrap Single Test", null
                )
            }
        }
    }

    private fun isBlocFile(file: VirtualFile?): Boolean {
        return file?.name?.endsWith("_bloc.dart") ?: false
    }

    private fun isServiceFile(file: VirtualFile?): Boolean {
        return file?.name?.endsWith("_service.dart") ?: false
    }

    private fun isRepositoryFile(file: VirtualFile?): Boolean {
        return file?.name?.endsWith("_repository.dart") ?: false
    }

    private val uiSuffixes = listOf("_page.dart", "_widget.dart", "_tile_item.dart", "_component.dart", "_button.dart")
    private fun isUIFile(file: VirtualFile?): Boolean {

        uiSuffixes.forEach {
            if (file?.name?.endsWith(it) == true) {
                return true
            }
        }
        return false
    }

    override fun onGenerateBlocTestClicked(selectedTestLibrary: TestLibrary) {
        if(selectedFile != null) {
            generateGoldenTest(selectedFile!!, project!!, selectedTestLibrary)
        }
    }

    private fun projectLibFolder(): String = "${project?.name}${File.separator}lib"
    private fun projectLibAbsolutePath(): String = "${project?.basePath}${File.separator}lib"
    private fun projectTestFolder(): String = "${project?.name}${File.separator}test"

    private fun createFile(file: VirtualFile?, suffix: String, value: String): VirtualFile? {

        if (file?.path?.contains(projectLibFolder()) == true) {
            val destinationFile =
                file.path.replace(projectLibFolder(), projectTestFolder())
                    .replace(".dart", suffix)

            if (File(destinationFile).exists()) {
                Messages.showMessageDialog(
                    "File ${
                        file.name
                    } Already Exists!",
                    "Duplicate File",
                    null
                )

                return null
            }

            FileUtil.writeToFile(File(destinationFile), value)
            return VfsUtil.findFileByIoFile(File(destinationFile), true)
        }
        return null
    }

    private fun generateRepository(file: VirtualFile, project: Project) {
        val text = File(file.path).readText()

        val constructorFields: MutableMap<String, String> = mutableMapOf()
        val constructorNamedFields: MutableMap<String, Boolean> = mutableMapOf()

        val className = Utils.getClassName(file)
        Utils.getConstructorFields(
            text, className, constructorFields, constructorNamedFields
        )

        val newFile = createFile(
            file, "_test.dart", generateTest(
                file, text, constructorFields, constructorNamedFields
            )
        )
        if (newFile != null) {
            FileEditorManager.getInstance(project).openFile(newFile, false)
        }
    }

    private fun convertToLocal(str: String): String {
        if (str.startsWith("_")) {
            return str.substring(1)
        }
        return str
    }

    fun generateTest(
        file: VirtualFile,
        text: String,
        constructorFields: MutableMap<String, String>,
        constructorNamedFields: MutableMap<String, Boolean>
    ): String {
        val sb = StringBuffer()
        val className = Utils.getClassName(file)

        Utils.getConstructorFields(
            text, className, constructorFields, constructorNamedFields
        )
        val methods = Utils.getMethods(text, className)

        sb.appendln("import 'package:flutter_test/flutter_test.dart';")
        sb.appendln("import 'package:mockito/annotations.dart';")

        project?.let {
            val sub = file.path.replace("${it.basePath!!}/lib", "")
            sb.append("import 'package:${it.name}${sub}';\n")

            sb.append(
                generateImportsFromFileAndClasses(
                    text,
                    constructorFields.values,
                    Utils.baseDir(it.basePath!!),
                    file
                )
            )
        }


        sb.appendln("import '${file.name.replace(".dart", "_test.mocks.dart")}';")

        sb.appendln("@GenerateMocks([")
        constructorFields.forEach {
            sb.appendln("  ${it.value},")
        }
        sb.appendln("])")
        sb.appendln("void main() {")
        constructorFields.forEach {
            sb.appendln("  late ${it.value} ${convertToLocal(it.key)};")
        }

        sb.appendln("")
        sb.appendln("  setUp(() {")
        constructorFields.forEach {
            sb.appendln("    ${convertToLocal(it.key)} = Mock${it.value}();")
        }
        sb.appendln("  });")
        sb.appendln("")

        sb.append("    final service = $className(")
            .append(generateConstructorParams(constructorFields, constructorNamedFields)).append(");\n")
        methods.forEach { classMethod ->
            sb.appendln(" group('$className ${classMethod.name} tests', () {")
            sb.appendln("")
            sb.appendln("    test('test $className ${classMethod.name} case 1', () async {")
            sb.appendln("    });")
            sb.appendln(" });")
        }

        sb.appendln("}")
        return sb.toString()
    }

    private fun String.camelToSnakeCase() = fold(StringBuilder(length)) { acc, c ->
        if (c in 'A'..'Z') (if (acc.isNotEmpty()) acc.append('_') else acc).append(c + ('a' - 'A'))
        else acc.append(c)
    }.toString()

    fun generateImportsFromFileAndClasses(
        text: String,
        values: MutableCollection<String>,
        rootDir: VirtualFile,
        file: VirtualFile
    ): String {

        val sb = StringBuffer()
        val split = text.split("\n")
        val start = "class "
        split.forEach { line ->

            values.forEach {

                if (it.contains("<") && it.contains(">")) {
                    val index1 = it.indexOf("<") + 1
                    val index2 = it.indexOf(">")

                    if (index1 <= index2) {
                        val innerType = it.substring(index1, index2)
                        if (line.contains("${innerType.camelToSnakeCase()}.dart") && line.startsWith("import '")) {
                            sb.append(Utils.fixRelativeImports(line, rootDir, file)).append("\n")
                        }
                    }
                } else {
                    if (line.contains("${it.camelToSnakeCase()}.dart") && line.startsWith("import '")) {
                        sb.append(Utils.fixRelativeImports(line, rootDir, file)).append("\n")
                    }
                }
            }

            if (line.startsWith(start)) {
                return sb.toString()
            }
        }

        return sb.toString()
    }

    private fun generateService(file: VirtualFile, project: Project) {
        val text = File(file.path).readText()

        val constructorFields: MutableMap<String, String> = mutableMapOf()
        val constructorNamedFields: MutableMap<String, Boolean> = mutableMapOf()

        val newFile = createFile(
            file, "_test.dart", generateTest(
                file, text,
                constructorFields,
                constructorNamedFields
            )
        )
        if (newFile != null) {
            FileEditorManager.getInstance(project).openFile(newFile, false)
        }
    }

    private fun generateBloc(file: VirtualFile, project: Project) {
        val nullableBloc = Utils.extractBloc(file)
        nullableBloc?.let { bloc ->

            val newFilePath =
                file.path.replace(project.basePath!!, "").replace("/lib/", "/test/").replace(".dart", "_test.dart")
            if (File(newFilePath).exists()) {
                Messages.showMessageDialog(
                    "BloC ${
                        bloc.file.name
                    } Already Exists!",
                    "Duplicate BloC",
                    null
                )

                return
            }


            val newFile = Utils.baseDir(project.basePath!!)
            FileUtil.createIfDoesntExist(File(newFilePath))

            BootstrapTestsAction.writeBlockTest(
                newFile,
                bloc,
                projectName = Utils.baseDir(project.basePath!!).name,
                includeDiMocks = true
            )
            FileEditorManager.getInstance(project).openFile(newFile, false)
        }
    }

    private fun generateGoldenTest(file: VirtualFile, project: Project, selectedTestLibrary: TestLibrary) {
        val constructorFields: MutableMap<String, String> = mutableMapOf()
        val constructorNamedFields: MutableMap<String, Boolean> = mutableMapOf()
        val goldenFile = File(file.path)

        val newFilePath =
            file.path.replace(project.basePath!!, "").replace("/lib/", "/test/").replace(".dart", "_test.dart")
        if (File(newFilePath).exists()) {
            Messages.showMessageDialog(
                "Golden Test ${
                    goldenFile.name
                } Already Exists!",
                "Duplicate Golden Test",
                null
            )

            return
        }


        val text = goldenFile.readText()

        Utils.getConstructorFields(
            text,
            BlocWrapWithIntentionAction.toCamelCase(file.name.replace(".dart", "")),
            constructorFields,
            constructorNamedFields
        )

        val blocSnakeCase = file.name.replace(".dart", "")
        val blocPascalCase = Utils.getClassName(file)
        val blocFieldCase = file.name.replace(".dart", "").toLowerCamelCase()

        var sb = StringBuffer()
        sb.append(
            """
import 'package:flutter/material.dart';
import 'package:flutter_rx_bloc/flutter_rx_bloc.dart';
import 'package:provider/provider.dart';
//import '../mock/${blocSnakeCase}_mock.dart';
import 'package:${Utils.baseDir(project.basePath!!).name}${file.path.replace(projectLibAbsolutePath(), "")}';
${generateImportsFromFileAndClasses(text, constructorFields.values, Utils.baseDir(project.basePath!!), file)}

/// Change the parameters according the the needs of the test
Widget ${blocFieldCase}Factory ({
    ${
                RxTestGeneratorBase.generateStatesAsOptionalParameter(
                    constructorFields.keys.toList(), constructorFields.values.toList()
                )
            }
}) =>
Scaffold(
    body:  MultiProvider(providers:[
    //    RxBlocProvider<${blocPascalCase}BlocType>.value(
    //       value: ${blocFieldCase}MockFactory(
    //       ),
    //    ),
], child: ${blocPascalCase}(${generateConstructorParams(constructorFields, constructorNamedFields)})),
);

""".trimIndent()
        )
        var newFile = createFile(file, "_factory.dart", sb.toString())

        if (newFile != null) {
            FileEditorManager.getInstance(project).openFile(newFile, false)
        }
        sb = StringBuffer()

        val goldenFileContent = (if (selectedTestLibrary == TestLibrary.GoldenToolkit) createGoldenToolkitFileContent(blocFieldCase, blocSnakeCase) else createAlchemistGoldenFileContent(blocFieldCase, blocSnakeCase))

        sb.append(goldenFileContent)

        newFile = createFile(file, "_golden_test.dart", sb.toString())
        if (newFile != null) {
            FileEditorManager.getInstance(project).openFile(newFile, false)
        }
    }

    fun generateConstructorParams(
        constructorFields: MutableMap<String, String>, constructorNamedFields: MutableMap<String, Boolean>
    ): String {
        val sb = StringBuffer()
        constructorFields.forEach {
            if (!constructorNamedFields.keys.contains(it.key)) sb.append("        ${convertToLocal(it.key)},\n")
        }
        constructorNamedFields.forEach {
            sb.append("        ${convertToLocal(it.key)}: ${convertToLocal(it.key)},\n")
        }
        return sb.toString()
    }


    private fun createGoldenToolkitFileContent(blocFieldCase: String, blocSnakeCase: String): String =
        """
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/golden_helper.dart';
import '../../helpers/models/scenario.dart';
import '${blocSnakeCase}_factory.dart';
import 'package:rx_bloc/rx_bloc.dart';
import 'package:rx_bloc_list/models.dart';


void main () {
  runGoldenTests(
    [
      generateDeviceBuilder(
          widget: ${blocFieldCase}Factory(), //example: Stubs.emptyList
          scenario: Scenario(name: '${blocSnakeCase}_empty')),
      generateDeviceBuilder(
          widget: ${blocFieldCase}Factory(), //example:  Stubs.success
          scenario: Scenario(name: '${blocSnakeCase}_success')),
      generateDeviceBuilder(
          widget: ${blocFieldCase}Factory(), //loading
          scenario: Scenario(name: '${blocSnakeCase}_loading')),
      generateDeviceBuilder(
          widget: ${blocFieldCase}Factory(),
          scenario: Scenario(name: '${blocSnakeCase}_error'))
  ]);
}
""".trimIndent()

    private fun createAlchemistGoldenFileContent(blocFieldCase: String, blocSnakeCase: String): String =
        """
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/golden_helper.dart';
import '../../helpers/models/scenario.dart';
import '${blocSnakeCase}_factory.dart';
import 'package:rx_bloc/rx_bloc.dart';
import 'package:rx_bloc_list/models.dart';


void main () {
  runGoldenTests(
    [
      buildScenario(
        scenario:  '${blocSnakeCase}_empty',
        widget: ${blocFieldCase}Factory(),
      ),
      buildScenario(
        scenario:  '${blocSnakeCase}_success',
        widget: ${blocFieldCase}Factory(),
      ),
      buildScenario(
        scenario:  '${blocSnakeCase}_loading',
        widget: ${blocFieldCase}Factory(),
      ),
      buildScenario(
        scenario:  '${blocSnakeCase}_error',
        widget: ${blocFieldCase}Factory(),
      ),
  ]);
}
""".trimIndent()
}
