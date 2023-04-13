package com.primeholding.rxbloc_generator_plugin.generator.parser;

import com.intellij.openapi.vfs.VirtualFile;
import org.junit.Test;

import java.io.File;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;

import static org.junit.Assert.*;
import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.when;

public class UtilsTest {

    @Test
    public void testExtractBloc() {
        VirtualFile file = mock(VirtualFile.class);
        VirtualFile fileParent = mock(VirtualFile.class);

        when((file.exists())).thenReturn(false);
        TestableClass testableClass = Utils.Companion.extractBloc(file);

        assertNull(testableClass);


        when((fileParent.getName())).thenReturn("feature_x");
        when((fileParent.getParent())).thenReturn(fileParent);
        when((file.getParent())).thenReturn(fileParent);
        when((file.exists())).thenReturn(true);
        when(file.isDirectory()).thenReturn(true);

        testableClass = Utils.Companion.extractBloc(file);
        assertNull(testableClass);

        when(file.isDirectory()).thenReturn(false);
        File javFile = new File("src/test/resources/generator/RxBlocGenerator/WithDefaultStatesAndService_rx_bloc_generator_test.dart");
        when(file.getPath()).thenReturn(javFile.getPath());


        when(file.getName()).thenReturn("WithDefaultStatesAndService_rx_bloc_generator_test.dart");
        testableClass = Utils.Companion.extractBloc(file);
        assertNotNull(testableClass);
        assertFalse(testableClass.isLib());

        when((fileParent.getName())).thenReturn("lib_x");
        testableClass = Utils.Companion.extractBloc(file);
        assertNotNull(testableClass);
        assertTrue(testableClass.isLib());

        assertTrue(testableClass.getStateVariableNames().containsAll(Arrays.asList("isLoading", "errors", "data")));
        assertTrue(testableClass.getStateVariableTypes().containsAll(Arrays.asList("bool", "ErrorModel", "Result<String>")));
    }

    @Test
    public void testFixRelativeImports() {
        VirtualFile appFolder = mock(VirtualFile.class);
        when(appFolder.getPath()).thenReturn("Path/to/project/my_app");
        when(appFolder.getName()).thenReturn("my_app");
        VirtualFile file = mock(VirtualFile.class);
        VirtualFile featureFolder = mock(VirtualFile.class);


        when(file.getPath()).thenReturn("Path/to/project/my_app/lib/subfolder/feature_x2r4/blocs/axc_bloc.dart");
        when(featureFolder.getPath()).thenReturn("Path/to/project/my_app/lib/subfolder/feature_x2r4/blocs/");
        when(file.getParent()).thenReturn(featureFolder);
        when(file.getName()).thenReturn("axc_bloc.dart");


        String relativeImports = Utils.Companion.fixRelativeImports("import '../../../../../base/models/errors/error_model.dart';",
                appFolder, file);
        assertEquals(relativeImports, "import 'package:my_app/base/models/errors/error_model.dart';");
    }


    @Test
    public void testGetClassName() {

        VirtualFile blocFile = mock(VirtualFile.class);
        File file = new File("src/test/resources/generator/RxBlocWithServiceGenerator/sample_service.dart");
        when(blocFile.getPath()).thenReturn(file.getPath());
        String className = Utils.Companion.getClassName(blocFile);
        assertEquals(className, "ProfileService");

        file = new File("src/test/resources/generator/RxBlocListExtensionGenerator/sample_list_bloc_extensions.dart");
        when(blocFile.getName()).thenReturn(file.getName());
        when(blocFile.getPath()).thenReturn(file.getPath());
        className = Utils.Companion.getClassName(blocFile);
        assertEquals(className, "sample_list_bloc_extensions.dart");
    }

    @Test
    public void testUnCheckExisting() {

        final ArrayList<TestableClass> selected = new ArrayList<>();
        List<VirtualFile> testFolders = new ArrayList<>();
        for (int i = 0; i < 3; i++) {
            testFolders.add(mock(VirtualFile.class));

            when(testFolders.get(i).getName()).thenReturn("feature_" + i);

            selected.add(generateTestableClass(i));
        }

        VirtualFile testFolder = mock(VirtualFile.class);
        VirtualFile libFolder = mock(VirtualFile.class);
        VirtualFile appFolder = mock(VirtualFile.class);
        when(libFolder.getParent()).thenReturn(appFolder);

        when(appFolder.findChild("test")).thenReturn(testFolder);
        when(testFolder.isDirectory()).thenReturn(true);
        when(testFolder.getChildren()).thenReturn(testFolders.toArray((new VirtualFile[]{})));


        Utils.Companion.unCheckExisting(libFolder, selected);

        assertTrue(selected.isEmpty());
    }


    @Test
    public void testUnCheckExistingLeftOne() {

        final ArrayList<TestableClass> selected = new ArrayList<>();
        List<VirtualFile> testFolders = new ArrayList<>();
        for (int i = 0; i < 3; i++) {
            testFolders.add(mock(VirtualFile.class));

            when(testFolders.get(i).getName()).thenReturn("feature_" + i);

            selected.add(generateTestableClass(i));
        }
        selected.add(generateTestableClass(10));

        VirtualFile testFolder = mock(VirtualFile.class);
        VirtualFile libFolder = mock(VirtualFile.class);
        VirtualFile appFolder = mock(VirtualFile.class);
        when(libFolder.getParent()).thenReturn(appFolder);

        when(appFolder.findChild("test")).thenReturn(testFolder);
        when(testFolder.isDirectory()).thenReturn(true);
        when(testFolder.getChildren()).thenReturn(testFolders.toArray((new VirtualFile[]{})));


        Utils.Companion.unCheckExisting(libFolder, selected);

        assertEquals(selected.size(), 1);
    }

    private TestableClass generateTestableClass(int i) {
        VirtualFile blockFileMock = mock(VirtualFile.class);
        when(blockFileMock.getName()).thenReturn(i + "_bloc.dart");
        return new TestableClass(blockFileMock, "", new ArrayList<>(),
                new ArrayList<>(), new ArrayList<>(), new ArrayList<>(), new ArrayList<>(),
                new ArrayList<>(), new HashMap<>(), new ArrayList<>(), true);
    }
}
