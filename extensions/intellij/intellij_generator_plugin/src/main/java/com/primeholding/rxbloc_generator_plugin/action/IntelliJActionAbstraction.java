package com.primeholding.rxbloc_generator_plugin.action;

import com.intellij.openapi.actionSystem.AnActionEvent;
import com.intellij.openapi.application.ApplicationManager;
import com.intellij.openapi.command.CommandProcessor;
import com.intellij.openapi.fileEditor.FileEditorManager;
import com.intellij.openapi.ui.Messages;
import com.intellij.openapi.vfs.VfsUtil;
import com.intellij.openapi.vfs.VirtualFile;
import com.intellij.testFramework.VfsTestUtil;

import java.io.File;
import java.io.IOException;
import java.nio.file.Files;

public abstract class IntelliJActionAbstraction {

    protected AnActionEvent event;
    protected boolean isReadyToExecute = false;

    public IntelliJActionAbstraction setEvent(AnActionEvent e) {
        event = e;
        return this;
    }

    public void execute() {
        if (isReadyToExecute) {
            executeInCommand(this::run);
        }
    }

    protected void openInIDE(String mockFilePath) {
        VirtualFile file = VfsUtil.findFileByIoFile(new File(mockFilePath), true);
        if (file != null && event.getProject() != null) {
            FileEditorManager.getInstance(event.getProject())
                    .openFile(file, true);
        }
    }

    protected void writeServiceMock(String serviceMock, String file) {
        VfsTestUtil.overwriteTestData(file, serviceMock);
    }

    protected String readFile(VirtualFile file) {
        try {
            return new String(Files.readAllBytes(new File(file.getPath()).toPath()));
        } catch (IOException e) {
            e.printStackTrace();
            showMessage("Error: " + e.getMessage() + " file: " + file.getPath(), "Error Reading File");
        }
        return null;
    }

    protected void executeInCommand(Runnable runnable) {
        ApplicationManager.getApplication().runWriteAction(() ->
                CommandProcessor.getInstance().executeCommand(event.getProject(), runnable, commandName(), null)
        );
    }

    protected abstract String commandName();

    public abstract IntelliJActionAbstraction checkPreconditions();

    public abstract void run();

    protected boolean fileExists(String path) {
        return new java.io.File(path).exists();
    }

    protected void showMessage(String message, @SuppressWarnings("SameParameterValue") String title) {
        Messages.showMessageDialog(message, title,
                null
        );
    }

}