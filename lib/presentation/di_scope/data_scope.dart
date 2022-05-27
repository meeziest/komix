import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:simple_manga_translation/data/repository/shared_preferences_repository.dart';
import 'package:simple_manga_translation/domain/interactors/core/data_core.dart';
import 'package:simple_manga_translation/domain/objects/user_data.dart';

class DataScope {
  late DataCore dataCore;

  DataScopeWidgetState state;
  bool isColdStart;

  BehaviorSubject<List<UserData>?> initialScreenStream = BehaviorSubject();

  DataScope({required this.state, required this.isColdStart});

  Future<void> init() async {
    List<UserData> listUserData = await SharedPreferencesRepository().init();
    initialScreenStream.add(listUserData);
  }

  void dispose() {
    initialScreenStream.close();
  }

  Future deAuth() async {
    initialScreenStream.add([]);
  }

  void rebuild() {
    state.rebuild();
  }
}

class _DataScopeWidget extends InheritedWidget {
  final DataScopeWidgetState state;
  final DataScope dataScope;

  _DataScopeWidget._(Widget child, this.state, this.dataScope) : super(child: child) {
    state.isColdStart = false;
  }

  factory _DataScopeWidget(
      {required Widget child, required DataScopeWidgetState state, required DataScope? dataScope}) {
    return _DataScopeWidget._(
        child, state, dataScope ?? DataScope(state: state, isColdStart: state.isColdStart));
  }

  @override
  bool updateShouldNotify(InheritedWidget old) => true;
}

class DataScopeWidget extends StatefulWidget {
  final Widget child;
  final DataScope? dataScope;

  const DataScopeWidget({Key? key, required this.child, required this.dataScope}) : super(key: key);

  static DataScope of(BuildContext context) {
    final widget = (context.dependOnInheritedWidgetOfExactType<_DataScopeWidget>())?.dataScope;
    if (widget == null) {
      throw Exception('Data was called on null');
    } else {
      return widget;
    }
  }

  @override
  State<StatefulWidget> createState() => DataScopeWidgetState();
}

class DataScopeWidgetState extends State<DataScopeWidget> {
  bool isColdStart = true;

  @override
  Widget build(BuildContext context) {
    return _DataScopeWidget(
      state: this,
      dataScope: widget.dataScope,
      child: widget.child,
    );
  }

  void rebuild() {
    setState(() {});
  }
}
