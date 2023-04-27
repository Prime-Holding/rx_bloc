package com.primeholding.rxbloc_generator_plugin.generator.components;

import org.junit.Test;

import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.util.Iterator;
import java.util.stream.Collectors;

import static org.junit.Assert.assertEquals;

public class RxTestBlocGeneratorTest extends BaseTestGenerator {

    @Test
    public void testBlocWithAll() throws IOException {
        RxTestBlocGenerator rxBlocGenerator = new RxTestBlocGenerator(blockName(), projectName(), getWithAllBloc(), false);
        String generate = rxBlocGenerator.generate().trim();
        File file = new File("src/test/resources/generator/RxTestBlocGenerator/RxTestBlocGenerator_all.dart");
        String inputRepoText = new String(Files.readAllBytes(file.toPath()));
        assertEquals(generate, inputRepoText);
    }


}
