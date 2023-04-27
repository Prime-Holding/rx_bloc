package com.primeholding.rxbloc_generator_plugin.generator.components;

import org.junit.Test;

import java.io.File;
import java.io.IOException;
import java.nio.file.Files;

import static org.junit.Assert.assertEquals;

public class RxBlocWithServiceGeneratorTest {

    @Test
    public void testSampleServiceCreation() throws IOException {
        RxBlocWithServiceGenerator rxBlocGenerator = new RxBlocWithServiceGenerator("profile_bloc");
        String generate = rxBlocGenerator.generate().trim();
        File file = new File("src/test/resources/generator/RxBlocWithServiceGenerator/sample_service.dart");
        String inputRepoText = String.join("\n", Files.readAllLines(file.toPath())).trim();
        assertEquals(generate, inputRepoText);
    }

}
