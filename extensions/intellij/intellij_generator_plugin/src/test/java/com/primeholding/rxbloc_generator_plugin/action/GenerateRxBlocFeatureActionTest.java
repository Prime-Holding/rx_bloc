package com.primeholding.rxbloc_generator_plugin.action;

import com.intellij.openapi.actionSystem.AnActionEvent;
import com.intellij.openapi.actionSystem.DataContext;
import com.intellij.openapi.actionSystem.PlatformDataKeys;
import com.intellij.openapi.actionSystem.Presentation;
import com.intellij.openapi.project.Project;
import com.intellij.openapi.vfs.VirtualFile;
import org.junit.Test;

import java.io.File;
import java.io.IOException;
import java.nio.file.Files;

import static org.junit.Assert.*;
import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.when;

public class GenerateRxBlocFeatureActionTest {
    GenerateRxBlocFeatureAction generateRxBlocFeatureAction = new GenerateRxBlocFeatureAction();

    @Test
    public void testUpdate() {

        VirtualFile folderMock = mock(VirtualFile.class);
        DataContext dataContextMock = mock(DataContext.class);
        AnActionEvent anActionEventMock = mock(AnActionEvent.class);
        Presentation presentation = new Presentation();
        Project projectMock = mock(Project.class);
        when(anActionEventMock.getPresentation()).thenReturn(presentation);
        when(anActionEventMock.getProject()).thenReturn(projectMock);
        when(anActionEventMock.getDataContext()).thenReturn(dataContextMock);

        when(dataContextMock.getData(PlatformDataKeys.VIRTUAL_FILE_ARRAY)).thenReturn(new VirtualFile[]{folderMock});

        when(folderMock.isDirectory()).thenReturn(true);

        generateRxBlocFeatureAction.update(anActionEventMock);
        assertTrue(presentation.isVisible());

        when(folderMock.isDirectory()).thenReturn(false);
        generateRxBlocFeatureAction.update(anActionEventMock);
        assertFalse(presentation.isVisible());
    }


    @Test
    public void testEditPermissionsController() throws IOException {
        File file = new File("src/test/resources/actions/GoRouterChanges/permissionsControllerBefore.dart");
        String inputText = String.join("\n", Files.readAllLines(file.toPath())).trim();

        String output = generateRxBlocFeatureAction.editPermissionsController(inputText, "DevMenu");

        file = new File("src/test/resources/actions/GoRouterChanges/permissionsControllerAfter.dart");
        String outputText = String.join("\n", Files.readAllLines(file.toPath())).trim();

        assertEquals(outputText, output);

    }

    @Test
    public void testEditRoutePermissions() throws IOException {
        File file = new File("src/test/resources/actions/GoRouterChanges/routePermissionsBefore.dart");
        String inputText = String.join("\n", Files.readAllLines(file.toPath())).trim();

        String output = generateRxBlocFeatureAction.editRoutePermissions(inputText, "devMenu", "DevMenu");

        file = new File("src/test/resources/actions/GoRouterChanges/routePermissionsAfter.dart");
        String outputText = String.join("\n", Files.readAllLines(file.toPath())).trim();

        assertEquals(outputText, output);
    }

    @Test
    public void testEditRouter() throws IOException {
        File file = new File("src/test/resources/actions/GoRouterChanges/routerBefore.dart");
        String inputText = String.join("\n", Files.readAllLines(file.toPath())).trim();

        String partRoutes = ""; //The sample input already contains part 'routes/routes.dart';

        String output = generateRxBlocFeatureAction.editRouter(inputText, "", "dev_menu", partRoutes);

        file = new File("src/test/resources/actions/GoRouterChanges/routerAfter.dart");
        String outputText = String.join("\n", Files.readAllLines(file.toPath())).trim();

        assertEquals(outputText, output);
    }

    @Test
    public void testEditRoutesPath() throws IOException {
        File file = new File("src/test/resources/actions/GoRouterChanges/routesPathBefore.dart");
        String inputText = String.join("\n", Files.readAllLines(file.toPath())).trim();

        String output = generateRxBlocFeatureAction.editRoutesPath(inputText, "devMenu");

        file = new File("src/test/resources/actions/GoRouterChanges/routesPathAfter.dart");
        String outputText = String.join("\n", Files.readAllLines(file.toPath())).trim();

        assertEquals(outputText, output);
    }

    @Test
    public void testEditRouteModel() throws IOException {
        File file = new File("src/test/resources/actions/GoRouterChanges/routeModelBefore.dart");
        String inputText = String.join("\n", Files.readAllLines(file.toPath())).trim();

        String output = generateRxBlocFeatureAction.editRouteModel(inputText, "devMenu");

        file = new File("src/test/resources/actions/GoRouterChanges/routeModelAfter.dart");
        String outputText = String.join("\n", Files.readAllLines(file.toPath())).trim();

        assertEquals(outputText, output);
    }

    @Test
    public void testGenerateNewRoute()  throws IOException {

        String output = generateRxBlocFeatureAction.generateNewRoute("DevMenu", "devMenu").trim();

        File file = new File("src/test/resources/actions/GoRouterChanges/GenerateNewRoute.dart");
        String outputText = String.join("\n", Files.readAllLines(file.toPath())).trim();

        assertEquals(outputText, output);
    }

    @Test
    public void testMakeSubPart() {
        VirtualFile featureSubDirectory = mock(VirtualFile.class);
        Project projectMock = mock(Project.class);
        when(projectMock.getBasePath()).thenReturn("Path/to/the/Project");
        when(featureSubDirectory.getPath()).thenReturn("Path/to/the/Project/lib/feature_dev_menu");

        String output = generateRxBlocFeatureAction.makeSubPart(featureSubDirectory, "dev_menu", projectMock);
        assertTrue(output.isEmpty());

        when(featureSubDirectory.getPath()).thenReturn("Path/to/the/Project/lib/grouped_features/feature_dev_menu");
        output = generateRxBlocFeatureAction.makeSubPart(featureSubDirectory, "dev_menu", projectMock);

        assertEquals("/grouped_features", output);
    }

}