extension ExceptionExtensions on Object {
  String get asErrorString => toString().replaceAll('Exception:', '').trim();
}
