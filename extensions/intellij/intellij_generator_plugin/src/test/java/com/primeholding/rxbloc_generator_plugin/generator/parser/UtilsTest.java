package com.primeholding.rxbloc_generator_plugin.generator.parser;

import com.intellij.openapi.vfs.VirtualFile;
import org.junit.Test;
import org.mockito.Mockito;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertTrue;

public class UtilsTest {
//    @Test
//    public void testAnalyzeFolderForBloc() {
////        //TODO Utils.Companion.analyzeFolderForBloc();
//    }

    //    @Test
//    public void testAnalyzeLib() {
//      //TODO   Utils.Companion.analyzeLib();
//    }
//@Test
//public void testExtractBloc() {
//    //TODO Utils.Companion.extractBloc();
//}
//    @Test
//    public void testFixRelativeImports() {
//        //TODO Utils.Companion.fixRelativeImports();
//    }
//    @Test
//    public void testGetClassName() {
//         //TODO Utils.Companion.getClassName();
//    }
    @Test
    public void testUnCheckExisting() {

        final ArrayList<TestableClass> selected = new ArrayList<>();
        List<VirtualFile> testFolders = new ArrayList<>();
        for (int i = 0; i < 3; i++) {
            testFolders.add(Mockito.mock(VirtualFile.class));

            Mockito.when(testFolders.get(i).getName()).thenReturn("feature_" + i);

            selected.add(generateTestableClass(i));
        }

        VirtualFile testFolder = Mockito.mock(VirtualFile.class);
        VirtualFile libFolder = Mockito.mock(VirtualFile.class);
        VirtualFile appFolder = Mockito.mock(VirtualFile.class);
        Mockito.when(libFolder.getParent()).thenReturn(appFolder);

        Mockito.when(appFolder.findChild("test")).thenReturn(testFolder);
        Mockito.when(testFolder.isDirectory()).thenReturn(true);
        Mockito.when(testFolder.getChildren()).thenReturn(testFolders.toArray((new VirtualFile[]{})));


        Utils.Companion.unCheckExisting(libFolder, selected);

        assertTrue(selected.isEmpty());
    }


    @Test
    public void testUnCheckExistingLeftOne() {

        final ArrayList<TestableClass> selected = new ArrayList<>();
        List<VirtualFile> testFolders = new ArrayList<>();
        for (int i = 0; i < 3; i++) {
            testFolders.add(Mockito.mock(VirtualFile.class));

            Mockito.when(testFolders.get(i).getName()).thenReturn("feature_" + i);

            selected.add(generateTestableClass(i));
        }
        selected.add(generateTestableClass(10));

        VirtualFile testFolder = Mockito.mock(VirtualFile.class);
        VirtualFile libFolder = Mockito.mock(VirtualFile.class);
        VirtualFile appFolder = Mockito.mock(VirtualFile.class);
        Mockito.when(libFolder.getParent()).thenReturn(appFolder);

        Mockito.when(appFolder.findChild("test")).thenReturn(testFolder);
        Mockito.when(testFolder.isDirectory()).thenReturn(true);
        Mockito.when(testFolder.getChildren()).thenReturn(testFolders.toArray((new VirtualFile[]{})));


        Utils.Companion.unCheckExisting(libFolder, selected);

        assertEquals(selected.size(), 1);
    }

    private TestableClass generateTestableClass(int i) {
        VirtualFile blockFileMock = Mockito.mock(VirtualFile.class);
        Mockito.when(blockFileMock.getName()).thenReturn(i + "_bloc.dart");
        return new TestableClass(blockFileMock, "", new ArrayList<>(),
                new ArrayList<>(), new ArrayList<>(), new ArrayList<>(), new ArrayList<>(),
                new ArrayList<>(), new HashMap<>(), new ArrayList<>(), true);
    }
}
