import 'package:equatable/equatable.dart';

class TodoStatsModel with EquatableMixin {
  /// The number of completed todos.
  final int completed;

  /// The number of incomplete todos.
  final int incomplete;

  const TodoStatsModel({
    required this.completed,
    required this.incomplete,
  });

  @override
  List<Object?> get props => [completed, incomplete];

  @override
  bool? get stringify => true;
}
