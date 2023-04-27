package com.primeholding.rxbloc_generator_plugin.generator.components;

import com.primeholding.rxbloc_generator_plugin.action.GenerateRxBlocDialog;
import org.junit.Test;

import java.io.File;
import java.io.IOException;
import java.nio.file.Files;

import static org.junit.Assert.assertEquals;

public class RxPageGeneratorTest {

    @Test
    public void testWithDefaultStatesRoutingIntegrationNone() throws IOException {
        RxPageGenerator rxBlocGenerator = new RxPageGenerator("profile_bloc", true, GenerateRxBlocDialog.RoutingIntegration.None);
        String generate = rxBlocGenerator.generate().trim();
        File file = new File("src/test/resources/generator/RxPageGenerator/rx_page_withDefaultStates_RoutingIntegration_None.dart");
        String inputRepoText = String.join("\n", Files.readAllLines(file.toPath())).trim();
        assertEquals(generate, inputRepoText);
    }

    @Test
    public void testWithDefaultStatesRoutingIntegrationAutoRoute() throws IOException {
        RxPageGenerator rxBlocGenerator = new RxPageGenerator("profile_bloc", true, GenerateRxBlocDialog.RoutingIntegration.AutoRoute);
        String generate = rxBlocGenerator.generate().trim();
        File file = new File("src/test/resources/generator/RxPageGenerator/rx_page_withDefaultStates_RoutingIntegration_AutoRoute.dart");
        String inputRepoText = String.join("\n", Files.readAllLines(file.toPath())).trim();
        assertEquals(generate, inputRepoText);
    }

    @Test
    public void testWithDefaultStatesRoutingIntegrationGoRouter() throws IOException {
        RxPageGenerator rxBlocGenerator = new RxPageGenerator("profile_bloc", true, GenerateRxBlocDialog.RoutingIntegration.GoRouter);
        String generate = rxBlocGenerator.generate().trim();
        File file = new File("src/test/resources/generator/RxPageGenerator/rx_page_withDefaultStates_RoutingIntegration_GoRouter.dart");
        String inputRepoText = String.join("\n", Files.readAllLines(file.toPath())).trim();
        assertEquals(generate, inputRepoText);
    }

    @Test
    public void testNoDefaultStatesRoutingIntegrationNone() throws IOException {
        RxPageGenerator rxBlocGenerator = new RxPageGenerator("profile_bloc", false, GenerateRxBlocDialog.RoutingIntegration.None);
        String generate = rxBlocGenerator.generate().trim();
        File file = new File("src/test/resources/generator/RxPageGenerator/rx_page_noDefaultStates_RoutingIntegration_None.dart");
        String inputRepoText = String.join("\n", Files.readAllLines(file.toPath())).trim();
        assertEquals(generate, inputRepoText);
    }

    @Test
    public void testNoDefaultStatesRoutingIntegrationAutoRoute() throws IOException {
        RxPageGenerator rxBlocGenerator = new RxPageGenerator("profile_bloc", false, GenerateRxBlocDialog.RoutingIntegration.AutoRoute);
        String generate = rxBlocGenerator.generate().trim();
        File file = new File("src/test/resources/generator/RxPageGenerator/rx_page_noDefaultStates_RoutingIntegration_AutoRoute.dart");
        String inputRepoText = String.join("\n", Files.readAllLines(file.toPath())).trim();
        assertEquals(generate, inputRepoText);
    }

    @Test
    public void testNoDefaultStatesRoutingIntegrationGoRouter() throws IOException {
        RxPageGenerator rxBlocGenerator = new RxPageGenerator("profile_bloc", false, GenerateRxBlocDialog.RoutingIntegration.GoRouter);
        String generate = rxBlocGenerator.generate().trim();
        File file = new File("src/test/resources/generator/RxPageGenerator/rx_page_noDefaultStates_RoutingIntegration_GoRouter.dart");
        String inputRepoText = String.join("\n", Files.readAllLines(file.toPath())).trim();
        assertEquals(generate, inputRepoText);
    }

}
