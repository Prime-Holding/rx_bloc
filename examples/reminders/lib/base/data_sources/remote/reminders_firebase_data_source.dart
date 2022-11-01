import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../models/reminder/reminder_list_response.dart';
import '../../models/reminder/reminder_model.dart';
import '../../models/reminder/reminder_model_firebase_request_date.dart';
import 'reminders_data_source.dart';

class RemindersFirebaseDataSource implements RemindersDataSource {
  RemindersFirebaseDataSource() {
    _remindersReference = _fireStore.collection(_reminders);
    _countersReference = _fireStore.collection(_counters);
    _remindersLengthsReference = _fireStore.collection(_remindersLengths);
  }

  final _fireStore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  final _facebookLogin = FacebookAuth.instance;
  late final List<ReminderModel> _data;
  late UserCredential? _userCredential;

  /// Stores the list of reminders
  late CollectionReference _remindersReference;

  /// Stores the authorId and the complete and incomplete counters
  late CollectionReference _countersReference;

  /// Stores the authorId and the length of the user's collection
  late CollectionReference _remindersLengthsReference;
  late String? _loggedInUid;

  Stream<User?> get currentUser => _auth.authStateChanges();

  var _remindersCollectionLength = 0;
  QueryDocumentSnapshot? _lastFetchedRecord;
  QueryDocumentSnapshot? _lastFetchedRecordDashboard;
  static const _storage = FlutterSecureStorage();
  static const _reminderCollectionError =
      'The reminders length value was not fetched, try to log out and log in again';
  static const _completeValueNotFetchedError =
      'The complete value was not fetched, try to log out and log in again';
  static const _incompleteValueNotFetchedError =
      'The incomplete value was not fetched, try to log out and log in again';

  static const _reminders = 'reminders';
  static const _counters = 'counters';
  static const _remindersLengths = 'remindersLengths';
  static const _complete = 'complete';
  static const _authorId = 'authorId';
  static const _anonymous = 'anonymous';
  static const _length = 'length';
  static const _incomplete = 'incomplete';
  static const _dueDate = 'dueDate';
  static const _title = 'title';
  static const _loginFailed = 'The login failed';

  Future<bool> isUserLoggedIn() async {
    var user = await _storage.read(key: _authorId);
    if (user != null) {
      return true;
    }
    return false;
  }

  Future<String?> _getAuthorIdOrNull() async {
    var user = await _storage.read(key: _authorId);
    if (user == _anonymous) {
      return null;
    }
    return user;
  }

  @override
  Future<ReminderModel> create({
    required String title,
    required DateTime dueDate,
    required bool complete,
  }) async {
    var userId = await _getAuthorIdOrNull();

    final reminderModelRequestData = ReminderModelFirebaseRequestData(
      dueDate: Timestamp.fromDate(dueDate),
      title: title,
      complete: complete,
      authorId: userId,
    );

    final createdReminder =
        await _remindersReference.add(reminderModelRequestData.toJson());
    final createdReminderId = createdReminder.id;
    final reminder = ReminderModel(
        id: createdReminderId,
        title: title,
        dueDate: dueDate,
        complete: complete,
        authorId: userId);

    var remindersCollectionLength = await _getRemindersCollectionLength();
    remindersCollectionLength++;

    await _updateRemindersCollectionLengthCounter(remindersCollectionLength);

    return reminder;
  }

  @override
  Future<void> delete(String id) async {
    await _remindersReference.doc(id).delete();

    var remindersCollectionLength = await _getRemindersCollectionLength();
    remindersCollectionLength--;

    await _updateRemindersCollectionLengthCounter(remindersCollectionLength);
  }

  Future<int> _getRemindersCollectionLength() async {
    var userId = await _getAuthorIdOrNull();
    Query query = _remindersLengthsReference;
    Query<Object?>? querySnapshot;
    querySnapshot =
        _generateQuerySnapshotForLoggedInUser(userId, querySnapshot, query);
    final remindersLengthSnapshot = await querySnapshot.get();
    int remindersLength;
    if (remindersLengthSnapshot.docs.isNotEmpty) {
      remindersLength = remindersLengthSnapshot.docs.first[_length];
    } else {
      throw Exception(_reminderCollectionError);
    }
    return remindersLength;
  }

