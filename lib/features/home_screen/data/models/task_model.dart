import 'package:flutter/material.dart';
import 'package:my_creative_routine/core/utils/app_colors.dart';

class TaskModel {
  final String id;
  final String title;
  final String description;
  final String group;
  final String dateTime;
  bool isDone;

  TaskModel({
    required this.id,
    required this.title,
    required this.description,
    required this.group,
    required this.dateTime,
    this.isDone = false,
  });

  static const List<String> groups = ['Home', 'Personal', 'Work'];

  static IconData groupIcon(String group) {
    switch (group) {
      case 'Personal':
        return Icons.person_outline;
      case 'Work':
        return Icons.work_outline;
      default:
        return Icons.home_outlined;
    }
  }

  static Color groupColor(String group) {
    switch (group) {
      case 'Personal':
        return AppColors.primary;
      case 'Work':
        return Colors.black87;
      default:
        return Colors.pinkAccent;
    }
  }

  TaskModel copyWith({
    String? title,
    String? description,
    String? group,
    String? dateTime,
    bool? isDone,
  }) {
    return TaskModel(
      id: id,
      title: title ?? this.title,
      description: description ?? this.description,
      group: group ?? this.group,
      dateTime: dateTime ?? this.dateTime,
      isDone: isDone ?? this.isDone,
    );
  }
}
