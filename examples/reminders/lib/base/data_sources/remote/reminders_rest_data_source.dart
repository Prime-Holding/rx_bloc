import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../../models/reminder/reminder_list_response.dart';
import '../../models/reminder/reminder_model.dart';
import 'reminders_data_source.dart';

part 'reminders_rest_data_source.g.dart';

@RestApi()
abstract class RemindersRestDataSource implements RemindersDataSource {
  factory RemindersRestDataSource(Dio dio, {String baseUrl}) =
      _RemindersRestDataSource;

  @override
  @GET('/api/reminders/complete')
  Future<String> getCompleteCount();

  @override
  @GET('/api/reminders/incomplete')
  Future<String> getIncompleteCount();

  @override
  @POST('/api/reminders/all')
  Future<ReminderListResponse> getAll(@Body() ReminderModelRequest? request);

  @override
  @POST('/api/reminders/dashboard')
  Future<ReminderListResponse> getAllDashboard(
      @Body() ReminderModelRequest? request);

  @override
  @POST('/api/reminders')
  Future<ReminderModel> create({
    @Query('title') required String title,
    @Query('dueDate') required DateTime dueDate,
    @Query('complete') required bool complete,
  });

  @override
  @DELETE('/api/reminders')
  Future<void> delete(@Body() String id);

  @override
  @PATCH('/api/reminders')
  Future<ReminderPair> update(@Body() ReminderModel updatedModel);
}
