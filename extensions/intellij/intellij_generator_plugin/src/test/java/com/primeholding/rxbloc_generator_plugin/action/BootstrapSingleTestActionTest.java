package com.primeholding.rxbloc_generator_plugin.action;

import com.intellij.openapi.actionSystem.AnActionEvent;
import com.intellij.openapi.actionSystem.DataContext;
import com.intellij.openapi.actionSystem.DataKeys;
import com.intellij.openapi.actionSystem.Presentation;
import com.intellij.openapi.project.Project;
import com.intellij.openapi.vfs.VirtualFile;
import org.junit.Test;

import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.when;

import static org.junit.Assert.*;

public class BootstrapSingleTestActionTest {
    BootstrapSingleTestAction bootstrapSingleTestAction = new BootstrapSingleTestAction();


    @Test
    public void testUpdate() {

        VirtualFile blocFileMock = mock(VirtualFile.class);
        DataContext dataContextMock = mock(DataContext.class);
        AnActionEvent anActionEventMock = mock(AnActionEvent.class);
        Presentation presentation = new Presentation();
        Project projectMock = mock(Project.class);
        when(anActionEventMock.getPresentation()).thenReturn(presentation);
        when(anActionEventMock.getProject()).thenReturn(projectMock);
        when(anActionEventMock.getDataContext()).thenReturn(dataContextMock);

        when(dataContextMock.getData(DataKeys.VIRTUAL_FILE_ARRAY)).thenReturn(new VirtualFile[]{blocFileMock});

        bootstrapSingleTestAction.update(anActionEventMock);
        assertFalse(presentation.isVisible());

        when(blocFileMock.getName()).thenReturn("feature_my_feature_bloc.dart");
        bootstrapSingleTestAction.update(anActionEventMock);
        assertTrue(presentation.isVisible());

        when(blocFileMock.getName()).thenReturn("ala_bala.dart");
        bootstrapSingleTestAction.update(anActionEventMock);
        assertFalse(presentation.isVisible());

        when(blocFileMock.getName()).thenReturn("feature_my_feature_service.dart");
        bootstrapSingleTestAction.update(anActionEventMock);
        assertTrue(presentation.isVisible());

        when(blocFileMock.getName()).thenReturn("ala_bala.dart");
        bootstrapSingleTestAction.update(anActionEventMock);
        assertFalse(presentation.isVisible());

        when(blocFileMock.getName()).thenReturn("feature_my_feature_repository.dart");
        bootstrapSingleTestAction.update(anActionEventMock);
        assertTrue(presentation.isVisible());

        when(blocFileMock.getName()).thenReturn("ala_bala.dart");
        bootstrapSingleTestAction.update(anActionEventMock);
        assertFalse(presentation.isVisible());

        when(blocFileMock.getName()).thenReturn("feature_my_feature_page.dart");
        bootstrapSingleTestAction.update(anActionEventMock);
        assertTrue(presentation.isVisible());

        when(blocFileMock.getName()).thenReturn("ala_bala.dart");
        bootstrapSingleTestAction.update(anActionEventMock);
        assertFalse(presentation.isVisible());

        when(blocFileMock.getName()).thenReturn("feature_my_feature_widget.dart");
        bootstrapSingleTestAction.update(anActionEventMock);
        assertTrue(presentation.isVisible());

        when(blocFileMock.getName()).thenReturn("ala_bala.dart");
        bootstrapSingleTestAction.update(anActionEventMock);
        assertFalse(presentation.isVisible());
    }


    @Test
    public void testGenerateConstructorParams() {
        HashMap<String, String> constructorFields = new HashMap<>();
        HashMap<String, Boolean> constructorNamedFields = new HashMap<>();
        //no fields
        String constructorParams = bootstrapSingleTestAction.generateConstructorParams(constructorFields, constructorNamedFields);
        assertTrue(constructorParams.isEmpty());

        //case all non-named fields
        addFields(constructorFields);
        constructorParams = bootstrapSingleTestAction.generateConstructorParams(constructorFields, constructorNamedFields);
        assertFalse(constructorParams.isEmpty());
        assertEquals(constructorParams, "        myName2,\n        myName,\n");

        //case named and non-named fields
        addNamed(constructorNamedFields, "myName");
        constructorParams = bootstrapSingleTestAction.generateConstructorParams(constructorFields, constructorNamedFields);
        assertEquals(constructorParams, "        myName2,\n        myName: myName,\n");

        //case only named fields
        addNamed(constructorNamedFields, "myName2");
        constructorParams = bootstrapSingleTestAction.generateConstructorParams(constructorFields, constructorNamedFields);
        assertEquals(constructorParams, "        myName2: myName2,\n        myName: myName,\n");

    }

