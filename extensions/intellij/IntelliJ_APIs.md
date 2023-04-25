# The IntelliJ APIs that the Plugin Uses

## Files API

IntelliJ has several APIs for Files (eg  [java.io.File](https://docs.oracle.com/javase/7/docs/api/java/io/File.html))

https://plugins.jetbrains.com/docs/intellij/virtual-file.html

https://plugins.jetbrains.com/docs/intellij/psi-files.html  

If it requires closer to the File System - representation - VirtualFile is used. If you require closer to the IDE - PsiFile. 

## Access the selected files from the ActionEvent

``` event?.dataContext?.getData(DataKeys.VIRTUAL_FILE_ARRAY) ```

## Opening a File into the IDE Editor

``` FileEditorManager.getInstance(project).openFile(newFile, false)//(Virtual File) ``` 

## Writing files

Writing something onto the file system is not enough. 
If the File System changes - the IDE normally requires force refreshing. 
Writing something into must be wrapped in a Write Action Runnable and additionally in a IntelliJ Command for the IDE to have it up to date. 
This is done in such a way because of the [Command Pattern](https://en.wikipedia.org/wiki/Command_pattern#:~:text=In%20object%2Doriented%20programming%2C%20the,values%20for%20the%20method%20parameters) - so the IDE could try to properly handle the undo/redo actions.

``` 
WriteCommandAction.runWriteCommandAction(e.project!!) {
   CommandProcessor.getInstance().executeCommand(project, { //. . .
   })
}) 
``` 
   
## Simple messaging to the user

The API for showing a [JOptionPane](https://docs.oracle.com/javase/7/docs/api/javax/swing/JOptionPane.html) messages is [com.intellij.openapi.ui.Messages](https://github.com/JetBrains/intellij-community/blob/master/platform/platform-api/src/com/intellij/openapi/ui/Messages.java)


   
