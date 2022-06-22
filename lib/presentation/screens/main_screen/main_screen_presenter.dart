import 'dart:async';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:simple_manga_translation/data/repository/shared_preferences_repository.dart';
import 'package:simple_manga_translation/data/repository/store/local_store/hive/box_local_store.dart';
import 'package:simple_manga_translation/data/repository/store/local_store/local_exceptions/local_exception.dart';
import 'package:simple_manga_translation/domain/interactors/core/data_core.dart';
import 'package:simple_manga_translation/domain/interactors/create_project_interactor.dart';
import 'package:simple_manga_translation/domain/objects/user_data.dart';
import 'package:simple_manga_translation/presentation/base_components/base_mvp/base_presenter.dart';
import 'package:simple_manga_translation/presentation/screens/main_screen/main_screen_model.dart';
import 'package:simple_manga_translation/presentation/screens/workspace_screen/workspace_screen.dart';
import 'package:simple_manga_translation/presentation/screens/workspace_screen/workspace_screen_model.dart';
import 'package:simple_manga_translation/presentation/utils/popup_shower.dart';
import 'package:simple_manga_translation/presentation/utils/utils.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../models/hive_models/project_model.dart';
import '../../utils/popup_shower.dart';

class MainScreenPresenter extends BasePresenter<MainScreenModel> {
  ScrollController scrollController = ScrollController();
  MainScreenPresenter(MainScreenModel model) : super(model);

  TextEditingController usernameController = TextEditingController();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  TextEditingController directoryTextController = TextEditingController();

  late final StreamSubscription projectStoreListener;

  final Map<String, DataCore> _dataCores = {};
  final Map<String, WorkSpaceViewModel> _workSpaces = {};

  @override
  void onInitWithContext() async {
    initDataScope(SharedPreferencesRepository().getUserData());
    initModel();
    projectStoreListener =
        (await BoxLocalStore(dataScope.dataCore.userData).projectStoreStream).listen((event) {
      if (event.value == null) {
        model.projectModels.remove(event.key);
        updateView();
      } else {
        model.projectModels[event.key] = event.value;
        updateView();
      }
    });
  }

  void initDataScope(List<UserData> users) {
    startLoading();
    for (var user in users) {
      _dataCores[user.userId] = DataCore(user);
    }
    dataScope.dataCore = _dataCores[users.first.userId]!;
    endLoading();
  }

  void openProjectWorkspace(String projectCode) async {
    dynamic result;
    if (_workSpaces.containsKey(projectCode)) {
      result = await Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  WorkSpaceScreen(projectCode: projectCode, model: _workSpaces[projectCode])));
    } else {
      result = await Navigator.push(context,
          MaterialPageRoute(builder: (context) => WorkSpaceScreen(projectCode: projectCode)));
    }
    if (result is WorkSpaceViewModel) {
      _workSpaces[projectCode] = result;
    }
  }

  void initModel() async {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      String? saveDirectory = await Utils.getSaveDirectory(dataScope.dataCore.userData);
      if (saveDirectory != null) {
        model.defaultProjectDirectory = saveDirectory;
      } else {
        model.defaultProjectDirectory = await Utils.getDefaultProjectsFolder();
      }
      directoryTextController.text = model.defaultProjectDirectory;
      model.projectModels = await BoxLocalStore(dataScope.dataCore.userData).getAllProjects();
      updateView();
    });
  }

  void onReset() async {
    model.defaultProjectDirectory = await Utils.getDefaultProjectsFolder();
    directoryTextController.text = model.defaultProjectDirectory;
    SharedPreferencesRepository().cleanProjectSavePath(dataScope.dataCore.userData);
  }

  Future<String?> pickSaveDirectory() async {
    String? selectedDirectory = await FilePicker.platform.getDirectoryPath();
    if (selectedDirectory != null && await Directory(selectedDirectory).exists()) {
      SharedPreferencesRepository()
          .setProjectSavePath(selectedDirectory, dataScope.dataCore.userData);
    } else {
      Popups.showPopup(context: context, title: 'Inappropriate path', buttonText: 'Ok');
    }
    return selectedDirectory;
  }

  Future<void> onSettingsSave() async {
    String selectedDirectory = directoryTextController.text;
    if (selectedDirectory.isNotEmpty && await Directory(selectedDirectory).exists()) {
      SharedPreferencesRepository()
          .setProjectSavePath(selectedDirectory, dataScope.dataCore.userData);
    } else {
      Popups.showPopup(context: context, title: 'Inappropriate path', buttonText: 'Ok');
    }
  }

  void onProjectDelete(String projectCode) async {
    var result = await Popups.showPopup(
      context: context,
      title: 'Delete project?',
      buttonText: 'Dismiss',
      cancelButtonText: 'Cancel',
    );
    if (result == PopupsResult.ok) {
      await ProjectInteractor(dataScope).cleanProjectDataFromLocal(projectCode);
    }
  }

  void logOut() {
    dataScope.dataCore.cleanUserData();
    dataScope.deAuth();
    dataScope.rebuild();
  }

  void selectSection(Sections section) {
    model.currentSection = section;
    updateView();
  }

  void openSaveDirectory() async {
    String? saveDirectory = await Utils.getSaveDirectory(dataScope.dataCore.userData);
    Uri uri = Uri.file(saveDirectory ?? await Utils.getDefaultProjectsFolder(), windows: true);
    await launchUrl(uri);
  }

  void addProject() async {
    final result = await Popups.showPopup(
        title: 'Create project',
        secondButtonText: 'Create',
        context: context,
        createProjectPopup: true);
    if (result is ProjectModel) {
      startLoading();
      try {
        await ProjectInteractor(dataScope).createProject(result);
        endLoading();
      } on LocalException catch (e) {
        Popups.showPopup(context: context, title: e.message, buttonText: 'Ok');
        endLoading();
      }
    }
    if (result is PopupsResult) {
      if (result == PopupsResult.emptyFiles) {
        Popups.showPopup(context: context, title: 'No files selected', buttonText: 'Ok');
      } else if (result == PopupsResult.noTitle) {
        Popups.showPopup(context: context, title: 'Please provide title', buttonText: 'Ok');
      }
    }
  }
}

enum Sections { profile, projects, settings }

class ProjectCreateData {
  final String title;
  final String description;
  final List<File> imageFiles;

  ProjectCreateData({required this.title, required this.description, required this.imageFiles});
}
