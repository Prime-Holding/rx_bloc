package com.primeholding.rxbloc_generator_plugin.intention_action;


public class Snippets {
    public static final String BLOC_SNIPPET_KEY = "BlocType";
    public static final String STATE_TYPE_SNIPPET_KEY = "StateType";
    public static final String STATE_SNIPPET_KEY = "someState";

    static String getSnippet(SnippetType snippetType, String widget) {
        switch (snippetType) {
            case RxBlocBuilder:
                return blocBuilderSnippet(widget);
            case RxPaginatedBuilder:
                return blocPaginatedBuilderSnippet(widget);
            case RxResultBuilder:
                return blocResultBuilderSnippet(widget);
        }

        return blocBuilderSnippet(widget);
    }

    private static String blocBuilderSnippet(String widget) {
        return String.format("RxBlocBuilder<%1$s, %2$s>(\n" +
                "  state: (bloc) => bloc.states.%3$s,\n"+
                "  builder: (context, snapshot, bloc) =>\n" +
                "    %4$s,\n" +
                ")", BLOC_SNIPPET_KEY, STATE_TYPE_SNIPPET_KEY, STATE_SNIPPET_KEY, widget);
    }

    private static String blocPaginatedBuilderSnippet(String widget) {
        return String.format("RxPaginatedBuilder<%1$s, %2$s>.withRefreshIndicator(\n" +
                        "          state: (bloc) => bloc.states.%3$s,\n" +
                        "          onBottomScrolled: (bloc) => bloc.events.loadPage(),\n" +
                        "          onRefresh: (bloc) async {\n" +
                        "            bloc.events.loadPage(reset: true);\n" +
                        "            return bloc.states.refreshDone;\n" +
                        "          },\n" +
                        "          buildSuccess: (context, list, bloc) => ListView.builder(\n" +
                        "            itemBuilder: (context, index) {\n" +
                        "               final item = list.getItem(index);\n\n" +
                        "               if (item == null) {\n" +
                        "                return const YourProgressIndicator();\n" +
                        "               }\n\n" +
                        "              return YourListTile(item: item);\n" +
                        "            },\n" +
                        "            itemCount: list.itemCount,\n" +
                        "          ),\n" +
                        "          buildLoading: (context, list, bloc) =>\n" +
                        "              const YourProgressIndicator(),\n" +
                        "          buildError: (context, list, bloc) =>\n" +
                        "              YourErrorWidget(error: list.error!),\n" +
                        "        )\n", BLOC_SNIPPET_KEY, STATE_TYPE_SNIPPET_KEY, STATE_SNIPPET_KEY, widget);
    }

    private static String blocResultBuilderSnippet(String widget) {
        return String.format("RxResultBuilder<%1$s, %2$s>(\n" +
                " state: (bloc) => bloc.states.%3$s,\n" +
                " buildSuccess: (context, data, bloc) => %4$s,\n" +
                " buildLoading: (context, bloc) => \n" +
                "   const CircularProgressIndicator(),\n" +
                " buildError: (context, error, bloc) => \n" +
                "   Text(error),\n" +
                ")", BLOC_SNIPPET_KEY, STATE_TYPE_SNIPPET_KEY, STATE_SNIPPET_KEY, widget);
    }
}
