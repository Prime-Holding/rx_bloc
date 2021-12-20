part of 'loading_bloc.dart';

extension _IsLoadingHelpers on Stream<_TagCountTuple> {
  Stream<LoadingWithTag> mapToLoadingWithTag() => map(
        (tuple) => LoadingWithTag(
          loading: tuple.count >= 1,
          tag: tuple.tag,
        ),
      );
}

extension _LoadingCountsBinders on Stream<Result<dynamic>> {
  StreamSubscription bindToLoadingCounts(
    BehaviorSubject<Map<String, BehaviorSubject<_TagCountTuple>>> loadingCounts,
  ) =>
      listen((result) {
        /// ignore: close_sinks
        final tagPerSubject = loadingCounts.value[result.tag];

        if (tagPerSubject != null) {
          /// Emit an event to the existing subject
          tagPerSubject.value = tagPerSubject.value
              .copyWith(incrementCount: result is ResultLoading);
          return;
        }

        final map = loadingCounts.value;

        /// Mark all tuples as not initial, as this will allow to skip
        /// the seed value when at [_LoadingCountsMappers.mapToLoadingWithTag]
        map.entries
            .map((entry) => entry.value.value)
            .forEach((tuple) => tuple.initial = false);

        /// Add new subject
        map[result.tag] = BehaviorSubject.seeded(_TagCountTuple(
          tag: result.tag,
          count: 1,
        ));

        loadingCounts.value = map;
      });
}

extension _LoadingCountsMappers
    on Stream<Map<String, BehaviorSubject<_TagCountTuple>>> {
  Stream<LoadingWithTag> mapToLoadingWithTag() => flatMap(
        (value) => Rx.merge(
          value.entries.map(
            (entry) {
              final stream = entry.value.mapToLoadingWithTag().distinct();

              /// Skip the seed value if the tuple is not initials
              return entry.value.value.initial == false
                  ? stream.skip(1)
                  : stream;
            },
          ),
        ),
      ).distinct();
}
