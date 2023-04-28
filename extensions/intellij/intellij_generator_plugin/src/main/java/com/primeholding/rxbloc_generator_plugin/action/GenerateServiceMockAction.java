package com.primeholding.rxbloc_generator_plugin.action;

import com.fleshgrinder.extensions.kotlin.CaseFormatKt;
import com.intellij.openapi.actionSystem.AnAction;
import com.intellij.openapi.actionSystem.AnActionEvent;
import com.intellij.openapi.actionSystem.DataKeys;
import com.intellij.openapi.project.Project;
import com.intellij.openapi.vfs.VirtualFile;
import com.primeholding.rxbloc_generator_plugin.generator.RxTestGeneratorBase;
import com.primeholding.rxbloc_generator_plugin.generator.parser.ClassMethod;
import com.primeholding.rxbloc_generator_plugin.generator.parser.TestableClass;
import com.primeholding.rxbloc_generator_plugin.generator.parser.Utils;

import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

import static com.primeholding.rxbloc_generator_plugin.intention_action.BlocWrapWithIntentionAction.toCamelCase;


public class GenerateServiceMockAction extends AnAction {

    @Override
    public void update(AnActionEvent event) {
        super.update(event);

        VirtualFile[] virtualFiles = event.getDataContext().getData(DataKeys.VIRTUAL_FILE_ARRAY);

        boolean visible = false;

        if (virtualFiles != null) {
            for (VirtualFile file : virtualFiles) {

                if (file.getName().endsWith("_service.dart")) {
                    visible = true;
                    break;
                }
            }
        }

        event.getPresentation().setVisible(visible);
    }

    @Override
    public void actionPerformed(AnActionEvent e) {
        actionAbstraction().setEvent(e).checkPreconditions().execute();
    }

    protected IntelliJActionAbstraction actionAbstraction() {
        return new GenerateServiceAction();
    }

    public static class GenerateServiceAction extends IntelliJActionAbstraction {

        @Override
        public void run() {

            VirtualFile[] virtualFiles = event.getDataContext().getData(DataKeys.VIRTUAL_FILE_ARRAY);

            if (virtualFiles != null) {
                try {
                    for (VirtualFile file : virtualFiles) {
                        if (file.getName().endsWith("_service.dart")) {

                            processService(file, event.getProject());

                        }
                    }
                } catch (IOException e) {
                    e.printStackTrace();
                }
            }
        }

        protected String buildServiceMock(TestableClass testableClass, Project project) throws IOException {
            String className = toCamelCase(testableClass.getFile().getName().replace(".dart", ""));
            String fieldCase = CaseFormatKt.toLowerCamelCase(testableClass.getFile().getName().replace(".dart", ""));

            StringBuilder sb = new StringBuilder();
            sb.append("import 'package:mockito/annotations.dart';\n");
            sb.append("import 'package:mockito/mockito.dart';\n");
            String relativePath = testableClass.getFile().getPath().replace(project.getBasePath() + "/lib", "");
            sb.append("import 'package:").append(project.getName()).append(relativePath).append("';\n");

            String text = new String(Files.readAllBytes(new File(testableClass.getFile().getPath()).toPath()));
            String[] lines = text.split("\n");
            RxTestGeneratorBase.Companion.constructImports(Arrays.asList(lines), findLibFolder(testableClass.getFile()), testableClass.getConstructorFieldTypes(), sb, testableClass.getFile());

            sb.append("import '").append(testableClass.getFile().getName().replace(".dart", "")).append("_mock.mocks.dart';\n");

            sb.append(RxTestGeneratorBase.Companion.generateBlocInitializationOfMocks(true, testableClass));


            sb.append("    ").append(className).append(" ").append(fieldCase).append("Mock({\n");
            // -- generate all return types of the functions
            List<ClassMethod> methods = Utils.Companion.getMethods(text, className);

            List<String> variableNames = new ArrayList<>();
            List<String> variableTypes = new ArrayList<>();
            for (ClassMethod method : methods) {
                variableNames.add(method.getName());
                variableTypes.add(
                        method.getReturnedType());
            }

            sb.append( RxTestGeneratorBase.Companion.generateStatesAsOptionalParameter(variableNames, variableTypes) );
            sb.append("   }) {\n");

            // -- generate all dependencies classes mocks
            RxTestGeneratorBase.Companion.generateBlocSetup(true, testableClass, true);

            // -- generate ifs for all return types of the functions
            sb.append("/*\n");
            for (String variableName : variableNames) {
                sb.append("  if (").append(variableName).append(" != null) {\n");
                sb.append("     when(sampleRepository.methodName())\n");
                sb.append("         .thenAnswer((realInvocation) => Future.value(").append(variableName).append("));\n");
                sb.append(" }\n");
            }
            sb.append("*/\n");
            // -- generate all dependencies classes as parameters
            sb.append("    return ").append(className).append("();\n");
            sb.append("}\n");

            return sb.toString();
        }

        private VirtualFile findLibFolder(VirtualFile file) {
            if (file.getName().equals("lib")) {
                return file;
            }
            return findLibFolder(file.getParent());
        }

        protected void processService(VirtualFile file, Project project) throws IOException {
            TestableClass testableClass = Utils.Companion.extractBloc(file);
            String mockFilePath = getServiceMockFilePath(file);
            assert testableClass != null;
            writeServiceMock(buildServiceMock(testableClass, project), mockFilePath);
            openInIDE(mockFilePath);
        }

        protected String getServiceMockFilePath(VirtualFile serviceFile) {
            String replace = serviceFile.getPath().replace(File.separator + "lib" + File.separator, File.separator + "test" + File.separator);
            replace = replace.replace("_service.dart", "_service_mock.dart");
            return replace;
        }


        @Override
        protected String commandName() {
            return "Generate Service Mocks";
        }

        @Override
        public IntelliJActionAbstraction checkPreconditions() {
            boolean ready = true;
            VirtualFile[] virtualFiles = event.getDataContext().getData(DataKeys.VIRTUAL_FILE_ARRAY);

            if (virtualFiles != null) {
                for (VirtualFile file : virtualFiles) {

                    if (file.getName().endsWith("_service.dart")) {
                        //check if such mock service already exists
                        String replace = getServiceMockFilePath(file);

                        if (fileExists(replace)) {
                            ready = false;
                            showMessage("File " + replace + " Already Exists!", "Duplicate Service Mock");
                            break;
                        }
                    }
                }
            }
            isReadyToExecute = ready;
            return this;
        }
    }

}
