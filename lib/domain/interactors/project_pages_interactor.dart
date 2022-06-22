import 'package:simple_manga_translation/data/repository/store/cloud_store/main_cloud_store.dart';
import 'package:simple_manga_translation/data/repository/store/local_store/hive/box_local_store.dart';
import 'package:simple_manga_translation/domain/interactors/base_interactor/base_interactor.dart';
import 'package:simple_manga_translation/domain/objects/project_objects/project_data.dart';
import 'package:simple_manga_translation/models/hive_models/bubble_model.dart';
import 'package:simple_manga_translation/models/hive_models/page_model.dart';
import 'package:simple_manga_translation/models/hive_models/page_type.dart';
import 'package:simple_manga_translation/models/hive_models/project_model.dart';
import 'package:simple_manga_translation/presentation/di_scope/data_scope.dart';
import 'package:simple_manga_translation/presentation/utils/utils.dart';

class ProjectPagesInteractor extends BaseInteractor {
  ProjectPagesInteractor(DataScope dataScope) : super(dataScope);

  Future<List<PageModel>> getPagesOfProject(String projectCode) async {
    List<PageModel> pageModels =
        await BoxLocalStore(dataScope.dataCore.userData).getPages(projectCode);
    return pageModels;
  }

  Future<List<PageModel>> getCloudPages(String projectCode, {PageType? type}) async {
    ProjectData projectsData =
        await MainCloudStore(dataScope.dataCore.userData).getPages(projectCode, type: type);
    List<PageModel> pageModels = [];
    for (var element in projectsData.pagesData) {
      pageModels.add(PageModel(
        code: element.code,
        ofProject: ProjectModel(code: projectCode, title: projectsData.title),
        order: element.order,
        urlPath: element.url,
        pageType: PageType.Cleaned,
      ));
    }
    return pageModels;
  }

  Future<List<BubbleModel>> scanPages(String projectCode, {String? lang}) async {
    ProjectData projectsData =
        await MainCloudStore(dataScope.dataCore.userData).scanText(projectCode, lang: lang);
    List<BubbleModel> bubbleModels = [];
    for (var element in projectsData.pagesData) {
      for (var bubble in element.bubbles) {
        bubbleModels.add(BubbleModel(
            ofPage: PageModel(
              ofProject: ProjectModel(code: projectCode, title: projectsData.title),
              order: element.order,
              urlPath: element.url,
              pageType: PageType.Cleaned,
            ),
            code: bubble.code,
            originalText: bubble.originalText,
            translationTexts: {'translation': bubble.translatedText}));
      }
    }
    return bubbleModels;
  }

  Future<void> save(PageModel pageModel, List<BubbleModel> bubbleModels) async {
    // ProjectData projectData = await MainCloudStore(dataScope.dataCore.userData)
    //     .createProject(projectModel.title, projectModel.description);
    final store = BoxLocalStore(dataScope.dataCore.userData);
    String? saveDirectory = await Utils.getPagesSaveDirectory(
        dataScope.dataCore.userData, pageModel.ofProject.code, PageType.Cleaned);
  }
}
