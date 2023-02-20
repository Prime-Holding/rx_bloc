package com.primeholding.rxbloc_generator_plugin.action

import com.fleshgrinder.extensions.kotlin.toLowerCamelCase
import com.fleshgrinder.extensions.kotlin.toUpperCamelCase
import com.intellij.openapi.actionSystem.*
import com.intellij.openapi.application.ApplicationManager
import com.intellij.openapi.command.CommandProcessor
import com.intellij.openapi.fileEditor.FileEditorManager
import com.intellij.openapi.ui.Messages
import com.intellij.openapi.vfs.VirtualFile
import com.intellij.testFramework.VfsTestUtil
import com.primeholding.rxbloc_generator_plugin.generator.RxBlocFeatureGeneratorFactory
import com.primeholding.rxbloc_generator_plugin.generator.RxGeneratorBase
import com.primeholding.rxbloc_generator_plugin.generator.components.RxPageGenerator
import java.io.File


class GenerateRxBlocFeatureAction : AnAction(), GenerateRxBlocDialog.Listener {

    private lateinit var dataContext: DataContext
    private lateinit var event: AnActionEvent

    override fun actionPerformed(e: AnActionEvent) {
        event = e
        val dialog = GenerateRxBlocDialog(this)
        dialog.show()
    }

    override fun onGenerateBlocClicked(
        blocName: String?,
        withDefaultStates: Boolean,
        includeLocalService: Boolean,
        includeAutoRoute: Boolean
    ) {
        blocName?.let { name ->
            val generators = RxBlocFeatureGeneratorFactory.getBlocGenerators(
                name,
                withDefaultStates,
                includeLocalService,
                includeAutoRoute
            )
            generate(generators, includeAutoRoute, name)
        }
    }

    override fun update(e: AnActionEvent) {
        e.dataContext.let {
            this.dataContext = it
            val presentation = e.presentation


            val files = e.dataContext.getData(DataKeys.VIRTUAL_FILE_ARRAY)
            val isVisible = files != null && files.size == 1 && files[0].isDirectory

            presentation.isEnabled = isVisible
            presentation.isVisible = isVisible
        }
    }

    private fun generate(mainSourceGenerators: List<RxGeneratorBase>, includeAutoRoute: Boolean, name: String) {
        val project = CommonDataKeys.PROJECT.getData(dataContext)
        //contextually selected folders
        val files = event.dataContext.getData(DataKeys.VIRTUAL_FILE_ARRAY)



        if (mainSourceGenerators.isNotEmpty() && files != null && files.size == 1 && files[0].isDirectory) {
            val featureDirectory = files[0]?.findChild(mainSourceGenerators[0].featureDirectoryName())

            if (featureDirectory != null) {
                Messages.showMessageDialog(
                    "Feature ${
                        mainSourceGenerators[0].featureDirectoryName().replaceFirst("feature_", "")
                    } Already Exists!",
                    "Duplicate Feature",
                    null
                )
                return
            }
        }

        var file: VirtualFile? = null

