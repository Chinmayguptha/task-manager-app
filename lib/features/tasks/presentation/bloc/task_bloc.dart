import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../domain/entities/task_entity.dart';
import '../../domain/usecases/create_task_usecase.dart';
import '../../domain/usecases/update_task_usecase.dart';
import '../../domain/usecases/delete_task_usecase.dart';
import '../../domain/usecases/get_tasks_usecase.dart';
import '../../domain/usecases/toggle_task_completion_usecase.dart';

// Events
abstract class TaskEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadTasksEvent extends TaskEvent {
  final String userId;

  LoadTasksEvent(this.userId);

  @override
  List<Object?> get props => [userId];
}

class CreateTaskEvent extends TaskEvent {
  final TaskEntity task;

  CreateTaskEvent(this.task);

  @override
  List<Object?> get props => [task];
}

class UpdateTaskEvent extends TaskEvent {
  final TaskEntity task;

  UpdateTaskEvent(this.task);

  @override
  List<Object?> get props => [task];
}

class DeleteTaskEvent extends TaskEvent {
  final String taskId;

  DeleteTaskEvent(this.taskId);

  @override
  List<Object?> get props => [taskId];
}

class ToggleTaskCompletionEvent extends TaskEvent {
  final String taskId;
  final bool isCompleted;

  ToggleTaskCompletionEvent(this.taskId, this.isCompleted);

  @override
  List<Object?> get props => [taskId, isCompleted];
}

class FilterTasksEvent extends TaskEvent {
  final TaskPriority? priority;
  final bool? isCompleted;

  FilterTasksEvent({this.priority, this.isCompleted});

  @override
  List<Object?> get props => [priority, isCompleted];
}

// States
abstract class TaskState extends Equatable {
  @override
  List<Object?> get props => [];
}

class TaskInitial extends TaskState {}

class TaskLoading extends TaskState {}

class TaskLoaded extends TaskState {
  final List<TaskEntity> tasks;
  final TaskPriority? filterPriority;
  final bool? filterCompleted;

  TaskLoaded(this.tasks, {this.filterPriority, this.filterCompleted});

  List<TaskEntity> get filteredTasks {
    var filtered = tasks;

    if (filterPriority != null) {
      filtered = filtered.where((task) => task.priority == filterPriority).toList();
    }

    if (filterCompleted != null) {
      filtered = filtered.where((task) => task.isCompleted == filterCompleted).toList();
    }

    // Sort by due date
    filtered.sort((a, b) => a.dueDate.compareTo(b.dueDate));

    return filtered;
  }

  @override
  List<Object?> get props => [tasks, filterPriority, filterCompleted];
}

class TaskError extends TaskState {
  final String message;

  TaskError(this.message);

  @override
  List<Object?> get props => [message];
}

// BLoC
class TaskBloc extends Bloc<TaskEvent, TaskState> {
  final CreateTaskUseCase createTask;
  final UpdateTaskUseCase updateTask;
  final DeleteTaskUseCase deleteTask;
  final GetTasksUseCase getTasks;
  final ToggleTaskCompletionUseCase toggleTaskCompletion;

  StreamSubscription? _tasksSubscription;
  TaskPriority? _currentFilterPriority;
  bool? _currentFilterCompleted;

  TaskBloc({
    required this.createTask,
    required this.updateTask,
    required this.deleteTask,
    required this.getTasks,
    required this.toggleTaskCompletion,
  }) : super(TaskInitial()) {
    on<LoadTasksEvent>(_onLoadTasks);
    on<CreateTaskEvent>(_onCreateTask);
    on<UpdateTaskEvent>(_onUpdateTask);
    on<DeleteTaskEvent>(_onDeleteTask);
    on<ToggleTaskCompletionEvent>(_onToggleTaskCompletion);
    on<FilterTasksEvent>(_onFilterTasks);
  }

  Future<void> _onLoadTasks(
    LoadTasksEvent event,
    Emitter<TaskState> emit,
  ) async {
    emit(TaskLoading());
    try {
      await _tasksSubscription?.cancel();
      _tasksSubscription = getTasks(event.userId).listen(
        (tasks) {
          add(FilterTasksEvent(
            priority: _currentFilterPriority,
            isCompleted: _currentFilterCompleted,
          ));
          emit(TaskLoaded(
            tasks,
            filterPriority: _currentFilterPriority,
            filterCompleted: _currentFilterCompleted,
          ));
        },
        onError: (error) {
          emit(TaskError(error.toString()));
        },
      );
    } catch (e) {
      emit(TaskError(e.toString()));
    }
  }

  Future<void> _onCreateTask(
    CreateTaskEvent event,
    Emitter<TaskState> emit,
  ) async {
    try {
      await createTask(event.task);
    } catch (e) {
      emit(TaskError(e.toString()));
    }
  }

  Future<void> _onUpdateTask(
    UpdateTaskEvent event,
    Emitter<TaskState> emit,
  ) async {
    try {
      await updateTask(event.task);
    } catch (e) {
      emit(TaskError(e.toString()));
    }
  }

  Future<void> _onDeleteTask(
    DeleteTaskEvent event,
    Emitter<TaskState> emit,
  ) async {
    try {
      await deleteTask(event.taskId);
    } catch (e) {
      emit(TaskError(e.toString()));
    }
  }

  Future<void> _onToggleTaskCompletion(
    ToggleTaskCompletionEvent event,
    Emitter<TaskState> emit,
  ) async {
    try {
      await toggleTaskCompletion(event.taskId, event.isCompleted);
    } catch (e) {
      emit(TaskError(e.toString()));
    }
  }

  void _onFilterTasks(
    FilterTasksEvent event,
    Emitter<TaskState> emit,
  ) {
    _currentFilterPriority = event.priority;
    _currentFilterCompleted = event.isCompleted;

    if (state is TaskLoaded) {
      final currentState = state as TaskLoaded;
      emit(TaskLoaded(
        currentState.tasks,
        filterPriority: _currentFilterPriority,
        filterCompleted: _currentFilterCompleted,
      ));
    }
  }

  @override
  Future<void> close() {
    _tasksSubscription?.cancel();
    return super.close();
  }
}
