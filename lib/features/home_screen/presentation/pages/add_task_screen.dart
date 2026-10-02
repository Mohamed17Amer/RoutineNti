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

class AddTaskScreen extends StatefulWidget {
  const AddTaskScreen({super.key});

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  final TaskService _taskService = TaskService();

  String _selectedGroup = TaskModel.groups.first;
  PickedImage? _image;
  bool _isLoading = false;

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    _timeController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final image = await ImagePickerHelper.pickFromGallery();
    if (image != null && mounted) setState(() => _image = image);
  }

  Future<void> _pickEndTime() async {
    final value = await TaskDatePicker.pick(context);
    if (value != null) _timeController.text = value;
  }

  Future<void> _addTask() async {
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    try {
      await _taskService.addTask(
        title: _titleController.text.trim(),
        description: _descController.text.trim(),
        group: _selectedGroup,
        dateTime:
            _timeController.text.isNotEmpty ? _timeController.text : 'Today',
        image: _image,
      );
      if (!mounted) return;
      AppMessages.show(context, 'Task added');
      Navigator.pop(context, true);
    } catch (e) {
      if (mounted) AppMessages.showError(context, e);
    } finally {
      if (mounted) setState(() => _isLoading = false);
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
        title: const Text('Add Task', style: AppFonts.titleBold),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TaskImagePicker(pickedImage: _image, onTap: _pickImage),
              const SizedBox(height: 20),
              CustomTextField(
                controller: _titleController,
                hintText: 'Title',
                validator: Validators.taskTitle,
              ),
              const SizedBox(height: 14),
              CustomTextField(
                controller: _descController,
                hintText: 'Description',
                maxLines: 3,
                validator: Validators.taskDescription,
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
              AppButton(
                text: 'Add Task',
                isLoading: _isLoading,
                onPressed: _addTask,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
