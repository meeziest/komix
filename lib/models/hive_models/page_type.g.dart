// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'page_type.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PageTypeAdapter extends TypeAdapter<PageType> {
  @override
  final int typeId = 4;

  @override
  PageType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return PageType.Original;
      case 1:
        return PageType.Translated;
      case 2:
        return PageType.Cleaned;
      default:
        return PageType.Original;
    }
  }

  @override
  void write(BinaryWriter writer, PageType obj) {
    switch (obj) {
      case PageType.Original:
        writer.writeByte(0);
        break;
      case PageType.Translated:
        writer.writeByte(1);
        break;
      case PageType.Cleaned:
        writer.writeByte(2);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PageTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
