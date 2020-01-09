class DetailsRepository {
  Future<String> fetch() =>
      Future.delayed(Duration(seconds: 1), () => "Details has been loaded.");
}
