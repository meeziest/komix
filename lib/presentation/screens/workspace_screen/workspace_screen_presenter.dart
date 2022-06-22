import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:simple_manga_translation/domain/interactors/bubbles_interactor.dart';
import 'package:simple_manga_translation/domain/interactors/download_interactor.dart';
import 'package:simple_manga_translation/domain/interactors/project_pages_interactor.dart';
import 'package:simple_manga_translation/domain/objects/project_objects/bubble_data.dart';
import 'package:simple_manga_translation/domain/objects/project_objects/page_data.dart';
import 'package:simple_manga_translation/models/hive_models/bubble_model.dart';
import 'package:simple_manga_translation/models/hive_models/page_model.dart';
import 'package:simple_manga_translation/models/hive_models/page_type.dart';
import 'package:simple_manga_translation/presentation/base_components/base_mvp/base_presenter.dart';
import 'package:simple_manga_translation/presentation/screens/workspace_screen/workspace_screen_model.dart';

class WorkSpacePresenter extends BasePresenter<WorkSpaceViewModel> {
  WorkSpacePresenter(WorkSpaceViewModel model) : super(model);

  int pageViewIndex = 0;

  @override
  void onInitWithContext() async {}

  void initPages() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      model.originalPages =
          await ProjectPagesInteractor(dataScope).getPagesOfProject(model.projectCode);
      model.originalPages.sort((a, b) {
        return int.parse(basenameWithoutExtension(a.filePath))
            .compareTo(int.parse(basenameWithoutExtension(b.filePath)));
      });
      model.currentPages = [...model.originalPages];
      updateView();
    });
  }

  void toggleCurrentPages(PageType pageType) {
    model.pageType = pageType;
    if (model.pageType == PageType.Original) {
      model.currentPages = [...model.originalPages];
    } else if (model.pageType == PageType.Cleaned) {
      model.currentPages = [...model.cleanedPages];
    } else if (model.pageType == PageType.Translated) {
      model.currentPages = [...model.translatedPages];
    }
    updateView();
  }

  void onPageTap(int index) {
    pageViewIndex = index;
    updateView();
  }

  void getCleanedPages() async {
    model.cleanedPages = await ProjectPagesInteractor(dataScope)
        .getCloudPages(model.projectCode, type: PageType.Cleaned);
    updateView();
  }

  void scanBubbles() async {
    startLoading();
    List<BubbleModel> bubbleModels =
        await ProjectPagesInteractor(dataScope).scanPages(model.projectCode, lang: 'eng');
    for (var element in bubbleModels) {
      model.bubbleFields[element.code] = BubbleField(
          originalTextController: TextEditingController(text: element.originalText),
          translationTextController: TextEditingController());
    }
    endLoading();
    updateView();
  }

  void scan() {}

  void fileSave() {}

  void fileSaveAs() {}

  void fileCopy() {}

  void download() async {
    await DownloadInteractor(dataScope).downloadFile(model.currentPages[pageViewIndex]);
  }

  void reInject() async {
    startLoading();
    List<BubbleData> bubblesData = [];
    model.bubbleFields.forEach((key, value) {
      bubblesData.add(BubbleData(
          code: key,
          originalText: value.originalTextController.text,
          translatedText: value.translationTextController.text));
    });
    PageData pageData =
        await BubblesInteractor(dataScope).reInject(model.cleanedPages[pageViewIndex], bubblesData);
    PageModel pageModel = PageModel(
        ofProject: model.cleanedPages[pageViewIndex].ofProject,
        urlPath: pageData.url,
        order: pageData.order,
        pageType: PageType.Translated);
    try {
      int index = model.translatedPages.indexWhere((element) => element.order == pageData.order);
      model.translatedPages.removeAt(index);
      model.translatedPages.insert(index, pageModel);
      endLoading();
    } catch (e) {
      model.translatedPages.add(pageModel);
      endLoading();
    }
  }

  void onReorder(int oldIndex, int newIndex) {
    if (oldIndex < newIndex) {
      newIndex -= 1;
    }
    final PageModel pageModel = model.currentPages.removeAt(oldIndex);
    model.currentPages.insert(newIndex, pageModel);
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

class BubbleField {
  TextEditingController originalTextController;
  TextEditingController translationTextController;

  BubbleField({required this.originalTextController, required this.translationTextController});
}
