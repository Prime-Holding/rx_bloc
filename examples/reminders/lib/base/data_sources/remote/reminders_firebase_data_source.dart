import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
// import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:rx_bloc_list/models.dart';

import '../../models/reminder/reminder_list_response.dart';
import '../../models/reminder/reminder_model.dart';
import '../../models/reminder/reminder_model_firebase_request_date.dart';
import 'reminders_data_source.dart';

class RemindersFirebaseDataSource implements RemindersDataSource {
  RemindersFirebaseDataSource() {
    // usersReference = fireStore.collection(_users);
    print('RemindersFirebaseDataSource del');
    remindersReference = fireStore.collection(_reminders);
    countersReference = fireStore.collection(_counters);
    remindersLengthsReference = fireStore.collection(_remindersLengths);
    // storage = const FlutterSecureStorage();
  }

  final fireStore = FirebaseFirestore.instance;
  late CollectionReference remindersReference;
  /// Stores the authorId and the complete and incomplete counters
  late CollectionReference countersReference;
  /// Stores the authorId and the length of the user's collection
  late CollectionReference remindersLengthsReference;
///todo the 3 collections - counters and reminders,remindersLength
  /// are properly created when new users are created.
  /// and check how they will be working with the
  /// id of the Identifiable in the app
  // late CollectionReference usersReference;
  late String loggedInUid;

  // late FlutterSecureStorage storage;
  static var storage = const FlutterSecureStorage();

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
  var _accessToken = '';

  @override
  Future<ReminderModel> create({
    required String title,
    required DateTime dueDate,
    required bool complete,
  }) async {
    var userId = await storage.read(key: _authorId);
    if(userId != null) {
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
    }else{
      //todo change this id
      var reminder =  ReminderModel(
          id: 'NotLogged',
          title: title,
          dueDate: dueDate,
          complete: complete,
          );
      return reminder;
    }
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
    if(userId != null){
      ///USER is logged
      Query query = remindersLengthsReference;
      var querySnapshot =
      query.where('authorId', isEqualTo: userId).limit(1);
      final remindersLengthSnapshot = await querySnapshot.get();
      var remindersLength = remindersLengthSnapshot.docs.first[_length];
      return remindersLength;
    }
    /// todo fetch for not logged user

    // var currentLengthSnapshot =
    //     await countersReference.doc(_remindersLengths).get();
    ///todo make a query to fetch with a where clause where the id == uid
    // var counterDocument = currentLengthSnapshot.data() as Map<String, dynamic>;
    // return counterDocument[_length];]
    return 10;
  }

  @override
  Future<ReminderListResponse> getAll(ReminderModelRequest? request) async {
    // Get the userId from local storage
    var userId  = await storage.read(key: _authorId);
    //  Generate a query
    var querySnapshot =  getFirebaseFilteredQuery(request, userId);

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
    if(userId != null){
      ///USER is logged
      Query query = countersReference;
      var querySnapshot =
      query.where('authorId', isEqualTo: userId).limit(1);
      final countersSnapshot = await querySnapshot.get();
      var counterIncompleteLength = countersSnapshot.docs.first[_complete];
      return counterIncompleteLength;
    }
    /// todo fetch for not logged user
    // var counterDocumentSnapshot =
    //     await countersReference.doc(_countersDocument).get();
    // var counterDocument =
    //     counterDocumentSnapshot.data() as Map<String, dynamic>;
    // var completeCount = counterDocument[_complete];
    // return completeCount;
    return -3;
  }

  @override
  Future<int> getIncompleteCount() async {
    ///if the user is logged in get his data if not get the default collection
    ///values
    var userId = await storage.read(key: _authorId);
    if(userId != null){
      // The user is logged
      Query query = countersReference;
          var querySnapshot =
              query.where('authorId', isEqualTo: userId).limit(1);
          final countersSnapshot = await querySnapshot.get();
          var counterIncompleteLength = countersSnapshot.docs.first[_incomplete];
      return counterIncompleteLength;
    }
    /// todo fetch for not logged user
    // var counterDocumentSnapshot =
    //     await countersReference.doc(_countersDocument).get();
    // var counterDocument =
    //     counterDocumentSnapshot.data() as Map<String, dynamic>;
    // var incompleteCount = counterDocument[_incomplete];
    // return incompleteCount;
    return -5;
  }

  Future<bool> _loginWithFacebook() async {
    try {
      // Trigger the sign-in flow
      final facebookLoginResult = await FacebookAuth.instance.login();
      // Create a credential from the access token
      final facebookAuthCredential = FacebookAuthProvider.credential(
          facebookLoginResult.accessToken!.token);
      _accessToken = facebookLoginResult.accessToken!.token;
      // save token in local storage
      // await storage.write(key: 'token', value: _accessToken);
      // to get token from local storage
      // var value = await storage.read(key: _authorId);

      final data = await FirebaseAuth.instance
          .signInWithCredential(facebookAuthCredential);
      loggedInUid = data.user!.uid;
      // save token in local storage
      await storage.write(key: _authorId, value: loggedInUid);
      // print('loggedInUid $loggedInUid');
      return true;
    } on FirebaseAuthException catch (e) {
      print('ERROR LOGIN');
      return false;
    }
  }

