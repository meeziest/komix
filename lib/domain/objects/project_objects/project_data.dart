import 'dart:convert';

import 'package:simple_manga_translation/domain/objects/project_objects/page_data.dart';

class ProjectData {
  ProjectData({
    required this.title,
    this.description = '',
    this.code = '',
    this.pagesData = const [],
  });

  String title;
  String description;
  String code;
  List<PageData> pagesData;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProjectData &&
          runtimeType == other.runtimeType &&
          code == other.code &&
          title == other.description &&
          pagesData == other.pagesData &&
          code == other.code;

  @override
  int get hashCode => Object.hash(title, description, code, pagesData);

  factory ProjectData.fromJson(Map<String, dynamic> json) => ProjectData(
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      code: json['code'] ?? '',
      pagesData: (json['files'] as List).map((e) => PageData.fromJson(e)).toList());

  Map<String, dynamic> toJson() =>
      {'title': title, 'description': description, 'code': code, 'files': jsonEncode(pagesData)};
}
