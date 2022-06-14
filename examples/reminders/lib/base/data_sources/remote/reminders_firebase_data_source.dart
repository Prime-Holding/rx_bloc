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
      id: remindersReference.doc().id,
      title: title,
      complete: complete,
    );
    await remindersReference.add(reminder.toJson());

    return reminder;
  }

  @override
  Future<void> delete(String id) async {
    await remindersReference.doc(id).delete();
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
      final length = await remindersReference.get();
      //Temporary call the get method to have the total numbers in order to
      //provide the collection length to the paginated list so that the
      //pagination works, in future use a firebase function to get the count
      remindersCollectionLength = length.size;
    }

    return ReminderListResponse(
      items: reminders,
      totalCount: remindersCollectionLength,
    );
  }

  @override
  Future<int> getCompleteCount() async {
    return -1;
  }

  @override
  Future<int> getIncompleteCount() async {
    return -2;
  }

  /// Generates a list of reminders, deletes the existing reminder documents in
  /// the reminders collection and uploads the new collection
  /// Call the seed when the list in Firebase is empty or should be refilled
  Future<void> seed() async {
    _data = List.generate(
      100,
      (index) => ReminderModel.fromIndex(index),
    );

    final deleteBatch = FirebaseFirestore.instance.batch();

    final deleteSnapshotReminders = await remindersReference.get();
    for (var document in deleteSnapshotReminders.docs) {
      deleteBatch.delete(document.reference);
    }
    await deleteBatch.commit();
    final insertBatch = FirebaseFirestore.instance.batch();
    final reminders = _data;

    for (var reminder in reminders) {
      final docRef = remindersReference.doc(reminder.id);
      insertBatch.set(docRef, reminder.toJson());
    }

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
