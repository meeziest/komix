import 'package:hive/hive.dart';
import 'package:simple_manga_translation/data/repository/store/local_store/local_exceptions/local_exception.dart';
import 'package:simple_manga_translation/domain/objects/user_data.dart';
import 'package:simple_manga_translation/models/hive_models/bubble_model.dart';
import 'package:simple_manga_translation/models/hive_models/page_model.dart';
import 'package:simple_manga_translation/models/hive_models/page_type.dart';
import 'package:simple_manga_translation/models/hive_models/project_model.dart';

const String _keyProject = 'project_box_store';
const String _keyPage = 'page_box_store';
const String _keyBubble = 'bubble_box_store';

class BoxLocalStore {
  final UserData userData;

  BoxLocalStore(this.userData);

  Future<Stream<BoxEvent>> get projectStoreStream async {
    return (await _openProjectBox()).watch();
  }

  Future<Stream<BoxEvent>> get pageStoreStream async {
    return (await _openPageBox()).watch();
  }

  Future<Stream<BoxEvent>> get bubbleStoreStream async {
    return (await _openPageBox()).watch();
  }

  Future<Map<String, ProjectModel>> getAllProjects() async {
    var box1 = await _openProjectBox();
    Map<String, ProjectModel> projectModels = Map<String, ProjectModel>.from(box1.toMap());
    Map<String, ProjectModel> currentUserProjects = {};
    for (var key in projectModels.keys) {
      if (key == [userData.userId, projectModels[key]!.code].join('-')) {
        currentUserProjects[key] = projectModels[key]!;
      }
    }
    return currentUserProjects;
  }

  Future<void> addProject(ProjectModel projectModel) async {
    var box = await _openProjectBox();
    String key = '${userData.userId}-${projectModel.code}';
    if (box.containsKey(key)) {
      throw LocalException(code: LocalExceptionCode.alreadyExists);
    } else {
      box.put(key, projectModel);
    }
  }

  Future<void> updateProject(ProjectModel projectModel) async {
    var box = await _openProjectBox();
    await box.put('${userData.userId}-${projectModel.code}', projectModel);
  }

  Future<void> removeProjectsBox(String projectCode) async {
    var box = await _openProjectBox();
    await box.delete('${userData.userId}-$projectCode');
  }

  Future<ProjectModel?> getProject(String code) async {
    var box = await _openProjectBox();
    if (box.containsKey('${userData.userId}-$code')) {
      return box.get('${userData.userId}-$code');
    }
    return null;
  }

  Future<List<PageModel>> getPages(String code) async {
    var box1 = await _openPageBox();
    List<PageModel> pageModels = [];
    box1.toMap().forEach((key, value) {
      if (value.ofProject.code == code) {
        pageModels.add(value);
      }
    });
    return pageModels;
  }

  Future<void> putPage(PageModel pageModel) async {
    var box = await _openPageBox();
    await box.put(
        '${userData.userId}-${pageModel.ofProject.code}-${pageModel.pageType}-${pageModel.order}',
        pageModel);
  }

  Future<void> removePages(String code) async {
    var box = await _openPageBox();
    List<String> keys = [];
    box.toMap().forEach((key, value) {
      if (value.ofProject.code == code) {
        keys.add(key);
      }
    });
    await box.deleteAll(keys);
  }

  Future<PageModel?> getPage(String code, PageType type) async {
    var box = await _openPageBox();
    return await box.get('${userData.userId}-$code-$type');
  }

  Future<void> addBubbleToBox(BubbleModel bubbleModel) async {
    var box = await _openBubbleBox();
    await box.put('${userData.userId}-${bubbleModel.code}', bubbleModel);
  }

  Future<void> removeBubbleFromBox(String code) async {
    var box = await _openBubbleBox();
    await box.delete('${userData.userId}-$code');
  }

  Future<BubbleModel?> getBubble(String code) async {
    var box = await _openBubbleBox();
    if (box.containsKey('${userData.userId}-$code')) {
      return await box.get('${userData.userId}-$code');
    }
    return null;
  }

  static void _registerAdapter() {
    if (!Hive.isAdapterRegistered(ProjectModelAdapter().typeId)) {
      Hive.registerAdapter<ProjectModel>(ProjectModelAdapter());
    }
    if (!Hive.isAdapterRegistered(PageModelAdapter().typeId)) {
      Hive.registerAdapter<PageModel>(PageModelAdapter());
    }
    if (!Hive.isAdapterRegistered(BubbleModelAdapter().typeId)) {
      Hive.registerAdapter<BubbleModel>(BubbleModelAdapter());
    }
    if (!Hive.isAdapterRegistered(PageTypeAdapter().typeId)) {
      Hive.registerAdapter<PageType>(PageTypeAdapter());
    }
  }

  static Future<Map<String, Box<dynamic>>> prepare() async {
    _registerAdapter();
    Map<String, Box<dynamic>> boxes = {};
    boxes[_keyProject] = await _openProjectBox();
    boxes[_keyPage] = await _openPageBox();
    boxes[_keyBubble] = await _openBubbleBox();
    return boxes;
  }

  static Future<Box> _openProjectBox() => Hive.openBox<ProjectModel>(_keyProject);

  static Future<Box> _openPageBox() => Hive.openBox<PageModel>(_keyPage);

  static Future<Box> _openBubbleBox() => Hive.openBox<BubbleModel>(_keyBubble);
}
