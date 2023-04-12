package com.primeholding.rxbloc_generator_plugin.generator.components;

import org.junit.Test;

import java.io.File;
import java.io.IOException;
import java.nio.file.Files;

import static org.junit.Assert.assertEquals;

public class RxTestBlocMockGeneratorTest extends BaseTestGenerator {

    @Test
    public void testBlocWithAll() throws IOException {
        RxTestBlocMockGenerator rxBlocGenerator = new RxTestBlocMockGenerator(blockName(), projectName(), getWithAllBloc());
        String generate = rxBlocGenerator.generate().trim();
        //TODO this needs to be pre-generated after merge with the latest fix
        File file = new File("src/test/resources/generator/RxTestBlocMockGenerator/RxTestBlocMockGenerator_all.dart");
        String inputRepoText = String.join("\n", Files.readAllLines(file.toPath())).trim();
        assertEquals(generate, inputRepoText);
    }


}
