package com.primeholding.rxbloc_generator_plugin.generator.components;

import org.junit.Test;

import java.io.File;
import java.io.IOException;
import java.nio.file.Files;

import static org.junit.Assert.assertEquals;

public class RxBlocGeneratedFileGeneratorTest {

    @Test
    public void testWithDefaultStatesAndService() throws IOException {
        RxGeneratedNullSafetyBlocGenerator rxBlocGenerator = new RxGeneratedNullSafetyBlocGenerator("profile_bloc.dart", true, true);
        String generate = rxBlocGenerator.generate().trim();
        File file = new File("src/test/resources/generator/RxBlocGeneratedFileGenerator/WithDefaultStatesAndService_rx_bloc_generated_test.dart");
        String inputRepoText = String.join("\n", Files.readAllLines(file.toPath())).trim();
        assertEquals(generate, inputRepoText);
    }


    @Test
    public void testWithDefaultStates() throws IOException {
        RxGeneratedNullSafetyBlocGenerator rxBlocGenerator = new RxGeneratedNullSafetyBlocGenerator("profile_bloc.dart", true, false);
        String generate = rxBlocGenerator.generate().trim();
        File file = new File("src/test/resources/generator/RxBlocGeneratedFileGenerator/WithDefaultStates_rx_bloc_generated_test.dart");
        String inputRepoText = String.join("\n", Files.readAllLines(file.toPath())).trim();

        assertEquals(generate, inputRepoText);
    }


    @Test
    public void testWithService() throws IOException {
        RxGeneratedNullSafetyBlocGenerator rxBlocGenerator = new RxGeneratedNullSafetyBlocGenerator("profile_bloc.dart", false, true);
        String generate = rxBlocGenerator.generate().trim();
        File file = new File("src/test/resources/generator/RxBlocGeneratedFileGenerator/WithService_rx_bloc_generater_test.dart");
        String inputRepoText = String.join("\n", Files.readAllLines(file.toPath())).trim();
        assertEquals(generate, inputRepoText);
    }


    @Test
    public void testWithNothing() throws IOException {
        RxGeneratedNullSafetyBlocGenerator rxBlocGenerator = new RxGeneratedNullSafetyBlocGenerator("profile_bloc.dart", false, false);
        String generate = rxBlocGenerator.generate().trim();
        File file = new File("src/test/resources/generator/RxBlocGeneratedFileGenerator/WithNothing_rx_bloc_generated_test.dart");
        String inputRepoText = String.join("\n", Files.readAllLines(file.toPath())).trim();

        assertEquals(generate, inputRepoText);
    }

}