  /// Generates a list of reminders, deletes the existing reminder documents in
  /// the reminders collection and uploads the newly generated collection.
  /// Call the seed() method when the list in Firebase is empty or should be
  /// reset. The method can be called in the getCompleteCount() method.
  Future<void> seed() async {
    _data = List.generate(
      100,
      (index) => ReminderModel.withAuthorId(index, loggedInUid),
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
     await countersReference.add({
      _authorId: loggedInUid,
      _incomplete: 100,
      _complete: 0,
    });
  }

  Future<void> _createUserRemindersCollectionCounter() async{
     await remindersLengthsReference.add({
      _authorId: loggedInUid,
      _length: 100,
    });
    // print('AFTER_RemindersLengthDocumentWrite');
  }

  Future<void> _updateIncompleteCounter(int incomplete) async {
    // todo if user is updated update for him, otherwise for the default user

    var userId = await storage.read(key: _authorId);
    if(userId != null){
      ///USER is logged todo change this to updating
      Query query = countersReference;
      var querySnapshot =
      query.where('authorId', isEqualTo: userId).limit(1);
      final countersSnapshot = await querySnapshot.get();
      var counterId = countersSnapshot.docs.first.id;
      await countersReference.doc(counterId).update({
        // _incomplete: incomplete,
        _incomplete: incomplete,
      });
    }

    /// todo change this _countersDocument
    // await countersReference
    //     .doc(_countersDocument)
    //     .update({_incomplete: incomplete});
  }

  Future<void> _updateCompleteCounter(int complete) async {
    // todo if user is updated update for him, otherwise for the default user
    var userId = await storage.read(key: _authorId);
    if(userId != null){
      // user is logged
      Query query = countersReference;
      var querySnapshot =
      query.where('authorId', isEqualTo: userId).limit(1);
      final countersSnapshot = await querySnapshot.get();
      var counterId = countersSnapshot.docs.first.id;
      await countersReference.doc(counterId).update({
        // _incomplete: incomplete,
        _complete: complete,
      });
    }
    // tod oadd option for unlogged
    // await countersReference
    //     .doc(_countersDocument)
    //     .update({_complete: complete});
  }

  Future<void> _updateRemindersCollectionLengthCounter(int collectionCount) async {
    var userId = await storage.read(key: _authorId);
    if(userId != null){
      ///USER is logged
      Query query = remindersLengthsReference;
      var querySnapshot =
      query.where('authorId', isEqualTo: userId).limit(1);
      final lengthSnapshot = await querySnapshot.get();
      var lengthId = lengthSnapshot.docs.first.id;
      await remindersLengthsReference.doc(lengthId).update({
        // _incomplete: incomplete,
        _length: collectionCount,
      });
    }

  }

  Query getFirebaseFilteredQuery(
      ReminderModelRequest? request, String? userId)  {
    if (_accessToken != '') {
      print('remindersReference initialized');
    }

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

    if(userId != null) {
      query = query.where(_authorId, isEqualTo: userId);
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

  Future<bool> logIn() async {
    var result = await _loginWithFacebook();
    //If the user logs in for the first time, create a document for him with
    // generated collections of reminders and counters
    await _createDefaultCollectionsForTheUser();
    return result;
  }

  Future<void> _createDefaultCollectionsForTheUser() async {
    //check if there a document with the id of the logged in user in the
    //reminders collection
    Query query = remindersReference;
    // print('loggedInUid:$loggedInUid');
    var querySnapshot =
        query.where('authorId', isEqualTo: loggedInUid).limit(1);
    final snap = await querySnapshot.get();
    var remindersLength = snap.docs.length;
//     var userDataSnapshot = await usersReference.doc(loggedInUid).get();
    ///todo check if there is a valid token saved in the secure storage
    //   var token = await storage.read(key: 'token');
    // if there is a reminder with authorId == the user id
    // var exists = remindersLength > 0;
    // print('Exists $exists');
    if (remindersLength == 0) {
      // The user does not have any data
      // Generate a list of reminders and assign it to the user
      await _generateAndInsertDataForTheUser();
    }
  }

  Future<void> _generateAndInsertDataForTheUser() async {
    ///todo change to 100
    _data = List.generate(
      5,
      (index) => ReminderModel.withAuthorId(index, loggedInUid),
    );

    // Insert new data to the reminders collection
    final reminders = _data;
    for (var reminder in reminders) {
       await remindersReference.add(reminder.toJson());
    }

    // Set the counters values
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