  @override
  Future<ReminderListResponse> getAllDashboard(
      ReminderModelRequest? request) async {
    // Get the userId from local storage
    var userId = await _getAuthorIdOrNull();

    //  Generate a query
    var querySnapshot = getFirebaseFilteredQuery(request, userId);

    // Modify the query
    if (_lastFetchedRecordDashboard != null && request?.page != 1) {
      querySnapshot =
          querySnapshot.startAfterDocument(_lastFetchedRecordDashboard!);
    }
    querySnapshot = querySnapshot.limit(request!.pageSize);

    // Get the result of the query
    final snap = await querySnapshot.get();

    if (request.pageSize == 10 && snap.docs.isNotEmpty) {
      _lastFetchedRecordDashboard = snap.docs.last;
    }
    final reminders = snap.docs.asReminderList();

    return ReminderListResponse(
      items: reminders,
    );
  }

  @override
  Future<ReminderListResponse> getAll(ReminderModelRequest? request) async {
    // Get the userId from local storage
    var userId = await _getAuthorIdOrNull();
    //  Generate a query
    var querySnapshot = getFirebaseFilteredQuery(request, userId);

    // Modify the query
    if (_lastFetchedRecord != null && request?.page != 1) {
      querySnapshot = querySnapshot.startAfterDocument(_lastFetchedRecord!);
    }
    querySnapshot = querySnapshot.limit(request!.pageSize);

    // Get the result of the query
    final snap = await querySnapshot.get();

    if (request.pageSize == 10 && snap.docs.isNotEmpty) {
      _lastFetchedRecord = snap.docs.last;
    }

    final reminders = snap.docs.asReminderList();

    if (request.page == 1) {
      _remindersCollectionLength = await _getRemindersCollectionLength();
    }
    return ReminderListResponse(
      items: reminders,
      totalCount: _remindersCollectionLength,
    );
  }

  @override
  Future<int> getCompleteCount() async {
    var userId = await _getAuthorIdOrNull();
    Query query = _countersReference;
    Query<Object?>? querySnapshot;
    querySnapshot =
        _generateQuerySnapshotForLoggedInUser(userId, querySnapshot, query);
    final countersSnapshot = await querySnapshot.get();
    int counterCompleteLength;
    if (countersSnapshot.docs.isNotEmpty) {
      counterCompleteLength = countersSnapshot.docs.first[_complete];
    } else {
      throw Exception(_completeValueNotFetchedError);
    }
    return counterCompleteLength;
  }

  @override
  Future<int> getIncompleteCount() async {
    var userId = await _getAuthorIdOrNull();
    Query query = _countersReference;
    Query<Object?>? querySnapshot;
    querySnapshot =
        _generateQuerySnapshotForLoggedInUser(userId, querySnapshot, query);
    final countersSnapshot = await querySnapshot.get();

    int counterIncompleteLength;
    if (countersSnapshot.docs.isNotEmpty) {
      counterIncompleteLength = countersSnapshot.docs.first[_incomplete];
    } else {
      throw Exception(_incompleteValueNotFetchedError);
    }
    return counterIncompleteLength;
  }

  Future<bool> _loginWithFacebook() async {
    // Trigger the sign-in flow
    final facebookLoginResult = await _facebookLogin.login();
    if (facebookLoginResult.status == LoginStatus.success) {
      // Create a credential from the access token
      final facebookAuthCredential = FacebookAuthProvider.credential(
          facebookLoginResult.accessToken!.token);
      _userCredential =
          await _auth.signInWithCredential(facebookAuthCredential);
      _loggedInUid = _userCredential?.user!.uid;
      await _storage.write(key: _authorId, value: _loggedInUid);

      return true;
    } else if (facebookLoginResult.status == LoginStatus.failed) {
      throw Exception(_loginFailed);
    } else {
      return false;
    }
  }

