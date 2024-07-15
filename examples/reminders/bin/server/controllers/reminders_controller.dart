// Copyright (c) 2023, Prime Holding JSC
// https://www.primeholding.com
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'package:shelf/shelf.dart';

import '../models/reminder_model.dart';
import '../services/reminders_service.dart';
import '../utils/api_controller.dart';
import '../utils/server_exceptions.dart';

class RemindersController extends ApiController {
  RemindersController(this.remindersService);

  final RemindersService remindersService;
  List<ReminderModel> reminders = [];

  @override
  void registerRequests(WrappedRouter router) {
    router.addRequest(
      RequestType.GET,
      '/api/reminders/complete',
      getRemindersCompleteHandler,
    );
    router.addRequest(
      RequestType.GET,
      '/api/reminders/incomplete',
      getRemindersIncompleteHandler,
    );
    router.addRequest(
      RequestType.POST,
      '/api/reminders/all',
      getAllRemindersHandler,
    );
    router.addRequest(
      RequestType.POST,
      '/api/reminders/dashboard',
      getAllDashboardRemindersHandler,
    );
    router.addRequest(
      RequestType.POST,
      '/api/reminders',
      addReminderHandler,
    );
    router.addRequest(
      RequestType.DELETE,
      '/api/reminders',
      deleteReminderHandler,
    );
    router.addRequest(
      RequestType.PATCH,
      '/api/reminders',
      updateReminderHandler,
    );
  }

  Future<Response> getRemindersCompleteHandler(Request request) async {
    final completeCount = remindersService.getCompleteCount();
    return Response.ok(completeCount.toString(),
        headers: {'Content-Type': 'text/plain'});
  }

  Future<Response> getRemindersIncompleteHandler(Request request) async {
    final incompleteCount = remindersService.getIncompleteCount();
    return Response.ok(incompleteCount.toString(),
        headers: {'Content-Type': 'text/plain'});
  }

  Future<Response> getAllDashboardRemindersHandler(Request request) async {
    final params = await request.bodyFromFormData();
    final reminders = remindersService.getAllDashboardReminders(params);
    return responseBuilder.buildOK(data: reminders.toJson());
  }

  Future<Response> getAllRemindersHandler(Request request) async {
    final params = await request.bodyFromFormData();
    final reminders = remindersService.getAllReminders(params);
    return responseBuilder.buildOK(data: reminders.toJson());
  }

  Future<Response> addReminderHandler(Request request) async {
    final queryParams = request.requestedUri.queryParameters;

    final title = queryParams['title'] ?? 'Empty';
    final dueDate = DateTime.parse(queryParams['dueDate'] ?? '');
    final complete = queryParams['complete'] == 'true';

    final reminder = remindersService.createReminder(title, dueDate, complete);

    return responseBuilder.buildOK(data: reminder.toJson());
  }

  Future<Response> deleteReminderHandler(Request request) async {
    final params = await request.bodyFromFormData();

    throwIfEmpty(params['id'], BadRequestException('id is required'));

    remindersService.deleteReminder(params['id']);

    return responseBuilder.buildOK();
  }

  Future<Response> updateReminderHandler(Request request) async {
    final params = await request.bodyFromFormData();
    final updatedReminder =
        remindersService.updateReminder(int.parse(params['id']), params);
    return responseBuilder.buildOK(data: updatedReminder.toJson());
  }
}
