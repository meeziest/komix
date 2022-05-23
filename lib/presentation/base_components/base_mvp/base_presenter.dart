import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:simple_manga_translation/presentation/di_scope/data_scope.dart';

import 'base_view.dart';
import 'base_view_model.dart';

abstract class BasePresenter<M extends BaseViewModel> {
  M model;
  final BehaviorSubject<M> _subject = BehaviorSubject<M>();
  late BuildContext context;

  Stream<M> get stream => _subject.stream;
  late DataScope dataScope;

  BasePresenter(this.model);

  void initWithContext(BuildContext context) {
    bool firstInit = false;
    try {
      this.context.hashCode != 0;
    } catch (e) {
      firstInit = true;
    }
    this.context = context;
    dataScope = DataScopeWidget.of(context);
    if (firstInit) onInitWithContext();
  }

  void onInitWithContext() {}

  void dispose() {
    _subject.close();
  }

  void updateView() {
    if (!_subject.isClosed) _subject.sink.add(model);
  }

  void startLoading() {
    model.state = ScreenState.loading;
    updateView();
  }

  void endLoading() {
    model.state = ScreenState.done;
    updateView();
  }

  void startReading() {
    model.state = ScreenState.reading;
    updateView();
  }

  void goBack() => Navigator.of(context).pop();

  void endLoadingWithError() {
    model.state = ScreenState.error;
    updateView();
  }
}
