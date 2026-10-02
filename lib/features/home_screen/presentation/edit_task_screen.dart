import 'package:flutter/material.dart';
import 'package:my_creative_routine/core/utils/app_assets.dart';
import 'package:my_creative_routine/core/utils/app_colors.dart';
import 'package:my_creative_routine/core/utils/app_fonts.dart';
import 'package:my_creative_routine/core/utils/task_date_picker.dart';
import 'package:my_creative_routine/core/widgets/custom_txt_field.dart';
import 'package:my_creative_routine/features/home_screen/presentation/group_dropdown.dart';
import '../data/models/task_model.dart';

class EditTaskScreen extends StatefulWidget {
  final TaskModel task;

  const EditTaskScreen({super.key, required this.task});

  @override
  State<EditTaskScreen> createState() => _EditTaskScreenState();
}

class _EditTaskScreenState extends State<EditTaskScreen> {
  late final TextEditingController _titleController;
  late final TextEditingController _descController;
  late final TextEditingController _timeController;
  late String _selectedGroup;
  late bool _isDone;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.task.title);
    _descController = TextEditingController(text: widget.task.description);
    _timeController = TextEditingController(text: widget.task.dateTime);
    _selectedGroup = widget.task.group;
    _isDone = widget.task.isDone;
  }

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

  void _update() {
    final title = _titleController.text.trim();
    if (title.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Task title can\'t be empty')),
      );
      return;
    }

    Navigator.pop(
      context,
      widget.task.copyWith(
        title: title,
        description: _descController.text.trim(),
        group: _selectedGroup,
        dateTime: _timeController.text,
        isDone: _isDone,
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
        title: const Text('Edit Task', style: AppFonts.titleBold),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            child: TextButton.icon(
              style: TextButton.styleFrom(
                backgroundColor: AppColors.primaryDark,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              ),
              onPressed: () => Navigator.pop(context, 'delete'),
              icon: const Icon(Icons.delete_outline,
                  color: AppColors.white, size: 14),
              label: const Text('Delete',
                  style: TextStyle(color: AppColors.white, fontSize: 11)),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
        child: Column(
          children: [
            Row(
              children: [
                const CircleAvatar(
                  radius: 22,
                  backgroundImage: AssetImage(AppAssets.flagPng),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _isDone ? 'Done' : 'In Progress',
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                    Text(
                      _isDone
                          ? 'Congrats!'
                          : 'Believe you can, and you\'re halfway there.',
                      style: AppFonts.bodyRegular.copyWith(fontSize: 11),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),
            GroupDropdown(
              value: _selectedGroup,
              onChanged: (group) => setState(() => _selectedGroup = group),
            ),
            const SizedBox(height: 14),
            CustomTextField(controller: _titleController, hintText: 'Title'),
            const SizedBox(height: 14),
            CustomTextField(
              controller: _descController,
              hintText: 'Description',
              maxLines: 4,
            ),
            const SizedBox(height: 14),
            CustomTextField(
              controller: _timeController,
              hintText: 'End Time',
              prefixIcon: Icons.calendar_month_outlined,
              readOnly: true,
              onTap: _pickEndTime,
            ),
            const SizedBox(height: 28),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25)),
                ),
                onPressed: () => setState(() => _isDone = !_isDone),
                child: Text(
                  _isDone ? 'Mark as In Progress' : 'Mark as Done',
                  style: AppFonts.buttonText,
                ),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: AppColors.primary),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25)),
                ),
                onPressed: _update,
                child: const Text(
                  'Update',
                  style: TextStyle(
                      color: AppColors.primary, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
