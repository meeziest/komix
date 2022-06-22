// ignore_for_file: constant_identifier_names

import 'package:hive_flutter/hive_flutter.dart';

part 'page_type.g.dart';

@HiveType(typeId: 4)
enum PageType {
  @HiveField(0)
  Original,
  @HiveField(1)
  Translated,
  @HiveField(2)
  Cleaned,
}

extension ParseToString on PageType {
  String get string => toString().split('.')[1];
}
