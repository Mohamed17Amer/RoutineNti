import 'package:flutter/material.dart';
import 'package:my_creative_routine/core/utils/app_assets.dart';
import 'package:my_creative_routine/core/utils/app_colors.dart';
import 'package:my_creative_routine/core/utils/app_fonts.dart';
import 'package:my_creative_routine/features/home_screen/data/models/task_model.dart';
import 'package:my_creative_routine/features/home_screen/presentation/add_task_screen.dart';
import 'package:my_creative_routine/features/home_screen/presentation/edit_task_screen.dart';
import 'package:my_creative_routine/features/home_screen/presentation/empty_task_widget.dart';
import 'package:my_creative_routine/features/home_screen/presentation/tasks_list_widgets.dart';
import 'package:my_creative_routine/features/profile_screen/presentation/profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<TaskModel> _tasks = [
    TaskModel(
      id: '1',
      title: 'Morning Sketch',
      description: 'Draw for 20 minutes before starting work',
      group: 'Personal',
      dateTime: '11/03/2025 09:00 AM',
    ),
    TaskModel(
      id: '2',
      title: 'Speaking Practice',
      description: 'Improve my English skills by trying to speak',
      group: 'Home',
      dateTime: '11/03/2025 05:00 PM',
    ),
  ];

  Future<void> _openTask(TaskModel task) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => EditTaskScreen(task: task)),
    );
    if (!mounted) return;

    setState(() {
      final index = _tasks.indexWhere((item) => item.id == task.id);
      if (index < 0) return;
      if (result == 'delete') {
        _tasks.removeAt(index);
      } else if (result is TaskModel) {
        _tasks[index] = result;
      }
    });
  }

  Future<void> _addTask() async {
    final newTask = await Navigator.push<TaskModel>(
      context,
      MaterialPageRoute(builder: (context) => const AddTaskScreen()),
    );
    if (newTask != null && mounted) {
      setState(() => _tasks.add(newTask));
    }
  }

  void _openProfile() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ProfileScreen()),
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
                    const CircleAvatar(
                      radius: 22,
                      backgroundImage: AssetImage(AppAssets.flagPng),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Hello!',
                            style: AppFonts.bodyRegular.copyWith(fontSize: 12)),
                        Text('Ahmed Saber',
                            style: AppFonts.titleBold.copyWith(fontSize: 15)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: _tasks.isEmpty
                  ? const EmptyTasksWidget()
                  : TasksListWidget(tasks: _tasks, onTaskTap: _openTask),
            ),
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
