// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'page_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PageModelAdapter extends TypeAdapter<PageModel> {
  @override
  final int typeId = 2;

  @override
  PageModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PageModel(
      filePath: fields[1] as String,
      order: fields[6] as int,
      urlPath: fields[5] as String,
      code: fields[0] as String,
      isTranslated: fields[2] as bool,
      pageType: fields[4] as PageType,
      ofProject: fields[3] as ProjectModel,
    );
  }

  @override
  void write(BinaryWriter writer, PageModel obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.code)
      ..writeByte(1)
      ..write(obj.filePath)
      ..writeByte(2)
      ..write(obj.isTranslated)
      ..writeByte(3)
      ..write(obj.ofProject)
      ..writeByte(4)
      ..write(obj.pageType)
      ..writeByte(5)
      ..write(obj.urlPath)
      ..writeByte(6)
      ..write(obj.order);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PageModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
