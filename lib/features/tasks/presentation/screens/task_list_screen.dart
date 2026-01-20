import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../../../core/constants/constants.dart';
import '../../../../core/di/injection_container.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/screens/login_screen.dart';
import '../../domain/entities/task_entity.dart';
import '../bloc/task_bloc.dart';
import '../widgets/task_widgets.dart';
import 'add_edit_task_screen.dart';

class TaskListScreen extends StatefulWidget {
  const TaskListScreen({super.key});

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  TaskPriority? _selectedPriority;
  bool? _selectedCompleted;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => sl<AuthBloc>()..add(CheckAuthStatusEvent())),
        BlocProvider(create: (_) => sl<TaskBloc>()),
      ],
      child: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, authState) {
          if (authState is Unauthenticated) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (_) => const LoginScreen()),
            );
          } else if (authState is Authenticated) {
            context.read<TaskBloc>().add(LoadTasksEvent(authState.user.id));
          }
        },
        builder: (context, authState) {
          if (authState is! Authenticated) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }

          return Scaffold(
            body: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.topRight,
                  colors: [
                    AppColors.gradientStart,
                    AppColors.gradientEnd,
                  ],
                  stops: [0.0, 1.0],
                ),
              ),
              child: SafeArea(
                child: Column(
                  children: [
                    _buildHeader(context, authState.user.email),
                    Expanded(
                      child: Container(
                        decoration: const BoxDecoration(
                          color: AppColors.background,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(24),
                            topRight: Radius.circular(24),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildFilters(context),
                            Expanded(child: _buildTaskList(context)),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => BlocProvider.value(
                      value: context.read<TaskBloc>(),
                      child: AddEditTaskScreen(userId: authState.user.id),
                    ),
                  ),
                );
              },
              backgroundColor: AppColors.primary,
              child: const Icon(Icons.add, color: Colors.white),
            ),
            bottomNavigationBar: _buildBottomNav(),
          );
        },
      ),
    );
  }

  Widget _buildHeader(BuildContext context, String? email) {
    return Padding(
      padding: const EdgeInsets.all(AppDimensions.paddingLarge),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Today, ${DateFormat('d MMM').format(DateTime.now())}',
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  AppStrings.myTasks,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.search, color: Colors.white),
            onPressed: () {},
          ),
          PopupMenuButton(
            icon: const Icon(Icons.more_vert, color: Colors.white),
            itemBuilder: (context) => [
              PopupMenuItem(
                child: const Text('Logout'),
                onTap: () {
                  context.read<AuthBloc>().add(LogoutEvent());
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFilters(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppDimensions.paddingMedium),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            CustomFilterChip(
              label: AppStrings.all,
              isSelected: _selectedPriority == null && _selectedCompleted == null,
              onTap: () {
                setState(() {
                  _selectedPriority = null;
                  _selectedCompleted = null;
                });
                context.read<TaskBloc>().add(FilterTasksEvent());
              },
            ),
            const SizedBox(width: 8),
            CustomFilterChip(
              label: AppStrings.high,
              isSelected: _selectedPriority == TaskPriority.high,
              color: AppColors.priorityHigh,
              onTap: () {
                setState(() {
                  _selectedPriority = TaskPriority.high;
                  _selectedCompleted = null;
                });
                context.read<TaskBloc>().add(
                      FilterTasksEvent(priority: TaskPriority.high),
                    );
              },
            ),
            const SizedBox(width: 8),
            CustomFilterChip(
              label: AppStrings.medium,
              isSelected: _selectedPriority == TaskPriority.medium,
              color: AppColors.priorityMedium,
              onTap: () {
                setState(() {
                  _selectedPriority = TaskPriority.medium;
                  _selectedCompleted = null;
                });
                context.read<TaskBloc>().add(
                      FilterTasksEvent(priority: TaskPriority.medium),
                    );
              },
            ),
            const SizedBox(width: 8),
            CustomFilterChip(
              label: AppStrings.low,
              isSelected: _selectedPriority == TaskPriority.low,
              color: AppColors.priorityLow,
              onTap: () {
                setState(() {
                  _selectedPriority = TaskPriority.low;
                  _selectedCompleted = null;
                });
                context.read<TaskBloc>().add(
                      FilterTasksEvent(priority: TaskPriority.low),
                    );
              },
            ),
            const SizedBox(width: 8),
            CustomFilterChip(
              label: AppStrings.completed,
              isSelected: _selectedCompleted == true,
              onTap: () {
                setState(() {
                  _selectedPriority = null;
                  _selectedCompleted = true;
                });
                context.read<TaskBloc>().add(
                      FilterTasksEvent(isCompleted: true),
                    );
              },
            ),
            const SizedBox(width: 8),
            CustomFilterChip(
              label: AppStrings.incomplete,
              isSelected: _selectedCompleted == false,
              onTap: () {
                setState(() {
                  _selectedPriority = null;
                  _selectedCompleted = false;
                });
                context.read<TaskBloc>().add(
                      FilterTasksEvent(isCompleted: false),
                    );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTaskList(BuildContext context) {
    return BlocBuilder<TaskBloc, TaskState>(
      builder: (context, state) {
        if (state is TaskLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is TaskError) {
          return Center(child: Text(state.message));
        } else if (state is TaskLoaded) {
          final tasks = state.filteredTasks;

          if (tasks.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.task_alt, size: 64, color: AppColors.textSecondary),
                  SizedBox(height: 16),
                  Text(
                    'No tasks yet',
                    style: TextStyle(
                      fontSize: 18,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            );
          }

          final groupedTasks = _groupTasksByDate(tasks);

          return ListView(
            padding: const EdgeInsets.all(AppDimensions.paddingMedium),
            children: groupedTasks.entries.map((entry) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Text(
                      entry.key,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                  ...entry.value.map((task) => TaskCard(
                        task: task,
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => BlocProvider.value(
                                value: context.read<TaskBloc>(),
                                child: AddEditTaskScreen(
                                  userId: task.userId,
                                  task: task,
                                ),
                              ),
                            ),
                          );
                        },
                        onToggle: () {
                          context.read<TaskBloc>().add(
                                ToggleTaskCompletionEvent(
                                  task.id,
                                  !task.isCompleted,
                                ),
                              );
                        },
                        onDelete: () {
                          _showDeleteDialog(context, task.id);
                        },
                      )),
                ],
              );
            }).toList(),
          );
        }

        return const SizedBox();
      },
    );
  }

  Map<String, List<TaskEntity>> _groupTasksByDate(List<TaskEntity> tasks) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final tomorrow = today.add(const Duration(days: 1));
    final weekEnd = today.add(const Duration(days: 7));

    final Map<String, List<TaskEntity>> grouped = {
      AppStrings.today: [],
      AppStrings.tomorrow: [],
      AppStrings.thisWeek: [],
    };

    for (final task in tasks) {
      final taskDate = DateTime(
        task.dueDate.year,
        task.dueDate.month,
        task.dueDate.day,
      );

      if (taskDate == today) {
        grouped[AppStrings.today]!.add(task);
      } else if (taskDate == tomorrow) {
        grouped[AppStrings.tomorrow]!.add(task);
      } else if (taskDate.isBefore(weekEnd)) {
        grouped[AppStrings.thisWeek]!.add(task);
      }
    }

    // Remove empty groups
    grouped.removeWhere((key, value) => value.isEmpty);

    return grouped;
  }

  void _showDeleteDialog(BuildContext context, String taskId) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete Task'),
        content: const Text('Are you sure you want to delete this task?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              context.read<TaskBloc>().add(DeleteTaskEvent(taskId));
              Navigator.pop(dialogContext);
            },
            child: const Text('Delete', style: TextStyle(color: AppColors.error)),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNav() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
          ),
        ],
      ),
      child: BottomNavigationBar(
        currentIndex: 0,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.textSecondary,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'Tasks',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: 'Calendar',
          ),
        ],
      ),
    );
  }
}
