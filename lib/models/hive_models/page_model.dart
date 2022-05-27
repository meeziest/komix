import 'package:hive/hive.dart';
import 'package:path/path.dart';
import 'package:simple_manga_translation/models/hive_models/project_model.dart';

part 'page_model.g.dart';

@HiveType(typeId: 2)
class PageModel extends HiveObject {
  @HiveField(0)
  String code;

  @HiveField(1)
  String filePath;

  @HiveField(2)
  bool isTranslated;

  @HiveField(3)
  ProjectModel ofProject;

  PageModel(
      {required this.filePath,
      this.code = '',
      this.isTranslated = false,
      required this.ofProject}) {
    if (code.isEmpty) {
      code = [ofProject.code, basename(filePath)].join('-');
    }
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PageModel &&
          runtimeType == other.runtimeType &&
          filePath == other.filePath &&
          isTranslated == other.isTranslated &&
          ofProject.code == other.ofProject.code;

  @override
  int get hashCode => Object.hash(filePath, isTranslated, runtimeType, ofProject.code);
}
