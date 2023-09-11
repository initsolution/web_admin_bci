import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_web_ptb/constants/constants.dart';
import 'package:flutter_web_ptb/constants/values.dart';
import 'package:flutter_web_ptb/model/task.dart';
import 'package:flutter_web_ptb/providers/task_state.dart';
import 'package:flutter_web_ptb/repository/task_repo.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';

String typeTask = 'Regular';
final typeTaskProvider = StateProvider<String>((ref) => typeTask);

final taskNotifierProvider = NotifierProvider<TaskNotifier, TaskState>(
  () {
    return TaskNotifier(taskRepo: TaskRepo(Dio()));
  },
);

class TaskNotifier extends Notifier<TaskState> {
  final TaskRepo taskRepo;

  TaskNotifier({required this.taskRepo});

  @override
  TaskState build() {
    return TaskInitial();
  }

  getAllTask() async {
    state = TaskLoading();
    Map<String, dynamic> header = {};
    final sharedPref = await SharedPreferences.getInstance();
    try {
      var token = sharedPref.getString(StorageKeys.token) ?? '';
      final HttpResponse data =
          await taskRepo.getAllTask('Bearer $token', header);
      if (data.response.statusCode == 200) {
        // debugPrint('data emp : ${httpResponse.data}');
        List<Task> tasks =
            (data.data as List).map((e) => Task.fromJson(e)).toList();
        if (tasks.isEmpty) {
          state = TaskLoadedEmpty();
        } else {
          state = TaskLoaded(tasks: tasks);
        }
      }
    } on DioException catch (error) {
      // debugPrint(error.response!.statusCode.toString());
      if (error.response!.statusCode == 401) {
        state = TaskErrorServer(
            message: error.response!.statusMessage,
            statusCode: error.response!.statusCode);
      }
    }
  }

  createTask(Task task) async {
    state = TaskLoading();
    final sharedPref = await SharedPreferences.getInstance();
    var token = sharedPref.getString(StorageKeys.token) ?? '';
    final httpResponse = await taskRepo.createTask(task, 'Bearer $token');
    if (DEBUG) debugPrint(httpResponse.data.toString());
    if (httpResponse.response.statusCode == 201) {
      state = TaskDataChangeSuccess();
    }
  }
}