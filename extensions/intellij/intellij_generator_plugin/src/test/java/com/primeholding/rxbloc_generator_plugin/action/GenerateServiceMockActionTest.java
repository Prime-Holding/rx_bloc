package com.primeholding.rxbloc_generator_plugin.action;

import com.primeholding.rxbloc_generator_plugin.action.GenerateServiceMockAction.GenerateServiceAction;
import org.junit.Test;

//    Sample test action - by implementing the action wrapper and overwriting IntelliJ API calls,
//    so unit tests on actual business logic are clearer
public class GenerateServiceMockActionTest {
    @SuppressWarnings("unused")
    GenerateServiceMockAction generateServiceMockActionTest = new GenerateServiceMockAction() {
        @Override
        protected IntelliJActionAbstraction actionAbstraction() {
            return new GenerateServiceActionMock();
        }
    };

    @Test
    public void testUpdate() {
        //test visibility depending on inputs
//        generateServiceMockActionTest.update();
    }


    @Test
    public void testActionPerformed() {
//        generateServiceMockActionTest.actionPerformed();
    }

}

class GenerateServiceActionMock extends GenerateServiceAction {


    protected void openInIDE(String mockFilePath) {
        //intentionally do nothing. This is unit test and no IDE is available
    }

    protected void writeServiceMock(String serviceMock, String file) {
        //intentionally do nothing. No need to write somoething on file
    }


    protected void executeInCommand(Runnable runnable) {
        //directly run - without IntelliJ Command wrap
        runnable.run();
    }


    protected void showMessage(String message, @SuppressWarnings("SameParameterValue") String title) {
        //Skip showing message
    }
}