import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rx_bloc_list/models.dart';

import '../../models/reminder/reminder_list_reponse.dart';
import '../../models/reminder/reminder_model.dart';
import 'reminders_data_source.dart';

class RemindersFirebaseDataSource implements RemindersDataSource {
  RemindersFirebaseDataSource() {
    remindersReference = fireStore.collection('reminders');
  }

  final fireStore = FirebaseFirestore.instance;
  late CollectionReference remindersReference;

  ///todo remove it from here
  int remindersCollectionLength = 0;
  QueryDocumentSnapshot? lastFetchedRecord;

  late final List<ReminderModel> _data;

  @override
  Future<ReminderModel> create(
      {required String title,
      required DateTime dueDate,
      required bool complete}) async {
    var reminder = ReminderModel(
      dueDate: dueDate,
      id: '-1',
      title: title,
      complete: complete,
    );

    var createdReminder = await remindersReference.add(reminder.toJson());
    var createdReminderId = createdReminder.id;
    reminder = reminder.copyWith(id: createdReminderId);

    await remindersReference.doc(createdReminderId).update(reminder.toJson());
    return reminder;
  }

  @override
  Future<void> delete(String id) async {
    await remindersReference.doc(id).delete();
  }

  /// create a method to fetch the result for the dashboard page
  /// create a query for all reminders and filter the ones, which are completed
  /// and the ones which are from and to the given dates
  @override
  Future<ReminderListResponse> getAll(ReminderModelRequest? request) async {
    ///todo remove it from here
    // await seed();

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

    if (remindersCollectionLength == 0) {
      final length = await remindersReference.get();

      ///temporary call the get method to have the total numbers in order to
      ///provide the collection length to the paginated list to work the pagination;
      ///in future use a firebase function to get the count
      remindersCollectionLength = length.size;
    }

    return ReminderListResponse(
      items: reminders,
      totalCount: remindersCollectionLength,
    );
  }

  @override
  Future<int> getCompleteCount() async {
    await Future.delayed(const Duration(milliseconds: 200));
    // await seed();
    // return _data.where((element) => element.complete).length;
    return 12;
  }

  @override
  Future<int> getIncompleteCount() async {
    await Future.delayed(const Duration(milliseconds: 200));
    // return _data.where((element) => !element.complete).length;
    return 14;
  }

  /// Call seed when the list in Firebase is empty or should be refilled
  @override
  Future<void> seed() async {
    _data = List.generate(
      100,
      (index) => ReminderModel.fromIndex(index),
    );

    /// First delete all reminders in the collection
    final deleteBatch = FirebaseFirestore.instance.batch();
    // Delete all existing data
    final deleteSnapshotReminders = await remindersReference.get();
    deleteSnapshotReminders.docs.forEach((document) {
      deleteBatch.delete(document.reference);
    });

    // Commit batch
    await deleteBatch.commit();

    /// Generate a new collection
    final insertBatch = FirebaseFirestore.instance.batch();

    final reminders = _data;

    reminders.forEach((reminder) {
      final docRef = remindersReference.doc(reminder.id);
      insertBatch.set(docRef, reminder.toJson());
    });

    await insertBatch.commit();
  }

  @override
  Future<IdentifiablePair<ReminderModel>> update(
      ReminderModel updatedModel) async {
    await remindersReference.doc(updatedModel.id).update({
      'complete': updatedModel.complete,
      'dueDate': updatedModel.dueDate,
      'title': updatedModel.title,
    });

    return IdentifiablePair(
      updatedIdentifiable: updatedModel,
    );
  }

  Query getFirebaseFilteredQuery(ReminderModelRequest? request) {
    Query query = remindersReference;

    if (request?.filterByDueDateRange != null) {
      final startAtTimestamp = Timestamp.fromMillisecondsSinceEpoch(
          request!.filterByDueDateRange!.from.millisecondsSinceEpoch);
      final endAtTimestamp = Timestamp.fromMillisecondsSinceEpoch(
          request.filterByDueDateRange!.to.millisecondsSinceEpoch);
      query = query.where(
        'dueDate',
        isGreaterThanOrEqualTo: startAtTimestamp,
      );

      query = query.where(
        'dueDate',
        isLessThanOrEqualTo: endAtTimestamp,
      );
    }

    if (request?.sort == ReminderModelRequestSort.dueDateDesc) {
      query = query.orderBy('dueDate', descending: false);
    }
    return query;
  }
}

extension FireBaseCollection on List<QueryDocumentSnapshot<Object?>> {
  List<ReminderModel> asReminderList() => map(
        (docs) => ReminderModel.fromJson(docs.data() as Map<String, dynamic>),
      ).toList();
}
