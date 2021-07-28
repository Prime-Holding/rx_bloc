class GithubRepoPaginatedSearch {
  GithubRepoPaginatedSearch({
    required this.query,
    required this.reset,
    required this.hardReset,
  });

  final String query;
  final bool reset;
  final bool hardReset;
}
