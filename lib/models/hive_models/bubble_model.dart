import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:simple_manga_translation/models/hive_models/page_model.dart';

part 'bubble_model.g.dart';

@HiveType(typeId: 1)
class BubbleModel extends HiveObject {
  @HiveField(0)
  String code;

  @HiveField(1)
  double dx;

  @HiveField(2)
  double dy;

  @HiveField(3)
  String originalText;

  @HiveField(4)
  Map<String, String> translationTexts;

  @HiveField(5)
  PageModel ofPage;

  BubbleModel(
      {this.code = '',
      required this.ofPage,
      this.dx = 0,
      this.dy = 0,
      this.originalText = '',
      this.translationTexts = const {}}) {
    if (code.isEmpty) {
      code = [ofPage.code, dx, dy].join('-');
    }
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BubbleModel &&
          runtimeType == other.runtimeType &&
          dx == other.dx &&
          dy == other.dy &&
          mapEquals(translationTexts, other.translationTexts);

  @override
  int get hashCode => Object.hash(dx, dy, runtimeType, translationTexts);
}
