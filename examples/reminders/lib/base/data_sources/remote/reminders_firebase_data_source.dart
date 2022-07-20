import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:rx_bloc_list/models.dart';

import '../../models/reminder/reminder_list_response.dart';
import '../../models/reminder/reminder_model.dart';
import '../../models/reminder/reminder_model_firebase_request_date.dart';
import 'reminders_data_source.dart';

class RemindersFirebaseDataSource implements RemindersDataSource {
  RemindersFirebaseDataSource() {
    remindersReference = fireStore.collection(_reminders);
    countersReference = fireStore.collection(_counters);
    remindersLengthsReference = fireStore.collection(_remindersLengths);
  }

  final fireStore = FirebaseFirestore.instance;
  late CollectionReference remindersReference;

  /// Stores the authorId and the complete and incomplete counters
  late CollectionReference countersReference;

  /// Stores the authorId and the length of the user's collection
  late CollectionReference remindersLengthsReference;
  late String? _loggedInUid;
  static var storage = const FlutterSecureStorage();

  final _auth = FirebaseAuth.instance;

  Stream<User?> get currentUser => _auth.authStateChanges();
  final _facebookLogin = FacebookAuth.instance;
  late UserCredential? _userCredential;

  var remindersCollectionLength = 0;
  QueryDocumentSnapshot? lastFetchedRecord;
  static const _reminders = 'reminders';
  static const _counters = 'counters';
  static const _remindersLengths = 'remindersLengths';
  static const _complete = 'complete';
  static const _authorId = 'authorId';

  static const _length = 'length';
  static const _incomplete = 'incomplete';
  static const _dueDate = 'dueDate';
  static const _title = 'title';
  late final List<ReminderModel> _data;

  @override
  Future<ReminderModel> create({
    required String title,
    required DateTime dueDate,
    required bool complete,
  }) async {
    var userId = await storage.read(key: _authorId);
    final reminderModelRequestData = ReminderModelFirebaseRequestData(
      dueDate: Timestamp.fromDate(dueDate),
      title: title,
      complete: complete,
      authorId: userId,
    );

    final createdReminder =
        await remindersReference.add(reminderModelRequestData.toJson());
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
    await remindersReference.doc(id).delete();

    var remindersCollectionLength = await _getRemindersCollectionLength();
    remindersCollectionLength--;

    await _updateRemindersCollectionLengthCounter(remindersCollectionLength);
  }

  Future<int> _getRemindersCollectionLength() async {
    var userId = await storage.read(key: _authorId);
    Query query = remindersLengthsReference;
    Query<Object?>? querySnapshot;
    querySnapshot =
        _generateQuerySnapshotForLoggedInUser(userId, querySnapshot, query);
    final remindersLengthSnapshot = await querySnapshot.get();
    var remindersLength = remindersLengthSnapshot.docs.first[_length];
    return remindersLength;
  }

  @override
  Future<ReminderListResponse> getAll(ReminderModelRequest? request) async {
    // Get the userId from local storage
    var userId = await storage.read(key: _authorId);
    //  Generate a query
    var querySnapshot = getFirebaseFilteredQuery(request, userId);

    // Modify the query
    if (lastFetchedRecord != null && request?.page != 1) {
      querySnapshot = querySnapshot.startAfterDocument(lastFetchedRecord!);
    }
    querySnapshot = querySnapshot.limit(request!.pageSize);

    // Get the result of the query
    final snap = await querySnapshot.get();
    if (request.pageSize == 10) {
      lastFetchedRecord = snap.docs.last;
    }

    final reminders = snap.docs.asReminderList();

    if (request.page == 1) {
      remindersCollectionLength = await _getRemindersCollectionLength();
    }

    return ReminderListResponse(
      items: reminders,
      totalCount: remindersCollectionLength,
    );
  }

