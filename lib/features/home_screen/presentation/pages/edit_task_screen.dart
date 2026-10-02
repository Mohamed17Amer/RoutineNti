import 'package:flutter/material.dart';
import 'package:my_creative_routine/core/utils/app_colors.dart';
import 'package:my_creative_routine/core/utils/app_fonts.dart';
import 'package:my_creative_routine/core/utils/app_messages.dart';
import 'package:my_creative_routine/core/utils/image_picker_helper.dart';
import 'package:my_creative_routine/core/utils/task_date_picker.dart';
import 'package:my_creative_routine/core/utils/validators.dart';
import 'package:my_creative_routine/core/widgets/app_button.dart';
import 'package:my_creative_routine/core/widgets/custom_txt_field.dart';
import 'package:my_creative_routine/features/home_screen/data/models/task_model.dart';
import 'package:my_creative_routine/features/home_screen/data/services/task_service.dart';
import 'package:my_creative_routine/features/home_screen/presentation/widgets/group_dropdown.dart';
import 'package:my_creative_routine/features/home_screen/presentation/widgets/task_image_picker.dart';

class EditTaskScreen extends StatefulWidget {
  final TaskModel task;

  const EditTaskScreen({super.key, required this.task});

  @override
  State<EditTaskScreen> createState() => _EditTaskScreenState();
}

class _EditTaskScreenState extends State<EditTaskScreen> {
  final _formKey = GlobalKey<FormState>();
  final TaskService _taskService = TaskService();
  late final TextEditingController _titleController;
  late final TextEditingController _descController;
  late final TextEditingController _timeController;
  late String _selectedGroup;
  late bool _isDone;
  PickedImage? _newImage;
  bool _isSaving = false;
  bool _isDeleting = false;

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

  bool get _isBusy => _isSaving || _isDeleting;

  Future<void> _pickImage() async {
    final image = await ImagePickerHelper.pickFromGallery();
    if (image != null && mounted) setState(() => _newImage = image);
  }

  Future<void> _pickEndTime() async {
    final value = await TaskDatePicker.pick(context);
    if (value != null) _timeController.text = value;
  }

  Future<void> _update() async {
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);
    try {
      await _taskService.updateTask(
        widget.task.copyWith(
          title: _titleController.text.trim(),
          description: _descController.text.trim(),
          group: _selectedGroup,
          dateTime: _timeController.text,
          isDone: _isDone,
        ),
        newImage: _newImage,
      );
      if (!mounted) return;
      AppMessages.show(context, 'Task updated');
      Navigator.pop(context, true);
    } catch (e) {
      if (mounted) AppMessages.showError(context, e);
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  Future<void> _delete() async {
    final confirmed = await AppMessages.confirm(
      context,
      title: 'Delete Task',
      message: 'Are you sure you want to delete "${widget.task.title}"?',
    );
    if (!confirmed || !mounted) return;

    setState(() => _isDeleting = true);
    try {
      await _taskService.deleteTask(widget.task.id);
      if (!mounted) return;
      AppMessages.show(context, 'Task deleted');
      Navigator.pop(context, true);
    } catch (e) {
      if (mounted) AppMessages.showError(context, e);
    } finally {
      if (mounted) setState(() => _isDeleting = false);
    }
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
              onPressed: _isBusy ? null : _delete,
              icon: _isDeleting
                  ? const SizedBox(
                      width: 12,
                      height: 12,
                      child: CircularProgressIndicator(
                          strokeWidth: 2, color: AppColors.white),
                    )
                  : const Icon(Icons.delete_outline,
                      color: AppColors.white, size: 14),
              label: const Text('Delete',
                  style: TextStyle(color: AppColors.white, fontSize: 11)),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TaskImagePicker(
                pickedImage: _newImage,
                currentImageUrl: widget.task.imageUrl,
                onTap: _pickImage,
                height: 150,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Icon(
                    _isDone ? Icons.check_circle : Icons.timelapse,
                    color: AppColors.primary,
                    size: 28,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
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
                  ),
                ],
              ),
              const SizedBox(height: 20),
              GroupDropdown(
                value: _selectedGroup,
                onChanged: (group) => setState(() => _selectedGroup = group),
              ),
              const SizedBox(height: 14),
              CustomTextField(
                controller: _titleController,
                hintText: 'Title',
                validator: Validators.taskTitle,
              ),
              const SizedBox(height: 14),
              CustomTextField(
                controller: _descController,
                hintText: 'Description',
                maxLines: 4,
                validator: Validators.taskDescription,
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
              AppButton(
                text: _isDone ? 'Mark as In Progress' : 'Mark as Done',
                onPressed: _isBusy ? null : () => setState(() => _isDone = !_isDone),
              ),
              const SizedBox(height: 12),
              AppButton(
                text: 'Update',
                outlined: true,
                isLoading: _isSaving,
                onPressed: _isDeleting ? null : _update,
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
