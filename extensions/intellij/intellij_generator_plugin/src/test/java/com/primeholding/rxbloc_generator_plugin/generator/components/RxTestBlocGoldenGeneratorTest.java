package com.primeholding.rxbloc_generator_plugin.generator.components;

import org.junit.Test;

import java.io.File;
import java.io.IOException;
import java.nio.file.Files;

import static org.junit.Assert.assertEquals;

public class RxTestBlocGoldenGeneratorTest extends BaseTestGenerator {

    @Test
    public void testBlocWithAll() throws IOException {
        RxTestBlocGoldenGenerator rxBlocGenerator = new RxTestBlocGoldenGenerator(blockName(), "bloc_golden", projectName(), getWithAllBloc());
        String generate = rxBlocGenerator.generate().trim();
        File file = new File("src/test/resources/generator/RxTestBlocGoldenGenerator/RxTestBlocGoldenGenerator_all.dart");
        String inputRepoText = String.join("\n", Files.readAllLines(file.toPath())).trim();
        assertEquals(generate, inputRepoText);
    }

    @Test
    public void testBlocAlchemistWithAll() throws IOException {
        RxTestBlocGoldenGenerator rxBlocGenerator = new RxTestBlocGoldenGenerator(blockName(), "bloc_alchemist_golden", projectName(), getWithAllBloc());
        String generate = rxBlocGenerator.generate().trim();
        File file = new File("src/test/resources/generator/RxTestBlocGoldenGenerator/RxTestBlocAlchemistGoldenGenerator_all.dart");
        String inputRepoText = String.join("\n", Files.readAllLines(file.toPath())).trim();
        assertEquals(generate, inputRepoText);
    }
}