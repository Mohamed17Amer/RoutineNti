import 'package:flutter/material.dart';
import 'package:my_creative_routine/core/utils/app_colors.dart';
import 'package:my_creative_routine/features/home_screen/data/models/task_model.dart';
import 'task_card_item.dart';

class TasksListWidget extends StatelessWidget {
  final List<TaskModel> tasks;
  final Function(TaskModel task) onTaskTap;

  const TasksListWidget({
    super.key,
    required this.tasks,
    required this.onTaskTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 90),
      children: [
        Row(
          children: [
            const Text(
              'Tasks',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.textBlack,
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: AppColors.primaryLight,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '${tasks.length}',
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryDark,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        ...tasks.map(
          (task) => TaskCardItem(
            task: task,
            onTap: () => onTaskTap(task),
          ),
        ),
      ],
    );
  }
}
