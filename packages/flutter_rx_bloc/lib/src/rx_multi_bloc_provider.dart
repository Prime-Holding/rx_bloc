import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import 'rx_bloc_provider.dart';

/// {@template rxmultiblocprovider}
/// Merges multiple BlocProvider widgets into one widget tree.
///
/// [RxMultiBlocProvider] improves the readability and eliminates the need
/// to nest multiple [RxBlocProvider]s.
///
/// By using [RxMultiBlocProvider] we can go from:
///
/// ```dart
/// RxBlocProvider<BlocA>(
///   create: (BuildContext context) => BlocA(),
///   child: RxBlocProvider<BlocB>(
///     create: (BuildContext context) => BlocB(),
///     child: RxBlocProvider<BlocC>(
///       create: (BuildContext context) => BlocC(),
///       child: ChildA(),
///     )
///   )
/// )
/// ```
///
/// to:
///
/// ```dart
/// RxMultiBlocProvider(
///   providers: [
///     RxBlocProvider<BlocA>(
///       create: (BuildContext context) => BlocA(),
///     ),
///     RxBlocProvider<BlocB>(
///       create: (BuildContext context) => BlocB(),
///     ),
///     RxBlocProvider<BlocC>(
///       create: (BuildContext context) => BlocC(),
///     ),
///   ],
///   child: ChildA(),
/// )
/// ```
///
/// [RxMultiBlocProvider] converts the [RxBlocProvider] list
/// into a tree of nested [RxBlocProvider] widgets.
/// As a result, the only advantage of using [RxMultiBlocProvider] is improved
/// readability due to the reduction in nesting and boilerplate.
/// {@endtemplate}
class RxMultiBlocProvider extends StatelessWidget {
  /// {@macro rxmultiblocprovider}
  const RxMultiBlocProvider({
    Key? key,
    required this.providers,
    required this.child,
  }) : super(key: key);

  /// The [RxBlocProvider] list which is converted into a tree
  /// of [RxBlocProvider] widgets.
  /// The tree of [RxBlocProvider] widgets is created in order meaning
  /// the first [RxBlocProvider]
  /// will be the top-most [RxBlocProvider] and the last [RxBlocProvider]
  /// will be a direct ancestor
  /// of [child].
  final List<RxBlocProvider> providers;

  /// The widget and its descendants which will have access to every bloc
  /// provided by [providers].
  /// [child] will be a direct descendent of
  /// the last [RxBlocProvider] in [providers].
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: providers,
      child: child,
    );
  }
}
