package com.primeholding.rxbloc_generator_plugin.intent_action;

import com.primeholding.rxbloc_generator_plugin.intention_action.SmartSnippets;
import com.primeholding.rxbloc_generator_plugin.intention_action.SnippetType;
import com.primeholding.rxbloc_generator_plugin.intention_action.Snippets;
import org.junit.Test;

import static com.primeholding.rxbloc_generator_plugin.intention_action.SnippetType.*;
import static com.primeholding.rxbloc_generator_plugin.intention_action.SnippetType.RxBlocBuilder;
import static org.junit.Assert.*;
import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.when;

public class SmartSnippetsTest {
    @Test
    public void testRxResultBuilder() {

        compare(RxResultBuilder, "RxResultBuilder<ProfileBlocType, ProfileData>(\n" +
                " state: (bloc) => bloc.states.profileData,\n" +
                " buildSuccess: (context, data, bloc) => const SizedBox(),\n" +
                " buildLoading: (context, bloc) => \n" +
                "   const CircularProgressIndicator(),\n" +
                " buildError: (context, error, bloc) => \n" +
                "   Text(error.toString()),\n" +
                ")", "Result<ProfileData>");
    }

    @Test
    public void testRxPaginatedBuilder() {

        compare(RxPaginatedBuilder, "RxPaginatedBuilder<ProfileBlocType, ProfileData>.withRefreshIndicator(\n" +
                "          state: (bloc) => bloc.states.profileData,\n" +
                "          onBottomScrolled: (bloc) => bloc.events.loadPage(),\n" +
                "          onRefresh: (bloc) async {\n" +
                "            bloc.events.loadPage(reset: true);\n" +
                "            return bloc.states.refreshDone;\n" +
                "          },\n" +
                "          buildSuccess: (context, list, bloc) => ListView.builder(\n" +
                "            itemBuilder: (context, index) {\n" +
                "               final item = list.getItem(index);\n" +
                "\n" +
                "               if (item == null) {\n" +
                "               //TODO write your own progress indicator\n" +
                "                return const YourProgressIndicator();\n" +
                "               }\n" +
                "\n" +
                "              //TODO write your own list item widget\n" +
                "               return YourListTile(item: item);\n" +
                "            },\n" +
                "            itemCount: list.itemCount,\n" +
                "          ),\n" +
                "          buildLoading: (context, list, bloc) =>\n" +
                "              const YourProgressIndicator(),\n" +
                "          buildError: (context, list, bloc) =>\n" +
                "              YourErrorWidget(error: list.error!),// TODO write your own error widget\n" +
                "        )", "PaginatedList<ProfileData>");
    }

    @Test
    public void testRxBlocListener() {

        compare(RxBlocListener, "RxBlocListener<ProfileBlocType, ProfileData>(\n" +
                "  state: (bloc) => bloc.states.profileData,\n" +
                "  listener: (context, state) {\n" +
                "    // do stuff here based on BlocA's state\n" +
                "  }, \n" +
                "  child: const SizedBox(),\n" +
                ")");
    }

    @Test
    public void testRxFormFieldBuilder() {

        compare(RxFormFieldBuilder, "RxFormFieldBuilder<ProfileBlocType, ProfileData>(\n" +
                "     state: (bloc) => bloc.states.profileData,\n" +
                "     showErrorState: (bloc) => bloc.states.showErrors,\n" +
                "     builder: (fieldState) => Column(\n" +
                "       children: [\n" +
                "         const SizedBox(),\n" +
                "         //show errors, say for instance the user tries to save the\n" +
                "         //changes to the form, but they forgot to select a color.\n" +
                "         if (fieldState.showError)\n" +
                "           Row(\n" +
                "             children: [\n" +
                "               Text(\n" +
                "                 fieldState.error,\n" +
                "               ),\n" +
                "             ],\n" +
                "           ),\n" +
                "       ],\n" +
                "      ),\n" +
                "   )");
    }

    @Test
    public void testRxTextFormFieldBuilder() {
        compare(RxTextFormFieldBuilder, "RxTextFormFieldBuilder<ProfileBlocType>( \n" +
                " state: (bloc) => bloc.states.profileData,\n" +
                " showErrorState: (bloc) => bloc.states.showErrors,\n" +
                "//TODO pick a specific event the field will to send data to\n" +
                " onChanged: (bloc, value) => bloc.events.specificEvent(value), // pick a specific event the field will to send data to\n" +
                "   ///TODO: Use the controller from the fieldState\n" +
                "   /// example: `controller: fieldState.controller`\n" +
                "\n" +
                "   ///TODO: Copy the decoration generated by the builder widget, which\n" +
                "   ///contains stuff like when to show errors, with additional\n" +
                "   ///decoration\n" +
                "   ///Example `decoration: fieldState.decoration.copyWithDecoration(InputStyles.textFieldDecoration)`\n" +
                " builder: (fieldState) => const SizedBox(),)");
    }

    @Test
    public void testRxBlocBuilder() {

        compare(RxBlocBuilder, "RxBlocBuilder<ProfileBlocType, ProfileData>(\n" +
                "  state: (bloc) => bloc.states.profileData,\n" +
                "  builder: (context, snapshot, bloc) =>\n" +
                "    const SizedBox(),\n" +
                ")");
    }

    private void compare(SnippetType snippet, String result) {
        compare(snippet, result, "ProfileData");
    }

    private void compare(SnippetType snippet, String result, String stateTypeDirectorySuggest) {
        String blocTypeDirectorySuggest = "ProfileBlocType";
        String stateVariableNameSuggest = "profileData";
        String widget = "const SizedBox()";

        String replacement = SmartSnippets.getSnippet(snippet, widget, blocTypeDirectorySuggest, stateTypeDirectorySuggest, stateVariableNameSuggest);
        assertEquals(result, replacement);
    }
}
