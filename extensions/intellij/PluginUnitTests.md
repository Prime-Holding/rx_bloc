### Unit Tests on The Plugin

## Overview 

Most tests contain sample input files and their corresponding result - after getting through the functionality of the plugin. 
This way from the tests themself - you could get an idea what the plugin’s actions does on the code.

## Sample tests

- Validating tests from file templates

```
//reading the input file
file = new File("src/test/resources/bootstrap_repos_tests/full_repository.dart"); //repository with public and private methods
………  // mocking inputs

// going through the transformation
generateTest = bootstrapSingleTestAction.generateTest(.....);
……

//reading the sample result
file = new File("src/test/resources/bootstrap_repos_tests/full_repository_result.dart");
inputRepoText = //reading the file;

//testing
assertEquals(generateTest, inputRepoText);
```

- Inline Checks

```
//input paramters for the snippet transformation
String blocType = "ProfileBlocType";
String stateVariableName = "profileData";
String widget = "const SizedBox()";

//transformation
String replacement = SmartSnippets.getSnippet(snippet, widget, blocType, stateType, stateVariableName);


//verifying output
compare(RxBlocBuilder, "RxBlocBuilder<ProfileBlocType, ProfileData>(\n" +
           "  state: (bloc) => bloc.states.profileData,\n" +
           "  builder: (context, snapshot, bloc) =>\n" +
           "    const SizedBox(),\n" +
           ")");
}
assertEquals(result, replacement);
```
The essential business logic of the plugins are String/Code transformations with different parameters or new code generators.

- New Code Generators
- Code Snippet Utils 

To archive bigger code coverage - try decoupling components in future actions. The blocks of the plugin that are harder to test are: 
- Java IO APIs - used for reading/writing files and doing file system checks
- Java GUI APIs - used for dialogs - asking the user to choose from elements 
- The Different IntelliJ APIs

Not all requirements may be easy to wrap, but, whenerver possible:

- Capsulate the calles to the external APIs,
- Make a mocked version of the action wrapper - where you override these calls, so the tests could run from console.
- Test only the expected code transformation

Sample approach to wrap the different APIs and make code more testable
could be found [here](https://github.com/Prime-Holding/rx_bloc/commit/cd116dfc54c6147f0219e43ba7f45af795b39fb3).
