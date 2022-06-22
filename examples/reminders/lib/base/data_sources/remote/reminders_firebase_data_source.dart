import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rx_bloc_list/models.dart';

import '../../models/reminder/reminder_list_reponse.dart';
import '../../models/reminder/reminder_model.dart';
import 'reminders_data_source.dart';

class RemindersFirebaseDataSource implements RemindersDataSource {
  RemindersFirebaseDataSource() {
    remindersReference = fireStore.collection(_reminders);
    countersReference = fireStore.collection(_counters);
  }

  final fireStore = FirebaseFirestore.instance;
  late CollectionReference remindersReference;
  late CollectionReference countersReference;

  var remindersCollectionLength = 0;
  QueryDocumentSnapshot? lastFetchedRecord;
  static const _reminders = 'reminders';
  static const _counters = 'counters';
  static const _countersDocument = 'countersDocument';
  static const _remindersDocumentsLength = 'remindersDocumentsLength';
  static const _complete = 'complete';
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
    final reminderModelRequestData = ReminderModelRequestData(
      dueDate: dueDate,
      title: title,
      complete: complete,
    );

    final createdReminder =
        await remindersReference.add(reminderModelRequestData.toJson());
    final createdReminderId = createdReminder.id;
    final reminder = ReminderModel(
        id: createdReminderId,
        title: title,
        dueDate: dueDate,
        complete: complete);

    var completeCount = await _getRemindersCollectionLength();
    completeCount++;
    await _updateRemindersCollectionCounter(completeCount);

    return reminder;
  }

  @override
  Future<void> delete(String id) async {
    await remindersReference.doc(id).delete();

    var completeCount = await _getRemindersCollectionLength();
    completeCount--;

    await _updateRemindersCollectionCounter(completeCount);
  }

  Future<int> _getRemindersCollectionLength() async {
    var currentLengthSnapshot =
        await countersReference.doc(_remindersDocumentsLength).get();
    var counterDocument = currentLengthSnapshot.data() as Map<String, dynamic>;
    return counterDocument[_length];
  }

  @override
  Future<ReminderListResponse> getAll(ReminderModelRequest? request) async {
    //  Generate a query
    var querySnapshot = getFirebaseFilteredQuery(request);

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
    var counterDocumentSnapshot =
        await countersReference.doc(_countersDocument).get();
    var counterDocument =
        counterDocumentSnapshot.data() as Map<String, dynamic>;
    var completeCount = counterDocument[_complete];
    return completeCount;
  }

  @override
  Future<int> getIncompleteCount() async {
    var counterDocumentSnapshot =
        await countersReference.doc(_countersDocument).get();
    var counterDocument =
        counterDocumentSnapshot.data() as Map<String, dynamic>;
    var incompleteCount = counterDocument[_incomplete];
    return incompleteCount;
  }

  /// Generates a list of reminders, deletes the existing reminder documents in
  /// the reminders collection and uploads the new collection
  /// Call the seed when the list in Firebase is empty or should be refilled
  Future<void> seed() async {
    _data = List.generate(
      100,
      (index) => ReminderModel.fromIndex(index),
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
    await _updateRemindersCollectionCounter(100);
  }

  @override
  Future<IdentifiablePair<ReminderModel>> update(
      ReminderModel updatedModel) async {
    // Fetch the reminder model before its updating for comparison
    var oldReminderSnapshot =
        await remindersReference.doc(updatedModel.id).get();

    await remindersReference.doc(updatedModel.id).update({
      _complete: updatedModel.complete,
      _dueDate: updatedModel.dueDate,
      _title: updatedModel.title,
    });

    var oldReminder = oldReminderSnapshot.data() as Map<String, dynamic>;

    var oldReminderModel = ReminderModel(
        id: updatedModel.id,
        title: oldReminder[_title],
        dueDate: oldReminder[_dueDate].toDate(),
        complete: oldReminder[_complete]);
    return IdentifiablePair(
      updatedIdentifiable: updatedModel,
      oldIdentifiable: oldReminderModel,
    );
  }

  Future<void> _updateIncompleteCounter(int incomplete) async {
    await countersReference
        .doc(_countersDocument)
        .update({_incomplete: incomplete});
  }

  Future<void> _updateCompleteCounter(int complete) async {
    await countersReference
        .doc(_countersDocument)
        .update({_complete: complete});
  }

  Future<void> _updateRemindersCollectionCounter(int collectionCount) async {
    await countersReference
        .doc(_remindersDocumentsLength)
        .update({_length: collectionCount});
  }

  Query getFirebaseFilteredQuery(ReminderModelRequest? request) {
    Query query = remindersReference;

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

    if (request?.sort == ReminderModelRequestSort.dueDateDesc) {
      query = query.orderBy(_dueDate, descending: false);
    }
    return query;
  }

  @override
  Future<void> updateCountersInDataSource({
    required int completeCount,
    required int incompleteCount,
  }) async {
    await _updateCompleteCounter(completeCount);
    await _updateIncompleteCounter(incompleteCount);
  }
}

extension FireBaseCollection on List<QueryDocumentSnapshot<Object?>> {
  List<ReminderModel> asReminderList() => map(
        (docs) => ReminderModel.fromJson(
            docs.data() as Map<String, dynamic>, docs.id),
      ).toList();
}