  Future<void> logOut() async {
    try {
      await Future.wait([
        _facebookLogin.logOut(),
        _auth.signOut(),
        _storage.write(key: _authorId, value: null)
      ]);
    } catch (e) {
      rethrow;
    } finally {
      _userCredential = null;
    }
  }

  @override
  Future<ReminderPair> update(ReminderModel updatedModel) async {
    // Fetch the reminder model before its updating for comparison
    var oldReminderSnapshot =
        await _remindersReference.doc(updatedModel.id).get();

    await _remindersReference.doc(updatedModel.id).update({
      _complete: updatedModel.complete,
      _dueDate: Timestamp.fromDate(updatedModel.dueDate),
      _title: updatedModel.title,
      _authorId: updatedModel.authorId,
    });

    var oldReminder = oldReminderSnapshot.data() as Map<String, dynamic>;

    var oldReminderModel = ReminderModel(
      id: updatedModel.id,
      title: oldReminder[_title],
      dueDate: oldReminder[_dueDate].toDate(),
      complete: oldReminder[_complete],
      authorId: oldReminder[_authorId],
    );

    return ReminderPair(updated: updatedModel, old: oldReminderModel);
  }

  Future<void> _createUserCountersCollection() async {
    // If user counter collection exits update it,
    // otherwise add a new one
    Query query = _countersReference;
    var user = await _getAuthorIdOrNull();
    Query<Object?>? querySnapshot;
    querySnapshot =
        _generateQuerySnapshotForLoggedInUser(user, querySnapshot, query);
    final countersSnapshot = await querySnapshot.get();
    var length = countersSnapshot.docs.length;
    if (length > 0) {
      // A logged in user reminders collection elements have been deleted
      // and the counters document should be updated
      var counterId = countersSnapshot.docs.first.id;
      await _countersReference.doc(counterId).update({
        _authorId: _loggedInUid,
        _incomplete: 10,
        _complete: 0,
      });
    } else {
      await _countersReference.add({
        _authorId: _loggedInUid,
        _incomplete: 10,
        _complete: 0,
      });
    }
  }

  Future<void> _createUserRemindersCollectionCounter() async {
    Query query = _remindersLengthsReference;
    var user = await _getAuthorIdOrNull();
    Query<Object?>? querySnapshot;
    querySnapshot =
        _generateQuerySnapshotForLoggedInUser(user, querySnapshot, query);
    final remindersLengthsSnapshot = await querySnapshot.get();
    var length = remindersLengthsSnapshot.docs.length;
    if (length > 0) {
      var remindersLengthId = remindersLengthsSnapshot.docs.first.id;
      await _remindersLengthsReference.doc(remindersLengthId).update({
        _authorId: _loggedInUid,
        _length: 10,
      });
    } else {
      await _remindersLengthsReference.add({
        _authorId: _loggedInUid,
        _length: 10,
      });
    }
  }

  Future<void> _updateIncompleteCounter(int incomplete) async {
    var userId = await _getAuthorIdOrNull();
    Query query = _countersReference;
    Query<Object?>? querySnapshot;
    querySnapshot =
        _generateQuerySnapshotForLoggedInUser(userId, querySnapshot, query);
    final countersSnapshot = await querySnapshot.get();
    var counterId = countersSnapshot.docs.first.id;
    await _countersReference.doc(counterId).update({
      _incomplete: incomplete,
    });
  }

  Future<void> _updateCompleteCounter(int complete) async {
    var userId = await _getAuthorIdOrNull();
    Query query = _countersReference;
    Query<Object?>? querySnapshot;
    querySnapshot =
        _generateQuerySnapshotForLoggedInUser(userId, querySnapshot, query);
    final countersSnapshot = await querySnapshot.get();
    var counterId = countersSnapshot.docs.first.id;
    await _countersReference.doc(counterId).update({
      _complete: complete,
    });
  }

