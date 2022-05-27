import 'dart:io';

import 'package:hive/hive.dart';

part 'project_model.g.dart';

@HiveType(typeId: 3)
class ProjectModel extends HiveObject {
  @HiveField(0)
  String code;

  @HiveField(1)
  String title;

  @HiveField(2)
  String description;

  @HiveField(3)
  DateTime creationDate;

  @HiveField(4)
  DateTime lastUpdatedDate;

  List<File> pageFiles;

  ProjectModel(
      {required this.title,
      required this.code,
      DateTime? creationDate,
      DateTime? lastUpdatedDate,
      this.description = '',
      this.pageFiles = const []})
      : lastUpdatedDate = lastUpdatedDate ?? DateTime.now(),
        creationDate = creationDate ?? DateTime.now();

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProjectModel &&
          runtimeType == other.runtimeType &&
          code == other.code &&
          title == other.title &&
          description == other.description &&
          creationDate == other.creationDate &&
          lastUpdatedDate == other.lastUpdatedDate;
  @override
  int get hashCode =>
      Object.hash(code, title, description, creationDate, lastUpdatedDate, runtimeType);
}