  @override
  Future<int> getCompleteCount() async {
    var userId = await storage.read(key: _authorId);
    Query query = countersReference;
    Query<Object?>? querySnapshot;
    querySnapshot =
        _generateQuerySnapshotForLoggedInUser(userId, querySnapshot, query);
    final countersSnapshot = await querySnapshot.get();
    var counterCompleteLength = countersSnapshot.docs.first[_complete];
    return counterCompleteLength;
  }

  @override
  Future<int> getIncompleteCount() async {
    var userId = await storage.read(key: _authorId);
    Query query = countersReference;
    Query<Object?>? querySnapshot;
    querySnapshot =
        _generateQuerySnapshotForLoggedInUser(userId, querySnapshot, query);
    final countersSnapshot = await querySnapshot.get();
    var counterIncompleteLength = countersSnapshot.docs.first[_incomplete];
    return counterIncompleteLength;
  }

  Future<bool> _loginWithFacebook() async {
    // Trigger the sign-in flow
    final facebookLoginResult = await _facebookLogin.login();
    // Create a credential from the access token
    final facebookAuthCredential =
        FacebookAuthProvider.credential(facebookLoginResult.accessToken!.token);
    _userCredential = await _auth.signInWithCredential(facebookAuthCredential);
    _loggedInUid = _userCredential?.user!.uid;
    await storage.write(key: _authorId, value: _loggedInUid);

    return true;
  }

  Future<void> logOut() async {
    await _facebookLogin.logOut();
    await _auth.signOut();

    _userCredential = null;
    await storage.write(key: _authorId, value: null);
  }

  /// Generates a list of reminders, deletes the existing reminder documents in
  /// the reminders collection and uploads the newly generated collection.
  /// Call the seed() method when the list in Firebase is empty or should be
  /// reset. The method can be called in the getCompleteCount() method.
  Future<void> seed() async {
    _data = List.generate(
      100,
      (index) => ReminderModel.withAuthorId(index, _loggedInUid),
    );

    // Delete previous data from the reminders collection
    final deleteBatch = FirebaseFirestore.instance.batch();
    final deleteSnapshotReminders = await remindersReference.get();
    for (var document in deleteSnapshotReminders.docs) {
      deleteBatch.delete(document.reference);
    }
    await deleteBatch.commit();

    // Insert new data to the reminders collection
    final insertBatch = FirebaseFirestore.instance.batch();
    final reminders = _data;
    for (var reminder in reminders) {
      final docRef = remindersReference.doc(reminder.id);
      insertBatch.set(docRef, reminder.toJson());
    }
    await insertBatch.commit();

    // Set the counters values
    await _updateIncompleteCounter(100);
    await _updateCompleteCounter(0);
    await _updateRemindersCollectionLengthCounter(100);
  }

