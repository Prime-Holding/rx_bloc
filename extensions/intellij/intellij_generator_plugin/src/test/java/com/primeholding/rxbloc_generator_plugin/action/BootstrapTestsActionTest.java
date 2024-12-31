package com.primeholding.rxbloc_generator_plugin.action;

import com.intellij.openapi.actionSystem.AnActionEvent;
import com.intellij.openapi.actionSystem.DataContext;
import com.intellij.openapi.actionSystem.PlatformDataKeys;
import com.intellij.openapi.actionSystem.Presentation;
import com.intellij.openapi.project.Project;
import com.intellij.openapi.vfs.VirtualFile;
import org.junit.Test;

import static org.junit.Assert.assertFalse;
import static org.junit.Assert.assertTrue;
import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.when;

public class BootstrapTestsActionTest {
    BootstrapTestsAction bootstrapSingleTestAction = new BootstrapTestsAction();

    @Test
    public void testUpdate() {

        VirtualFile folderMock = mock(VirtualFile.class);
        VirtualFile folder2Mock = mock(VirtualFile.class);
        DataContext dataContextMock = mock(DataContext.class);
        AnActionEvent anActionEventMock = mock(AnActionEvent.class);
        Presentation presentation = new Presentation();
        Project projectMock = mock(Project.class);
        when(anActionEventMock.getPresentation()).thenReturn(presentation);
        when(anActionEventMock.getProject()).thenReturn(projectMock);
        when(anActionEventMock.getDataContext()).thenReturn(dataContextMock);

        when(dataContextMock.getData(PlatformDataKeys.VIRTUAL_FILE_ARRAY)).thenReturn(new VirtualFile[]{folderMock});

        when(folderMock.isDirectory()).thenReturn(true);
        when(folder2Mock.isDirectory()).thenReturn(true);
//        isChooseBlogsDialog
        when(folderMock.getName()).thenReturn("lib");
        when(folder2Mock.getName()).thenReturn("lib2");

        bootstrapSingleTestAction.update(anActionEventMock);
        assertTrue(presentation.isVisible());

        when(folderMock.getName()).thenReturn("src");
        bootstrapSingleTestAction.update(anActionEventMock);
        assertTrue(presentation.isVisible());

        when(folderMock.getName()).thenReturn("test");
        bootstrapSingleTestAction.update(anActionEventMock);
        assertTrue(presentation.isVisible());

        //on eny other empty folder
        when(folderMock.getName()).thenReturn("anyOther");
        when(folderMock.getChildren()).thenReturn(new VirtualFile[]{});
        when(folder2Mock.getChildren()).thenReturn(new VirtualFile[]{});
        bootstrapSingleTestAction.update(anActionEventMock);
        assertFalse(presentation.isVisible());


        VirtualFile blocsFolder = mock(VirtualFile.class);
        VirtualFile pagesFolder = mock(VirtualFile.class);

        when(blocsFolder.getName()).thenReturn("blocs");
        when(pagesFolder.getName()).thenReturn("views1");

        when(blocsFolder.isDirectory()).thenReturn(true);
        when(pagesFolder.isDirectory()).thenReturn(true);

        when(folderMock.getChildren()).thenReturn(new VirtualFile[]{blocsFolder});
        bootstrapSingleTestAction.update(anActionEventMock);
        //having only blocs
        assertFalse(presentation.isVisible());

        when(folderMock.getChildren()).thenReturn(new VirtualFile[]{blocsFolder, pagesFolder});
        bootstrapSingleTestAction.update(anActionEventMock);
        assertFalse(presentation.isVisible());

        //having blocs and page
        when(pagesFolder.getName()).thenReturn("views");
        bootstrapSingleTestAction.update(anActionEventMock);
        assertTrue(presentation.isVisible());

        when(dataContextMock.getData(PlatformDataKeys.VIRTUAL_FILE_ARRAY)).thenReturn(new VirtualFile[]{folder2Mock, folderMock});
        bootstrapSingleTestAction.update(anActionEventMock);
        assertTrue(presentation.isVisible());
    }

}