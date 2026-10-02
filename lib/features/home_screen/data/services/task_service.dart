import 'package:my_creative_routine/core/network/api_client.dart';
import 'package:my_creative_routine/core/network/end_points.dart';
import 'package:my_creative_routine/core/utils/image_picker_helper.dart';
import 'package:my_creative_routine/features/home_screen/data/local/task_extras_storage.dart';
import 'package:my_creative_routine/features/home_screen/data/models/task_model.dart';

class TaskService {
  final ApiClient _api = ApiClient.instance;

  Future<List<TaskModel>> getMyTasks() async {
    final response = await _api.get(EndPoints.myTasks);
    final tasks = _readList(response)
        .whereType<Map>()
        .map(TaskModel.fromJson)
        .where((task) => task.id.isNotEmpty)
        .toList();
    return TaskExtrasStorage.attachTo(tasks);
  }

  Future<void> addTask({
    required String title,
    required String description,
    required String group,
    required String dateTime,
    PickedImage? image,
  }) async {
    final response = await _api.post(
      EndPoints.newTask,
      body: {'title': title, 'description': description, 'image': image},
    );

    final id = ApiClient.findValue(response, 'id');
    if (id == null) return;
    await TaskExtrasStorage.save(
      TaskModel(
        id: id.toString(),
        title: title,
        description: description,
        group: group,
        dateTime: dateTime,
      ),
    );
  }

  Future<void> updateTask(TaskModel task, {PickedImage? newImage}) async {
    await _api.put(
      EndPoints.task(task.id),
      body: {
        'title': task.title,
        'description': task.description,
        'image': newImage,
      },
    );
    await TaskExtrasStorage.save(task);
  }

  Future<void> deleteTask(String id) async {
    await _api.delete(EndPoints.task(id));
    await TaskExtrasStorage.remove(id);
  }

  List _readList(dynamic response) {
    if (response is List) return response;
    if (response is Map) {
      for (final key in ['tasks', 'data', 'my_tasks']) {
        final value = response[key];
        if (value is List) return value;
      }
    }
    return [];
  }
}
