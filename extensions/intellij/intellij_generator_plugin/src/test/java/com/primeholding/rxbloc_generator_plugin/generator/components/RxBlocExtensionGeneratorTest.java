package com.primeholding.rxbloc_generator_plugin.generator.components;

import org.junit.Test;

import java.io.File;
import java.io.IOException;
import java.nio.file.Files;

import static org.junit.Assert.assertEquals;

public class RxBlocExtensionGeneratorTest {

    @Test
    public void testWithDefaultStatesAndService() throws IOException {
        RxBlocExtensionGenerator rxBlocGenerator = new RxBlocExtensionGenerator("profile_bloc.dart", true, true);
        String generate = rxBlocGenerator.generate().trim();
        File file = new File("src/test/resources/generator/RxBlocExtensionGenerator/WithDefaultStatesAndService_rx_bloc_extensions_test.dart");
        String inputRepoText = String.join("\n", Files.readAllLines(file.toPath())).trim();
        assertEquals(generate, inputRepoText);
    }


    @Test
    public void testWithDefaultStates() throws IOException {
        RxBlocExtensionGenerator rxBlocGenerator = new RxBlocExtensionGenerator("profile_bloc.dart", true, false);
        String generate = rxBlocGenerator.generate().trim();
        File file = new File("src/test/resources/generator/RxBlocExtensionGenerator/WithDefaultStates_rx_bloc_extensions_test.dart");
        String inputRepoText = String.join("\n", Files.readAllLines(file.toPath())).trim();

        assertEquals(generate, inputRepoText);
    }


    @Test
    public void testWithService() throws IOException {
        RxBlocExtensionGenerator rxBlocGenerator = new RxBlocExtensionGenerator("profile_bloc.dart", false, true);
        String generate = rxBlocGenerator.generate().trim();
        File file = new File("src/test/resources/generator/RxBlocExtensionGenerator/WithService_rx_bloc_extensions_test.dart");
        String inputRepoText = String.join("\n", Files.readAllLines(file.toPath())).trim();
        assertEquals(generate, inputRepoText);
    }


    @Test
    public void testWithNothing() throws IOException {
        RxBlocExtensionGenerator rxBlocGenerator = new RxBlocExtensionGenerator("profile_bloc.dart", false, false);
        String generate = rxBlocGenerator.generate().trim();
        File file = new File("src/test/resources/generator/RxBlocExtensionGenerator/WithNothing_rx_bloc_extensions_test.dart");
        String inputRepoText = String.join("\n", Files.readAllLines(file.toPath())).trim();

        assertEquals(generate, inputRepoText);
    }
}
