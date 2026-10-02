import 'package:flutter/material.dart';
import 'package:my_creative_routine/core/network/api_client.dart';
import 'package:my_creative_routine/core/utils/app_colors.dart';

class TaskModel {
  final String id;
  final String title;
  final String description;
  final String? imageUrl;
  final String group;
  final String dateTime;
  final bool isDone;

  const TaskModel({
    required this.id,
    required this.title,
    required this.description,
    this.imageUrl,
    this.group = 'Home',
    this.dateTime = 'Today',
    this.isDone = false,
  });

  static const List<String> groups = ['Home', 'Personal', 'Work'];

  factory TaskModel.fromJson(Map json) {
    return TaskModel(
      id: json['id']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      imageUrl: ApiClient.imageUrl(
        json['image_path'] ?? json['image'] ?? json['image_url'],
      ),
    );
  }

  Map<String, dynamic> extrasToJson() {
    return {'group': group, 'dateTime': dateTime, 'isDone': isDone};
  }

  TaskModel withExtras(Map? extras) {
    if (extras == null) return this;
    final savedGroup = extras['group'];
    return copyWith(
      group: groups.contains(savedGroup) ? savedGroup as String : null,
      dateTime: extras['dateTime'] as String?,
      isDone: extras['isDone'] as bool?,
    );
  }

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
    String? imageUrl,
    String? group,
    String? dateTime,
    bool? isDone,
  }) {
    return TaskModel(
      id: id,
      title: title ?? this.title,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      group: group ?? this.group,
      dateTime: dateTime ?? this.dateTime,
      isDone: isDone ?? this.isDone,
    );
  }
}
