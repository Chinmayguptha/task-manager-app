import '../../domain/entities/task_entity.dart';
import '../../domain/repositories/task_repository.dart';
import '../datasources/local_task_datasource.dart';

class TaskRepositoryImpl implements TaskRepository {
  final LocalTaskDataSource dataSource;

  TaskRepositoryImpl(this.dataSource);

  @override
  Future<void> createTask(TaskEntity task) async {
    await dataSource.createTask(task);
  }

  @override
  Future<void> updateTask(TaskEntity task) async {
    await dataSource.updateTask(task);
  }

  @override
  Future<void> deleteTask(String taskId) async {
    await dataSource.deleteTask(taskId);
  }

  @override
  Stream<List<TaskEntity>> getTasks(String userId) {
    return dataSource.getTasks(userId);
  }

  @override
  Future<void> toggleTaskCompletion(String taskId, bool isCompleted) async {
    await dataSource.toggleTaskCompletion(taskId, isCompleted);
  }
}