    @Test
    public void testGenerateRepository() throws IOException {
        HashMap<String, String> constructorFields = new HashMap<>();
        HashMap<String, Boolean> constructorNamedFields = new HashMap<>();

        VirtualFile repoFileMock = mock(VirtualFile.class);
        DataContext dataContextMock = mock(DataContext.class);
        AnActionEvent anActionEventMock = mock(AnActionEvent.class);
        Presentation presentation = new Presentation();
        Project projectMock = mock(Project.class);
        when(anActionEventMock.getPresentation()).thenReturn(presentation);
        when(anActionEventMock.getProject()).thenReturn(projectMock);
        when(anActionEventMock.getDataContext()).thenReturn(dataContextMock);

        when(dataContextMock.getData(DataKeys.VIRTUAL_FILE_ARRAY)).thenReturn(new VirtualFile[]{repoFileMock});
        File file = new File("src/test/resources/bootstrap_repos_tests/empty_repository.dart");

        when(repoFileMock.getPath()).thenReturn(file.getPath());
        when(repoFileMock.getName()).thenReturn(file.getName());
        String inputRepoText = String.join("\n", Files.readAllLines(file.toPath()));

//        test generation with no constructor fields and no public methods
        String generateTest = bootstrapSingleTestAction.generateTest(repoFileMock, inputRepoText, constructorFields, constructorNamedFields).trim();

        file = new File("src/test/resources/bootstrap_repos_tests/empty_repository_result.dart");
        inputRepoText = String.join("\n", Files.readAllLines(file.toPath())).trim();

        assertEquals(generateTest, inputRepoText);

        //test with constructor fields (no named) and only private methods
        addFields(constructorFields);
        file = new File("src/test/resources/bootstrap_repos_tests/only_private_repository.dart");

        when(repoFileMock.getPath()).thenReturn(file.getPath());
        when(repoFileMock.getName()).thenReturn(file.getName());
        inputRepoText = String.join("\n", Files.readAllLines(file.toPath()));

        generateTest = bootstrapSingleTestAction.generateTest(repoFileMock, inputRepoText, constructorFields, constructorNamedFields).trim();

        file = new File("src/test/resources/bootstrap_repos_tests/only_private_repository_result.dart");
        inputRepoText = String.join("\n", Files.readAllLines(file.toPath())).trim();

        assertEquals(generateTest, inputRepoText);

        //test with mix of named and non-named fields and public and private methods
        addFields(constructorFields);
        file = new File("src/test/resources/bootstrap_repos_tests/full_repository.dart");

        when(repoFileMock.getPath()).thenReturn(file.getPath());
        when(repoFileMock.getName()).thenReturn(file.getName());
        inputRepoText = String.join("\n", Files.readAllLines(file.toPath()));

        addNamed(constructorNamedFields, "myName");
        generateTest = bootstrapSingleTestAction.generateTest(repoFileMock, inputRepoText, constructorFields, constructorNamedFields).trim();

        file = new File("src/test/resources/bootstrap_repos_tests/full_repository_result.dart");
        inputRepoText = String.join("\n", Files.readAllLines(file.toPath())).trim();

        assertEquals(generateTest, inputRepoText);

        //test with all named constructor fields and only public methods

        addFields(constructorFields);
        file = new File("src/test/resources/bootstrap_repos_tests/only_public_repository.dart");

        when(repoFileMock.getPath()).thenReturn(file.getPath());
        when(repoFileMock.getName()).thenReturn(file.getName());
        inputRepoText = String.join("\n", Files.readAllLines(file.toPath()));

        addNamed(constructorNamedFields, "myName2");
        generateTest = bootstrapSingleTestAction.generateTest(repoFileMock, inputRepoText, constructorFields, constructorNamedFields).trim();

        file = new File("src/test/resources/bootstrap_repos_tests/only_public_repository_result.dart");
        inputRepoText = String.join("\n", Files.readAllLines(file.toPath())).trim();

        assertEquals(generateTest, inputRepoText);
    }

    private void addFields(HashMap<String, String> constructorFields) {
        constructorFields.put("myName2", "MyType2");
        constructorFields.put("myName", "MyType");
    }

    private void addNamed(HashMap<String, Boolean> constructorNamedFields, String myName) {
        constructorNamedFields.put(myName, true);
    }

//    @Test
//    public void testGenerateService() {
//        // the same as repo as such this is not so crucial
//
//        HashMap<String, String> constructorFields = new HashMap<>();
//        HashMap<String, Boolean> constructorNamedFields = new HashMap<>();
//
//        VirtualFile serviceFileMock = mock(VirtualFile.class);
//        DataContext dataContextMock = mock(DataContext.class);
//        AnActionEvent anActionEventMock = mock(AnActionEvent.class);
//        Presentation presentation = new Presentation();
//        Project projectMock = mock(Project.class);
//        when(anActionEventMock.getPresentation()).thenReturn(presentation);
//        when(anActionEventMock.getProject()).thenReturn(projectMock);
//        when(anActionEventMock.getDataContext()).thenReturn(dataContextMock);
//
//        when(dataContextMock.getData(DataKeys.VIRTUAL_FILE_ARRAY)).thenReturn(new VirtualFile[]{serviceFileMock});
////        File file = new File("src/test/resources/empty_repository.dart");
//
////        bootstrapSingleTestAction.generateTest(serviceFileMock, projectMock);
//    }


    @Test
    public void testGenerateImportsFromFileAndClasses() {
        String text = "";
        List<String> values = new ArrayList<>();
        VirtualFile rootDir = mock(VirtualFile.class);
        VirtualFile file = mock(VirtualFile.class);
        VirtualFile blocsDir = mock(VirtualFile.class);
        when(file.getParent()).thenReturn(blocsDir);
        when(blocsDir.getPath()).thenReturn("Path/to/project/my_app/lib/subfolder/feature_x2r4/blocs");
        when(rootDir.getPath()).thenReturn("Path/to/project/my_app");
        when(rootDir.getName()).thenReturn("my_app");

        String classes = bootstrapSingleTestAction.generateImportsFromFileAndClasses(text, values, rootDir, file);
        assertEquals("", classes);

        text = "import 'package:rx_bloc/rx_bloc.dart';\n" +
                "import 'package:rxdart/rxdart.dart';\n" +
                "import '../../base/extensions/error_model_extensions.dart';\n" +
                "import '../../../base/models/errors/profile_data.dart';\n" +
                "class MyBloc {}";

        values.add("List<ProfileData>");
        classes = bootstrapSingleTestAction.generateImportsFromFileAndClasses(text, values, rootDir, file);
        assertEquals("import 'package:my_app/base/models/errors/profile_data.dart';",
                classes.trim());
    }

}