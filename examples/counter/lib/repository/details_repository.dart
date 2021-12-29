class DetailsRepository {
  Future<String> fetch() => Future.delayed(
        const Duration(seconds: 1),
        () => 'Details have been loaded ',
      );
}
