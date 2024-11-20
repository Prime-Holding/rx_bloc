package com.primeholding.rxbloc_generator_plugin.generator.components;

import org.junit.Test;

import java.io.File;
import java.io.IOException;
import java.nio.file.Files;

import static org.junit.Assert.assertEquals;

public class RxTestBlocFactoryGeneratorTest extends BaseTestGenerator {

    @Test
    public void testBlocWithAll() throws IOException {
        RxTestBlocFactoryGenerator rxBlocGenerator = new RxTestBlocFactoryGenerator(blockName(), projectName(), getWithAllBloc());
        String generate = rxBlocGenerator.generate().trim();
        File file = new File("src/test/resources/generator/RxTestBlocFactoryGenerator/RxTestBlocFactoryGenerator_all.dart");
        String inputRepoText = String.join("\n", Files.readAllLines(file.toPath())).trim();
        assertEquals(generate, inputRepoText);
    }


}