  @override
  Future<IdentifiablePair<ReminderModel>> update(
      ReminderModel updatedModel) async {
    // Fetch the reminder model before its updating for comparison
    var oldReminderSnapshot =
        await remindersReference.doc(updatedModel.id).get();

    await remindersReference.doc(updatedModel.id).update({
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
    return IdentifiablePair(
      updatedIdentifiable: updatedModel,
      oldIdentifiable: oldReminderModel,
    );
  }

  Future<void> _createUserCountersCollection() async {
    // If user counter collection exits update it,
    // otherwise add a new one
    Query query = countersReference;
    var user = await storage.read(key: _authorId);
    Query<Object?>? querySnapshot;
    querySnapshot =
        _generateQuerySnapshotForLoggedInUser(user, querySnapshot, query);
    final countersSnapshot = await querySnapshot.get();
    var length = countersSnapshot.docs.length;
    if (length > 0) {
      // A logged in user reminders collection elements have been deleted
      // and the counters document should be updated
      var counterId = countersSnapshot.docs.first.id;
      await countersReference.doc(counterId).update({
        _authorId: _loggedInUid,
        _incomplete: 100,
        _complete: 0,
      });
    } else {
      await countersReference.add({
        _authorId: _loggedInUid,
        _incomplete: 100,
        _complete: 0,
      });
    }
  }

  Future<void> _createUserRemindersCollectionCounter() async {
    Query query = remindersLengthsReference;
    var user = await storage.read(key: _authorId);
    Query<Object?>? querySnapshot;
    querySnapshot =
        _generateQuerySnapshotForLoggedInUser(user, querySnapshot, query);
    final remindersLengthsSnapshot = await querySnapshot.get();
    var length = remindersLengthsSnapshot.docs.length;
    if (length > 0) {
      var remindersLengthId = remindersLengthsSnapshot.docs.first.id;
      await remindersLengthsReference.doc(remindersLengthId).update({
        _authorId: _loggedInUid,
        _length: 100,
      });
    } else {
      await remindersLengthsReference.add({
        _authorId: _loggedInUid,
        _length: 100,
      });
    }
  }

  Future<void> _updateIncompleteCounter(int incomplete) async {
    var userId = await storage.read(key: _authorId);
    Query query = countersReference;
    Query<Object?>? querySnapshot;
    querySnapshot =
        _generateQuerySnapshotForLoggedInUser(userId, querySnapshot, query);
    final countersSnapshot = await querySnapshot.get();
    var counterId = countersSnapshot.docs.first.id;
    await countersReference.doc(counterId).update({
      _incomplete: incomplete,
    });
  }

  Future<void> _updateCompleteCounter(int complete) async {
    var userId = await storage.read(key: _authorId);
    Query query = countersReference;
    Query<Object?>? querySnapshot;
    querySnapshot =
        _generateQuerySnapshotForLoggedInUser(userId, querySnapshot, query);
    final countersSnapshot = await querySnapshot.get();
    var counterId = countersSnapshot.docs.first.id;
    await countersReference.doc(counterId).update({
      _complete: complete,
    });
  }

  Future<void> _updateRemindersCollectionLengthCounter(
      int collectionCount) async {
    var userId = await storage.read(key: _authorId);
    Query query = remindersLengthsReference;
    Query<Object?>? querySnapshot;
    querySnapshot =
        _generateQuerySnapshotForLoggedInUser(userId, querySnapshot, query);
    final lengthSnapshot = await querySnapshot.get();
    var lengthId = lengthSnapshot.docs.first.id;
    await remindersLengthsReference.doc(lengthId).update({
      _length: collectionCount,
    });
  }

  Query getFirebaseFilteredQuery(
      ReminderModelRequest? request, String? userId) {
    // remindersReference = usersReference.doc(loggedInUid).collection(_reminders);
    // }
    Query query = remindersReference;

    /// TODO uncomment when the generated reminder collection is with length
    /// 100
    // if (request?.filterByDueDateRange != null) {
    //   final startAtTimestamp = Timestamp.fromMillisecondsSinceEpoch(
    //       request!.filterByDueDateRange!.from.millisecondsSinceEpoch);
    //   final endAtTimestamp = Timestamp.fromMillisecondsSinceEpoch(
    //       request.filterByDueDateRange!.to.millisecondsSinceEpoch);
    //   query = query.where(
    //     _dueDate,
    //     isGreaterThanOrEqualTo: startAtTimestamp,
    //   );
    //
    //   query = query.where(
    //     _dueDate,
    //     isLessThanOrEqualTo: endAtTimestamp,
    //   );
    // }

    if (userId != null) {
      query = query.where(_authorId, isEqualTo: userId);
    } else {
      query = query.where(_authorId, isNull: true);
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
      _loggedInUid = null;
      await storage.write(key: _authorId, value: _loggedInUid);
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
    Query query = remindersReference;
    var user = await storage.read(key: _authorId);
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
    ///todo change the number to 100
    _data = List.generate(
      3,
      (index) => ReminderModel.withAuthorId(index, _loggedInUid),
    );

    // Insert new data to the reminders collection
    final reminders = _data;
    for (var reminder in reminders) {
      await remindersReference.add(reminder.toJson());
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