  Future<void> _updateRemindersCollectionLengthCounter(
      int collectionCount) async {
    var userId = await _getAuthorIdOrNull();
    Query query = _remindersLengthsReference;
    Query<Object?>? querySnapshot;
    querySnapshot =
        _generateQuerySnapshotForLoggedInUser(userId, querySnapshot, query);
    final lengthSnapshot = await querySnapshot.get();
    var lengthId = lengthSnapshot.docs.first.id;
    await _remindersLengthsReference.doc(lengthId).update({
      _length: collectionCount,
    });
  }

  Query getFirebaseFilteredQuery(
      ReminderModelRequest? request, String? userId) {
    Query query = _remindersReference;

    if (userId == _anonymous) {
      userId = null;
    }

    if (request?.filterByDueDateRange != null) {
      final startAtTimestamp = Timestamp.fromMillisecondsSinceEpoch(
          request!.filterByDueDateRange!.from.millisecondsSinceEpoch);
      final endAtTimestamp = Timestamp.fromMillisecondsSinceEpoch(
          request.filterByDueDateRange!.to.millisecondsSinceEpoch);
      query = query.where(
        _dueDate,
        isGreaterThanOrEqualTo: startAtTimestamp,
      );

      query = query.where(
        _dueDate,
        isLessThanOrEqualTo: endAtTimestamp,
      );
    }

    if (userId != null) {
      query = query.where(_authorId, isEqualTo: userId);
    } else {
      query = query.where(_authorId, isNull: true);
    }

    if (request?.complete != null) {
      query = query.where(_complete, isEqualTo: request?.complete);
    }

    if (request?.sort == ReminderModelRequestSort.dueDateDesc) {
      query = query.orderBy(_dueDate, descending: false);
    }
    return query;
  }

  Future<void> updateCountersInDataSource({
    required int completeCount,
    required int incompleteCount,
  }) async {
    await _updateCompleteCounter(completeCount);
    await _updateIncompleteCounter(incompleteCount);
  }

  Future<bool> logIn(bool anonymous) async {
    if (anonymous) {
      _loggedInUid = _anonymous;
      await _storage.write(key: _authorId, value: _loggedInUid);
      await _createDefaultCollectionsForTheUser();
      return true;
    } else {
      var result = await _loginWithFacebook();
      // If the user logs in for the first time, create a document for him with
      // generated collections of reminders and counters
      await _createDefaultCollectionsForTheUser();
      return result;
    }
  }

  Future<void> _createDefaultCollectionsForTheUser() async {
    Query query = _remindersReference;
    var user = await _getAuthorIdOrNull();
    Query<Object?>? querySnapshot;
    querySnapshot =
        _generateQuerySnapshotForLoggedInUser(user, querySnapshot, query);
    final snap = await querySnapshot.get();
    var remindersLength = snap.docs.length;
    if (remindersLength == 0) {
      await _generateAndInsertDataForTheUser();
    }
  }

  Query<Object?> _generateQuerySnapshotForLoggedInUser(
    String? userId,
    Query<Object?>? querySnapshot,
    Query<Object?> query,
  ) {
    if (userId != null) {
      //User is logged in
      querySnapshot = query.where(_authorId, isEqualTo: userId).limit(1);
    } else {
      querySnapshot = query.where(_authorId, isNull: true).limit(1);
    }
    return querySnapshot;
  }

  Future<void> _generateAndInsertDataForTheUser() async {
    _data = List.generate(
      10,
      (index) => ReminderModel.withAuthorId(index, _loggedInUid),
    );

    // Insert new data to the reminders collection
    final reminders = _data;
    for (var reminder in reminders) {
      await _remindersReference.add(reminder.toJson());
    }

    await _createUserCountersCollection();
    await _createUserRemindersCollectionCounter();
  }
}

extension FireBaseCollection on List<QueryDocumentSnapshot<Object?>> {
  List<ReminderModel> asReminderList() => map(
        (docs) => ReminderModel.fromJson(
            docs.data() as Map<String, dynamic>, docs.id),
      ).toList();
}
