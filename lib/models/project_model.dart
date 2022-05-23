import 'package:simple_manga_translation/models/page_model.dart';

class ProjectModel {
  final int projectId;
  String title;
  String description;
  DateTime creationDate;
  DateTime lastUpdatedDate;
  List<PageModel> pages;
  int progress;

  ProjectModel(
      {required this.projectId,
      required this.title,
      DateTime? creationDate,
      DateTime? lastUpdatedDate,
      this.description = '',
      this.progress = 0,
      required this.pages})
      : lastUpdatedDate = lastUpdatedDate ?? DateTime.now(),
        creationDate = creationDate ?? DateTime.now();
}
