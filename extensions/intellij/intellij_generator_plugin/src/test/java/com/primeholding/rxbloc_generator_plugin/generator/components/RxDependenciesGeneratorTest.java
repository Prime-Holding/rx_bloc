package com.primeholding.rxbloc_generator_plugin.generator.components;

import com.primeholding.rxbloc_generator_plugin.action.GenerateRxBlocDialog;
import org.junit.Test;

import java.io.File;
import java.io.IOException;
import java.nio.file.Files;

import static org.junit.Assert.assertEquals;

public class RxDependenciesGeneratorTest {

    @Test
    public void testWithServiceRoutingIntegrationNone() throws IOException {
        RxDependenciesGenerator rxBlocGenerator = new RxDependenciesGenerator("profile_bloc", GenerateRxBlocDialog.RoutingIntegration.None, true);
        String generate = rxBlocGenerator.generate().trim();
        File file = new File("src/test/resources/generator/RxDependenciesGenerator/rx_dependencies_withService_RoutingIntegration_None.dart");
        String inputRepoText = String.join("\n", Files.readAllLines(file.toPath())).trim();
        assertEquals(generate, inputRepoText);
    }

    @Test
    public void testWithServiceRoutingIntegrationAutoRoute() throws IOException {
        RxDependenciesGenerator rxBlocGenerator = new RxDependenciesGenerator("profile_bloc", GenerateRxBlocDialog.RoutingIntegration.AutoRoute, true);
        String generate = rxBlocGenerator.generate().trim();
        File file = new File("src/test/resources/generator/RxDependenciesGenerator/rx_dependencies_withService_RoutingIntegration_AutoRoute.dart");
        String inputRepoText = String.join("\n", Files.readAllLines(file.toPath())).trim();
        assertEquals(generate, inputRepoText);
    }

    @Test
    public void testWithServiceRoutingIntegrationGoRouter() throws IOException {
        RxDependenciesGenerator rxBlocGenerator = new RxDependenciesGenerator("profile_bloc", GenerateRxBlocDialog.RoutingIntegration.GoRouter, true);
        String generate = rxBlocGenerator.generate().trim();
        File file = new File("src/test/resources/generator/RxDependenciesGenerator/rx_dependencies_withService_RoutingIntegration_GoRouter.dart");
        String inputRepoText = String.join("\n", Files.readAllLines(file.toPath())).trim();
        assertEquals(generate, inputRepoText);
    }

    @Test
    public void testNoServiceRoutingIntegrationNone() throws IOException {
        RxDependenciesGenerator rxBlocGenerator = new RxDependenciesGenerator("profile_bloc", GenerateRxBlocDialog.RoutingIntegration.None, false);
        String generate = rxBlocGenerator.generate().trim();
        File file = new File("src/test/resources/generator/RxDependenciesGenerator/rx_dependencies_noService_RoutingIntegration_None.dart");
        String inputRepoText = String.join("\n", Files.readAllLines(file.toPath())).trim();
        assertEquals(generate, inputRepoText);
    }

    @Test
    public void testNoServiceRoutingIntegrationAutoRoute() throws IOException {
        RxDependenciesGenerator rxBlocGenerator = new RxDependenciesGenerator("profile_bloc", GenerateRxBlocDialog.RoutingIntegration.AutoRoute, false);
        String generate = rxBlocGenerator.generate().trim();
        File file = new File("src/test/resources/generator/RxDependenciesGenerator/rx_dependencies_noService_RoutingIntegration_AutoRoute.dart");
        String inputRepoText = String.join("\n", Files.readAllLines(file.toPath())).trim();
        assertEquals(generate, inputRepoText);
    }

    @Test
    public void testNoServiceRoutingIntegrationGoRouter() throws IOException {
        RxDependenciesGenerator rxBlocGenerator = new RxDependenciesGenerator("profile_bloc", GenerateRxBlocDialog.RoutingIntegration.GoRouter, false);
        String generate = rxBlocGenerator.generate().trim();
        File file = new File("src/test/resources/generator/RxDependenciesGenerator/rx_dependencies_noService_RoutingIntegration_GoRouter.dart");
        String inputRepoText = String.join("\n", Files.readAllLines(file.toPath())).trim();
        assertEquals(generate, inputRepoText);
    }

}
