import 'page_data.dart';

class ProjectData {
  ProjectData({
    required this.title,
    this.description = '',
    this.code = '',
    this.pages = const [],
  });

  String title;
  String description;
  String code;
  List<PageData> pages;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProjectData &&
          runtimeType == other.runtimeType &&
          code == other.code &&
          title == other.description &&
          code == other.code;

  @override
  int get hashCode => Object.hash(title, description, code);

  factory ProjectData.fromJson(Map<String, dynamic> json) => ProjectData(
        title: json['title'],
        description: json['description'] ?? '',
        code: json['code'] ?? '',
        pages: (json['pages'] as List).map((i) => PageData.fromJson(i)).toList(),
      );

  Map<String, dynamic> toJson() => {
        'title': title,
        'description': description,
        'code': code,
        'imageFiles': pages.map((e) => e.toJson()),
      };
}
