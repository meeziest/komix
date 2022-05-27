import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:simple_manga_translation/domain/interactors/project_pages_interactor.dart';
import 'package:simple_manga_translation/models/hive_models/page_model.dart';
import 'package:simple_manga_translation/presentation/base_components/base_mvp/base_presenter.dart';
import 'package:simple_manga_translation/presentation/screens/workspace_screen/workspace_screen_model.dart';

class WorkSpacePresenter extends BasePresenter<WorkSpaceViewModel> {
  WorkSpacePresenter(WorkSpaceViewModel model) : super(model);

  int pageViewIndex = 0;

  @override
  void onInitWithContext() async {}

  void initPages() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      model.pages = await ProjectPagesInteractor(dataScope).getPagesOfProject(model.projectCode);
      model.pages.sort((a, b) {
        return int.parse(basenameWithoutExtension(a.filePath))
            .compareTo(int.parse(basenameWithoutExtension(b.filePath)));
      });
      updateView();
    });
  }

  void onPageTap(int index) {
    pageViewIndex = index;
    updateView();
  }

  void scan() {}

  void onReorder(int oldIndex, int newIndex) {
    if (oldIndex < newIndex) {
      newIndex -= 1;
    }
    final PageModel pageModel = model.pages.removeAt(oldIndex);
    model.pages.insert(newIndex, pageModel);
    if (oldIndex == pageViewIndex) {
      pageViewIndex = newIndex;
    } else if (newIndex == pageViewIndex) {
      if (pageViewIndex > oldIndex) {
        pageViewIndex = pageViewIndex - 1;
      } else {
        pageViewIndex = pageViewIndex + 1;
      }
    } else if (pageViewIndex > (oldIndex > newIndex ? newIndex : oldIndex) &&
        pageViewIndex < (oldIndex > newIndex ? oldIndex : newIndex)) {
      if (pageViewIndex > oldIndex) {
        pageViewIndex = pageViewIndex - 1;
      } else {
        pageViewIndex = pageViewIndex + 1;
      }
    }
    updateView();
  }
}
