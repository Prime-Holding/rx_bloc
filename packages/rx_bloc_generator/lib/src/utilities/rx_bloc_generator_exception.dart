part of rx_bloc_generator;

class _RxBlocGeneratorException implements Exception {
  const _RxBlocGeneratorException([
    this.message = '',
  ]);

  final String message;
}
