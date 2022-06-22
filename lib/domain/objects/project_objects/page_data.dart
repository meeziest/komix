import 'package:simple_manga_translation/domain/objects/project_objects/bubble_data.dart';

class PageData {
  PageData({required this.code, required this.url, required this.order, this.bubbles = const []});

  String code;
  String url;
  int order;
  List<BubbleData> bubbles;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PageData &&
          runtimeType == other.runtimeType &&
          code == other.code &&
          url == other.url &&
          order == other.order;

  @override
  int get hashCode => Object.hash(runtimeType, url, order, code);

  factory PageData.fromJson(Map<String, dynamic> json) => PageData(
        url: json['url'] ?? '',
        order: json['order'] ?? 0,
        code: json['code'] ?? '',
        bubbles: json['bubbles'] != null
            ? ((json['bubbles'] as List).map((e) => BubbleData.fromJson(e)).toList())
            : [],
      );

  Map<String, dynamic> toJson() => {
        'url': url,
        'order': order,
        'code': code,
        'bubbles': List<dynamic>.from(bubbles.map((x) => x.toJson()))
      };
}
