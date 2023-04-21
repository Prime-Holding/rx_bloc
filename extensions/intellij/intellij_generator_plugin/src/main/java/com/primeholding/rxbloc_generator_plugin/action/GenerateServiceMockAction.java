package com.primeholding.rxbloc_generator_plugin.action;

import com.intellij.openapi.actionSystem.AnAction;
import com.intellij.openapi.actionSystem.AnActionEvent;
import com.intellij.openapi.actionSystem.DataKeys;
import com.intellij.openapi.vfs.VirtualFile;

import java.io.File;


public class GenerateServiceMockAction extends AnAction {

    @Override
    public void update(AnActionEvent event) {
        super.update(event);

        VirtualFile[] virtualFiles = event.getDataContext().getData(DataKeys.VIRTUAL_FILE_ARRAY);

        boolean visible = false;

        if (virtualFiles != null) {
            for (VirtualFile file : virtualFiles) {

                if (file.getName().endsWith("_service.dart")) {
                    visible = true;
                    break;
                }
            }
        }

        event.getPresentation().setVisible(visible);
    }

    @Override
    public void actionPerformed(AnActionEvent e) {
        actionAbstraction().setEvent(e).checkPreconditions().execute();
    }

    protected IntelliJActionAbstraction actionAbstraction() {
        return new GenerateServiceAction();
    }

    public static class GenerateServiceAction extends IntelliJActionAbstraction {


        protected String buildServiceMock(String serviceContent) {
            //TODO write the actual mock
            return "";
        }


        @Override
        public void run() {

            VirtualFile[] virtualFiles = event.getDataContext().getData(DataKeys.VIRTUAL_FILE_ARRAY);

            if (virtualFiles != null) {
                for (VirtualFile file : virtualFiles) {
                    if (file.getName().endsWith("_service.dart")) {
                        processService(file);
                    }
                }
            }
        }

        protected void processService(VirtualFile file) {
            String fileContent = readFile(file);
            if (fileContent != null) {
                String serviceMockText = buildServiceMock(fileContent);
                String mockFilePath = getServiceMockFilePath(file);
                writeServiceMock(serviceMockText, mockFilePath);
                openInIDE(mockFilePath);
            }
        }

        protected String getServiceMockFilePath(VirtualFile serviceFile) {
            String replace = serviceFile.getPath().replace(File.separator + "lib" + File.separator, File.separator + "test" + File.separator);
            replace = replace.replace("_service.dart", "_service_mock.dart");
            return replace;
        }


        @Override
        protected String commandName() {
            return "Generate Service Mocks";
        }

        @Override
        public IntelliJActionAbstraction checkPreconditions() {
            boolean ready = true;
            VirtualFile[] virtualFiles = event.getDataContext().getData(DataKeys.VIRTUAL_FILE_ARRAY);

            if (virtualFiles != null) {
                for (VirtualFile file : virtualFiles) {

                    if (file.getName().endsWith("_service.dart")) {
                        //check if such mock service already exists
                        String replace = getServiceMockFilePath(file);

                        if (fileExists(replace)) {
                            ready = false;
                            showMessage("File " + replace + " Already Exists!", "Duplicate Service Mock");
                            break;
                        }
                    }
                }
            }
            isReadyToExecute = ready;
            return this;
        }
    }

}
