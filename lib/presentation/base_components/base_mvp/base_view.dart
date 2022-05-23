import 'package:flutter/material.dart';
import 'package:simple_manga_translation/presentation/di_scope/data_scope.dart';

abstract class BaseView {}

enum ScreenState { loading, updating, error, done, reading, uploading, none }

extension StateExt on State {
  DataScope get dataScope => DataScopeWidget.of(context);
}

extension ScreenStateExt on ScreenState {
  bool get isLoading => this == ScreenState.loading;

  bool get isUpdating => this == ScreenState.updating;

  bool get isDone => this == ScreenState.done;

  bool get isError => this == ScreenState.error;

  bool get isReading => this == ScreenState.reading;

  bool get isUploading => this == ScreenState.uploading;

  bool get isNone => this == ScreenState.none;
}
