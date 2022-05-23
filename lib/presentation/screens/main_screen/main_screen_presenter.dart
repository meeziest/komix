import 'package:flutter/material.dart';
import 'package:simple_manga_translation/data/repository/shared_preferences_repository.dart';
import 'package:simple_manga_translation/domain/interactors/data_core.dart';
import 'package:simple_manga_translation/domain/objects/user_data.dart';
import 'package:simple_manga_translation/presentation/base_components/base_mvp/base_presenter.dart';
import 'package:simple_manga_translation/presentation/screens/main_screen/main_screen_model.dart';
import 'package:simple_manga_translation/presentation/utils/popup_shower.dart';

class MainScreenPresenter extends BasePresenter<MainScreenModel> {
  ScrollController scrollController = ScrollController();
  MainScreenPresenter(MainScreenModel model) : super(model);

  final Map<String, DataCore> _dataCores = {};

  // Widget get selectedSection => _buildSelectedSection();

  @override
  void onInitWithContext() {
    initDataScope(SharedPreferencesRepository().getUserData());
  }

  void initDataScope(List<UserData> users) {
    startLoading();
    for (var user in users) {
      _dataCores[user.userId] = DataCore(user);
    }
    dataScope.dataCore = _dataCores[users.first.userId]!;
    endLoading();
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

  void addProject() {
    Popups.showPopup(title: 'Create project', buttonText: 'Ok', context: context);
  }

  // Widget _buildSelectedSection() {
  //   switch (model.currentSection) {
  //     case (Sections.profile):
  //       return buildProfileSection(context);
  //     case (Sections.projects):
  //       return buildHomeSection(scrollController: scrollController, );
  //     default:
  //       return const SizedBox();
  //   }
  // }
}

enum Sections { profile, projects, settings }
