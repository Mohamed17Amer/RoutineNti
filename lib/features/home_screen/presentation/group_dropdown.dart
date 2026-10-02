import 'package:flutter/material.dart';
import 'package:my_creative_routine/core/utils/app_colors.dart';
import 'package:my_creative_routine/features/home_screen/data/models/task_model.dart';

class GroupDropdown extends StatelessWidget {
  final String value;
  final ValueChanged<String> onChanged;

  const GroupDropdown({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.fieldFill,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.fieldBorder),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          items: TaskModel.groups.map((group) {
            return DropdownMenuItem<String>(
              value: group,
              child: Row(
                children: [
                  Icon(
                    TaskModel.groupIcon(group),
                    color: TaskModel.groupColor(group),
                    size: 20,
                  ),
                  const SizedBox(width: 12),
                  Text(group, style: const TextStyle(fontSize: 14)),
                ],
              ),
            );
          }).toList(),
          onChanged: (val) {
            if (val != null) onChanged(val);
          },
        ),
      ),
    );
  }
}
