package com.primeholding.rxbloc_generator_plugin.generator.components;

import org.junit.Test;

import java.io.File;
import java.io.IOException;
import java.nio.file.Files;

import static org.junit.Assert.assertEquals;

public class RxBlocListGeneratorTest {

    @Test
    public void testSampleServiceCreation() throws IOException {
        RxBlocListGenerator rxBlocGenerator = new RxBlocListGenerator("profile_bloc");
        String generate = rxBlocGenerator.generate().trim();
        File file = new File("src/test/resources/generator/RxBlocListGenerator/sample_list_bloc.dart");
        String inputRepoText = String.join("\n", Files.readAllLines(file.toPath())).trim();
        assertEquals(generate, inputRepoText);
    }

}
