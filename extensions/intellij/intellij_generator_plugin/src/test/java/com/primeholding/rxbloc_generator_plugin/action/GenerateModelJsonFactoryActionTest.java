package com.primeholding.rxbloc_generator_plugin.action;

import com.intellij.openapi.editor.Editor;
import com.intellij.openapi.project.Project;
import com.intellij.psi.PsiFile;
import com.primeholding.rxbloc_generator_plugin.intention_action.GenerateModelJsonFactoryAction;
import org.jetbrains.annotations.NotNull;
import org.junit.Test;

import java.io.File;
import java.io.IOException;
import java.nio.file.Files;

import static org.junit.Assert.*;
import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.when;

public class GenerateModelJsonFactoryActionTest {
    private String text;
    GenerateModelJsonFactoryAction generateModelJsonFactoryAction = new GenerateModelJsonFactoryAction() {

        @Override
        protected void writeTextBack(String text, Project project, Editor editor) {
            //replaced with test implementation - because it is IntelliJ API calls
            GenerateModelJsonFactoryActionTest.this.text = text;
        }

        @NotNull
        @Override
        protected String getOpenEditorsText(Editor editor) {
            return text;
        }
    };

    @Test
    public void testInvoke() throws IOException {

        Project projectMock = mock(Project.class);
        PsiFile fileMock = mock(PsiFile.class);

        when(fileMock.getName()).thenReturn("model.dart");
        Editor editorMock = mock(Editor.class);

        File file = new File("src/test/resources/actions/JsonFactoryAction/model.dart");
        text = String.join("\n", Files.readAllLines(file.toPath())).trim();
        generateModelJsonFactoryAction.invoke(projectMock, editorMock, fileMock);

        file = new File("src/test/resources/actions/JsonFactoryAction/model_after.dart");
        String outputText = String.join("\n", Files.readAllLines(file.toPath())).trim();

        //text is overwritten by the extension of the test generateModelJsonFactoryAction implementation
        assertEquals(outputText, text);

        file = new File("src/test/resources/actions/JsonFactoryAction/model_with_enum.dart");
        text = String.join("\n", Files.readAllLines(file.toPath())).trim();

        file = new File("src/test/resources/actions/JsonFactoryAction/model_with_enum_after.dart");
        outputText = String.join("\n", Files.readAllLines(file.toPath())).trim();
        generateModelJsonFactoryAction.invoke(projectMock, editorMock, fileMock);

        assertEquals(outputText, text);
    }

    @Test
    public void testIsAvailable() {
        Project projectMock = mock(Project.class);
        PsiFile fileMock = mock(PsiFile.class);
        Editor editorMock = mock(Editor.class);

        when(fileMock.getName()).thenReturn("whatever.dart");

        boolean available = generateModelJsonFactoryAction.isAvailable(projectMock, editorMock, fileMock);
        assertFalse(available);

        text = "";
        when(fileMock.getName()).thenReturn("whatever_model.dart");

        available = generateModelJsonFactoryAction.isAvailable(projectMock, editorMock, fileMock);
        assertFalse(available);

        text = "@JsonSerializable() .fromJson(Map<String, dynamic> json";
        available = generateModelJsonFactoryAction.isAvailable(projectMock, editorMock, fileMock);
        assertFalse(available);

        text = "@JsonSerializable()";
        available = generateModelJsonFactoryAction.isAvailable(projectMock, editorMock, fileMock);
        assertTrue(available);
    }
}