        ApplicationManager.getApplication().runWriteAction {
            CommandProcessor.getInstance().executeCommand(
                project,
                {
                    mainSourceGenerators.forEach {
                        val featureDirectory = createDir(files!![0], it.featureDirectoryName())
                        val featureBlocDirectory = createDir(featureDirectory, it.contextDirectoryName())
                        if (it is RxPageGenerator) {
                            file = createSourceFile(it, featureBlocDirectory)
                        } else {
                            createSourceFile(it, featureBlocDirectory)
                        }
                    }
                    if (!includeAutoRoute) {
                        goRouteAdditions(name)
                    }
                },
                "Generate a new RxBloc Feature",
                null
            )
        }
        if (file != null && project != null) {
            FileEditorManager.getInstance(project)
                .openFile(file!!, true)
        }
    }

    private fun goRouteAdditions(name: String) {
        println("goRouteAdditions $name")

        val featureCamelCase = name.toUpperCamelCase()
        val featureFieldCase = name.toLowerCamelCase()

        println("featureCamelCase $featureCamelCase")
        println("featureFieldCase $featureFieldCase")
        val newRoute = """

//TODO move it the desired place in the routing tree
@immutable
class ${featureCamelCase}Route extends GoRouteData implements RouteData {
  const ${featureCamelCase}Route();

  @override
  Page<Function> buildPage(BuildContext context, GoRouterState state) =>
      MaterialPage(
        key: state.pageKey,
        child: const ${featureCamelCase}PageWithDependencies(),
      );

  @override
  String get permissionName => RouteModel.${featureFieldCase}.permissionName;

  @override
  String get routeLocation => location;
  //TODO execute rebuild and remove this todo - when location is found
}
        
"""
        event.project?.let {
            println("project it $it")
            var filePath =
                "${it.basePath}${File.separator}lib${File.separator}lib_router${File.separator}router.dart"
            var file = File(filePath)

            println("router it $file")
            if (file.exists()) {
                val text = file.readText()
                VfsTestUtil.overwriteTestData(filePath, "${text}${newRoute}")

                println("text $text")
            }
            filePath =
                "${it.basePath}${File.separator}lib${File.separator}lib_router${File.separator}models${File.separator}routes_path.dart"
            file = File(filePath)
            println("routes_path it $file")
            if (file.exists()) {
                val text = File(file.path).readText()
                    .replace(
                        "RoutesPath {",
                        "RoutesPath {\n  static const $featureFieldCase = '/$featureFieldCase';// TODO fix full path of the route according to your needs"
                    )
                VfsTestUtil.overwriteTestData(file.path, text)


                println("text $text")
            }
            filePath =
             "${it.basePath}${File.separator}lib${File.separator}lib_router${File.separator}models${File.separator}route_model.dart"
            file = File(filePath)
            println("route_model it $file")
            if (file.exists()) {
                val text = File(file.path).readText()
                    .replace(
                        "RouteModel {", """RouteModel {
  $featureFieldCase(
    pathName: RoutesPath.$featureFieldCase,
    fullPath: '/$featureFieldCase',
    permissionName: RoutesPermission.$featureFieldCase,
  ),
"""
                    )
                VfsTestUtil.overwriteTestData(file.path, text)


                println("text $text")
            }

            filePath =
               "${it.basePath}${File.separator}lib${File.separator}lib_permissions${File.separator}models${File.separator}routes_permission.dart"
            file = File(filePath)
            if (file.exists()) {
                val text = File(file.path).readText().replace(
                    "RoutesPermission {",
                    "RoutesPermission {\n  static const $featureFieldCase = '${featureCamelCase}Route';"
                )
                VfsTestUtil.overwriteTestData(file.path, text)

                println("text $text")
            }

            filePath =
              "${it.basePath}${File.separator}bin${File.separator}server${File.separator}controllers${File.separator}permissions_controller.dart"
            file = File(filePath)
            if (file.exists()) {
                val text = File(file.path).readText()
                    .replace("'item': {", "'item': {\n          '${featureCamelCase}Route': true,")
                VfsTestUtil.overwriteTestData(file.path, text)


                println("text $text")
            }
        }
    }

    private fun createSourceFile(generator: RxGeneratorBase, directory: VirtualFile): VirtualFile? {
        val fileName = generator.fileName()
        val existingPsiFile = directory.findChild(fileName)
        if (existingPsiFile != null) {
            return null
        }

        val file = directory.createChildData(this, fileName)
        VfsTestUtil.overwriteTestData(file.path, generator.generate())

        return file
    }

    private fun createDir(baseDirectory: VirtualFile, name: String): VirtualFile {
        var featureDirectory = baseDirectory.findChild(name)

        if (featureDirectory == null) {
            featureDirectory = baseDirectory.createChildDirectory(this, name)
        }

        return featureDirectory
    }
}