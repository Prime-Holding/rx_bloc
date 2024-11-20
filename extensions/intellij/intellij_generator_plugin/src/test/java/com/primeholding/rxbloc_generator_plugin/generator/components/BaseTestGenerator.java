package com.primeholding.rxbloc_generator_plugin.generator.components;

import com.intellij.openapi.vfs.VirtualFile;
import com.primeholding.rxbloc_generator_plugin.generator.parser.TestableClass;
import org.mockito.Mockito;

import java.io.File;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;


public abstract class BaseTestGenerator {
    protected String blockName() {
        return "sample_bloc";
    }

    protected String projectName() {
        return "my_test_app";
    }

    protected String templateNameGoldenToolkit() {
        return  "bloc_factory";
    }

    protected String templateNameAlchemist() {
        return  "bloc_alchemist_golden";
    }

    protected TestableClass getWithRelativeBloc(@SuppressWarnings("SameParameterValue") String relativePath) {

        VirtualFile appFolder = Mockito.mock(VirtualFile.class);
        VirtualFile lib = Mockito.mock(VirtualFile.class);
        VirtualFile blockFile = Mockito.mock(VirtualFile.class);
        File javaFile = new File("src/test/resources/generator/TestSource/sample_bloc.dart");
        Mockito.when(blockFile.getPath()).thenReturn(javaFile.getAbsolutePath());
        Mockito.when(blockFile.getParent()).thenReturn(lib);

        Mockito.when(blockFile.getName()).thenReturn("sample_bloc.dart");

        Mockito.when(lib.getParent()).thenReturn(appFolder);
        Mockito.when(appFolder.getName()).thenReturn(projectName());

        Mockito.when(lib.getName()).thenReturn("lib");
        List<String> stateVariableNames = new ArrayList<>();
        List<String> stateVariableTypes = new ArrayList<>();
        List<Boolean> stateIsConnectableStream = new ArrayList<>();

        stateVariableNames.add("state0void");
        stateVariableNames.add("state1");
        stateVariableNames.add("stateNullable1");
        stateVariableNames.add("stateResult2");
        stateVariableNames.add("stateListOfCustomType");
        stateVariableNames.add("statePaginatedResult3");
        stateVariableNames.add("connectableState");

        stateVariableTypes.add("void");
        stateVariableTypes.add("String");
        stateVariableTypes.add("String?");
        stateVariableTypes.add("Result<String>");
        stateVariableTypes.add("List<CustomType>");
        stateVariableTypes.add("PaginatedList<CustomType2>");
        stateVariableTypes.add("bool");

        stateIsConnectableStream.add(Boolean.FALSE);
        stateIsConnectableStream.add(Boolean.FALSE);
        stateIsConnectableStream.add(Boolean.FALSE);
        stateIsConnectableStream.add(Boolean.FALSE);
        stateIsConnectableStream.add(Boolean.FALSE);
        stateIsConnectableStream.add(Boolean.FALSE);
        stateIsConnectableStream.add(Boolean.TRUE);


        //currently, not parsed and not in use
        List<String> repos = new ArrayList<>();
        List<String> services = new ArrayList<>();


        List<String> constructorFieldTypes = new ArrayList<>();
        Map<String, Boolean> constructorFieldNamedNames = new HashMap<>();
        List<String> constructorFieldNames = new ArrayList<>();

        constructorFieldNames.add("sampleRepo");
        constructorFieldNames.add("sampleService");
        constructorFieldNames.add("sampleRequired");
        constructorFieldNames.add("sampleNamedAndResult");
        constructorFieldNames.add("namedNullable");

        constructorFieldTypes.add("SampleRepository");
        constructorFieldTypes.add("SampleService");
        constructorFieldTypes.add("SampleRequired");
        constructorFieldTypes.add("SampleNamedAndResult");
        constructorFieldTypes.add("String?");

        constructorFieldNamedNames.put("SampleNamedAndResult", Boolean.TRUE);
        constructorFieldNamedNames.put("namedNullable", Boolean.TRUE);

        return new TestableClass(blockFile, relativePath, stateVariableNames, stateVariableTypes, stateIsConnectableStream,
                repos, services, constructorFieldNames, constructorFieldNamedNames, constructorFieldTypes, true);
    }

    protected TestableClass getWithAllBloc() {
        return getWithRelativeBloc("");
    }
    //    protected TestableClass getEmptyBloc() {
//    nice to have
//    }
//    protected TestableClass getWithOnlyNamedFieldsAndWithOnlyConnectableBloc() {
//        nice to have
//    }
//
//    protected TestableClass getWithOnlyRequiredFieldsAndWithNoConnectableBloc() {
//        nice to have
//    }
}
