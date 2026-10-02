import 'package:flutter/material.dart';
import 'package:my_creative_routine/core/utils/app_assets.dart';
import 'package:my_creative_routine/core/utils/app_colors.dart';
import 'package:my_creative_routine/core/utils/app_fonts.dart';
import 'package:my_creative_routine/core/utils/task_date_picker.dart';
import 'package:my_creative_routine/core/widgets/custom_txt_field.dart';
import 'package:my_creative_routine/features/home_screen/presentation/group_dropdown.dart';

import '../data/models/task_model.dart';

class AddTaskScreen extends StatefulWidget {
  const AddTaskScreen({super.key});

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();

  String _selectedGroup = TaskModel.groups.first;

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    _timeController.dispose();
    super.dispose();
  }

  Future<void> _pickEndTime() async {
    final value = await TaskDatePicker.pick(context);
    if (value != null) _timeController.text = value;
  }

  void _addTask() {
    final title = _titleController.text.trim();
    if (title.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a task title')),
      );
      return;
    }

    Navigator.pop(
      context,
      TaskModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: title,
        description: _descController.text.trim(),
        group: _selectedGroup,
        dateTime:
            _timeController.text.isNotEmpty ? _timeController.text : 'Today',
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new,
              size: 18, color: AppColors.textBlack),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: const Text('Add Task', style: AppFonts.titleBold),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.asset(
                AppAssets.flagPng,
                height: 180,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 20),
            CustomTextField(controller: _titleController, hintText: 'Title'),
            const SizedBox(height: 14),
            CustomTextField(
              controller: _descController,
              hintText: 'Description',
              maxLines: 3,
            ),
            const SizedBox(height: 14),
            GroupDropdown(
              value: _selectedGroup,
              onChanged: (group) => setState(() => _selectedGroup = group),
            ),
            const SizedBox(height: 14),
            CustomTextField(
              controller: _timeController,
              hintText: 'End Time',
              prefixIcon: Icons.calendar_month_outlined,
              readOnly: true,
              onTap: _pickEndTime,
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25)),
                ),
                onPressed: _addTask,
                child: const Text('Add Task', style: AppFonts.buttonText),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
