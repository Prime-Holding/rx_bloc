/// DataRepositoryInterface represents an interface that the intended data repository
/// should implement so it can be used along with the RxBlocList.
///
/// The fetchPage method allows the repository to respond to data queries that
/// include pagination, when a page number (staring from 0) is supplied.
abstract class DataRepositoryInterface<T> {
  /// Returns a list of items based on the provided page.
  Future<List<T>> fetchPage(int page);
}
