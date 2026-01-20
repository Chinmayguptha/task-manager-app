import 'dart:async';
import 'dart:convert';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/task_model.dart';
import '../../domain/entities/task_entity.dart';

abstract class LocalTaskDataSource {
  Future<void> createTask(TaskEntity task);
  Future<void> updateTask(TaskEntity task);
  Future<void> deleteTask(String taskId);
  Stream<List<TaskModel>> getTasks(String userId);
  Future<void> toggleTaskCompletion(String taskId, bool isCompleted);
}

class LocalTaskDataSourceImpl implements LocalTaskDataSource {
  final Box<String> taskBox;
  final StreamController<List<TaskModel>> _tasksController = StreamController<List<TaskModel>>.broadcast();

  LocalTaskDataSourceImpl(this.taskBox);

  @override
  Future<void> createTask(TaskEntity task) async {
    try {
      final taskModel = TaskModel(
        id: task.id,
        userId: task.userId,
        title: task.title,
        description: task.description,
        dueDate: task.dueDate,
        priority: task.priority,
        isCompleted: task.isCompleted,
        createdAt: task.createdAt,
      );
      
      await taskBox.put(task.id, jsonEncode(taskModel.toJson()));
      _notifyListeners(task.userId);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> updateTask(TaskEntity task) async {
    try {
      final taskModel = TaskModel(
        id: task.id,
        userId: task.userId,
        title: task.title,
        description: task.description,
        dueDate: task.dueDate,
        priority: task.priority,
        isCompleted: task.isCompleted,
        createdAt: task.createdAt,
      );
      
      await taskBox.put(task.id, jsonEncode(taskModel.toJson()));
      _notifyListeners(task.userId);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> deleteTask(String taskId) async {
    try {
      final taskJson = taskBox.get(taskId);
      if (taskJson != null) {
        final task = TaskModel.fromJson(jsonDecode(taskJson));
        await taskBox.delete(taskId);
        _notifyListeners(task.userId);
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Stream<List<TaskModel>> getTasks(String userId) {
    _notifyListeners(userId);
    return _tasksController.stream;
  }

  @override
  Future<void> toggleTaskCompletion(String taskId, bool isCompleted) async {
    try {
      final taskJson = taskBox.get(taskId);
      if (taskJson != null) {
        final task = TaskModel.fromJson(jsonDecode(taskJson));
        final updatedTask = task.copyWith(isCompleted: isCompleted);
        await taskBox.put(taskId, jsonEncode(updatedTask.toJson()));
        _notifyListeners(task.userId);
      }
    } catch (e) {
      rethrow;
    }
  }

  void _notifyListeners(String userId) {
    final tasks = taskBox.values
        .map((json) => TaskModel.fromJson(jsonDecode(json)))
        .where((task) => task.userId == userId)
        .toList();
    _tasksController.add(tasks);
  }

  void dispose() {
    _tasksController.close();
  }
}
