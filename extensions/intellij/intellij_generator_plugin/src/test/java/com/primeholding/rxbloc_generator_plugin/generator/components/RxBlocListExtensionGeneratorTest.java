package com.primeholding.rxbloc_generator_plugin.generator.components;

import org.junit.Test;

import java.io.File;
import java.io.IOException;
import java.nio.file.Files;

import static org.junit.Assert.assertEquals;

public class RxBlocListExtensionGeneratorTest {

    @Test
    public void testSampleServiceCreation() throws IOException {
        RxBlocListExtensionGenerator rxBlocGenerator = new RxBlocListExtensionGenerator("profile_bloc");
        String generate = rxBlocGenerator.generate().trim();
        File file = new File("src/test/resources/generator/RxBlocListExtensionGenerator/sample_list_bloc_extensions.dart");
        String inputRepoText = String.join("\n", Files.readAllLines(file.toPath())).trim();
        assertEquals(generate, inputRepoText);
    }

}
