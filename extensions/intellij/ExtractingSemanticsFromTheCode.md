# Semantics Objects Extractor

## Why?

The core idea - of having all functional layering is to have so strict code organization that: 
- New Developer will know where to look-do-what
- The Plugin will be able to make some smart things 

## What 
The core classes that are extracted are the BloCs. A semantic representation of the class wrapped in a TestableClass instance.

### The TestableClass (Originally named BloC) has:
- Constructor fields and their types
- States - their content types that if the stream is Connectable

### Class Method
Similar Class is the ClassMethod - that could be used in the future to make better code generations on the Service/Repository and other components
Similar Utils are used for Views Extraction, but only for Constructor Analysis

![BloC_Diagram](https://user-images.githubusercontent.com/98388232/234209949-d2654a27-1f7d-436a-988e-879b63cc1969.jpg)


## How

For this to work the code should be organized in a conventional naming structure.

- (feature/lib)_abc
- - blocs
- - - bloc_abc.dart
- - di
- - views/pages/widgets/components
- - - page_abc.dart


## Parsing BloC / Service / Repo 

- The parsing of the files is done by reading the file as a text/String/ and looking for definitions by convention. The core utility the does this is:

```getValueBetween(text: String, from: String, to: String): String?  ```

- Parsing Arguments and fields 

``` “{class/method name}(“ …… “)” // looking between class method definition and the closing parentesis```

- States inside

``` “{AbcBloC}State{“ ……... “}” ```

and Lines with

``` “{optional Connectable}Stream<{content type of the stream}> get {the name of the stream}” ```

- Public functions of Services or Repositories - //(lines that start with interval “ ” and return type and name - not starting definition with  “_”.

## File System Info

To have better file modification - relative to the other code - File System Analysys is executed in the plugin: 

- the position of the file in the project structure relative position to the lib/test folder
- the project name - used to figure out the import declarations.


## Use of Bloc Semantic Representation

### Intent Actions - core class SmartSnippets.java

Views display the different states of the BloCs and as such - Rx Bloc Wrappers are the main UI-Bloc building blocks. 

When conventions are followed and there is a BloC and page files in place - while editing the page/views - the Plugin could look for 
the appropriate states and offer better auto-completion and code generation.

### Actions taking advantage

The extracted BloC object is used in actions for Bootstrapping tests and all the boilerplate code associated with testing: 

- The expected values of different States
- Golden Pages - where all the states that are visualized are mocked. 
- Bootstrap of the public methods of Service
 
