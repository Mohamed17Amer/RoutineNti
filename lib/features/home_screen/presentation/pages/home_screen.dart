import 'package:flutter/material.dart';
import 'package:my_creative_routine/core/utils/app_colors.dart';
import 'package:my_creative_routine/core/utils/app_fonts.dart';
import 'package:my_creative_routine/core/utils/app_messages.dart';
import 'package:my_creative_routine/core/widgets/app_avatar.dart';
import 'package:my_creative_routine/features/home_screen/data/models/task_model.dart';
import 'package:my_creative_routine/features/home_screen/data/services/task_service.dart';
import 'package:my_creative_routine/features/home_screen/presentation/pages/add_task_screen.dart';
import 'package:my_creative_routine/features/home_screen/presentation/pages/edit_task_screen.dart';
import 'package:my_creative_routine/features/home_screen/presentation/widgets/empty_task_widget.dart';
import 'package:my_creative_routine/features/home_screen/presentation/widgets/tasks_error_widget.dart';
import 'package:my_creative_routine/features/home_screen/presentation/widgets/tasks_list_widgets.dart';
import 'package:my_creative_routine/features/profile_screen/data/models/user_model.dart';
import 'package:my_creative_routine/features/profile_screen/data/services/user_service.dart';
import 'package:my_creative_routine/features/profile_screen/presentation/pages/profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TaskService _taskService = TaskService();
  final UserService _userService = UserService();

  UserModel? _user;
  List<TaskModel> _tasks = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadUser();
    _loadTasks();
  }

  Future<void> _loadUser() async {
    try {
      final user = await _userService.getUserData();
      if (mounted) setState(() => _user = user);
    } catch (_) {}
  }

  Future<void> _loadTasks() async {
    setState(() {
      _isLoading = _tasks.isEmpty;
      _error = null;
    });
    try {
      final tasks = await _taskService.getMyTasks();
      if (mounted) setState(() => _tasks = tasks);
    } catch (e) {
      if (!mounted) return;
      if (_tasks.isEmpty) {
        setState(() => _error = AppMessages.errorText(e));
      } else {
        AppMessages.showError(context, e);
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _openTask(TaskModel task) async {
    final changed = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (context) => EditTaskScreen(task: task)),
    );
    if (changed == true) _loadTasks();
  }

  Future<void> _addTask() async {
    final added = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (context) => const AddTaskScreen()),
    );
    if (added == true) _loadTasks();
  }

  Future<void> _openProfile() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ProfileScreen(user: _user)),
    );
    _loadUser();
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.primary),
      );
    }
    if (_error != null) {
      return TasksErrorWidget(message: _error!, onRetry: _loadTasks);
    }
    if (_tasks.isEmpty) {
      return RefreshIndicator(
        color: AppColors.primary,
        onRefresh: _loadTasks,
        child: LayoutBuilder(
          builder: (context, constraints) => SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: SizedBox(
              height: constraints.maxHeight,
              child: const EmptyTasksWidget(),
            ),
          ),
        ),
      );
    }
    return RefreshIndicator(
      color: AppColors.primary,
      onRefresh: _loadTasks,
      child: TasksListWidget(tasks: _tasks, onTaskTap: _openTask),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 14.0),
              child: GestureDetector(
                onTap: _openProfile,
                child: Row(
                  children: [
                    AppAvatar(imageUrl: _user?.imageUrl),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Hello!',
                            style: AppFonts.bodyRegular.copyWith(fontSize: 12)),
                        Text(_user?.username ?? '',
                            style: AppFonts.titleBold.copyWith(fontSize: 15)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Expanded(child: _buildBody()),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        onPressed: _addTask,
        child: const Icon(Icons.note_add_outlined, color: AppColors.white),
      ),
    );
  }
}
