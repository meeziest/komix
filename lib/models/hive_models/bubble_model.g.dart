// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bubble_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class BubbleModelAdapter extends TypeAdapter<BubbleModel> {
  @override
  final int typeId = 1;

  @override
  BubbleModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return BubbleModel(
      code: fields[0] as String,
      dx: fields[1] as double,
      dy: fields[2] as double,
      ofPage: fields[5] as PageModel,
      originalText: fields[3] as String,
      translationTexts: (fields[4] as Map).cast<String, String>(),
    );
  }

  @override
  void write(BinaryWriter writer, BubbleModel obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.code)
      ..writeByte(1)
      ..write(obj.dx)
      ..writeByte(2)
      ..write(obj.dy)
      ..writeByte(3)
      ..write(obj.originalText)
      ..writeByte(4)
      ..write(obj.translationTexts)
      ..writeByte(5)
      ..write(obj.ofPage);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BubbleModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
