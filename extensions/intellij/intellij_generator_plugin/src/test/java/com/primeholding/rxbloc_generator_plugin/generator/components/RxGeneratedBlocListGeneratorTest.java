package com.primeholding.rxbloc_generator_plugin.generator.components;

import org.junit.Test;

import java.io.File;
import java.io.IOException;
import java.nio.file.Files;

import static java.nio.file.Files.readAllLines;
import static org.junit.Assert.assertEquals;

public class RxGeneratedBlocListGeneratorTest {

    @Test
    public void testSampleServiceCreation() throws IOException {
        RxGeneratedBlocListGenerator rxBlocGenerator = new RxGeneratedBlocListGenerator("profile_bloc");
        String generate = rxBlocGenerator.generate().trim();
        File file = new File("src/test/resources/generator/RxGeneratedBlocListGenerator/sample_list_bloc.dart");
        String inputRepoText = String.join("\n", Files.readAllLines(file.toPath())).trim();
        assertEquals(generate, inputRepoText);
    }

}
