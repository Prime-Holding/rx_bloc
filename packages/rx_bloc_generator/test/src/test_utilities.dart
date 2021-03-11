part of 'rx_bloc_test.dart';

/// TEST UTILITIES
enum TestEnumParam {
  optional,
  named,
  seed,
}

// Mocked classes
class _WithAnnotationAnd2PositionalEventArgs {
  const _WithAnnotationAnd2PositionalEventArgs(this.pp1, this.pp2);

  final int pp1;

  final int pp2;
}

class _WithSeededPositionalAndOptionalEventArgs {
  const _WithSeededPositionalAndOptionalEventArgs(this.pp, [this.op]);

  final int pp;

  final int? op;
}

class _WithSeeded2PositionalEnumEventArgs {
  const _WithSeeded2PositionalEnumEventArgs(this.pp1, this.pp2);

  final int pp1;

  final TestEnumParam pp2;
}
