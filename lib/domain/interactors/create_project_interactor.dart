import 'dart:io';

import 'package:path/path.dart';
import 'package:simple_manga_translation/data/repository/store/cloud_store/main_cloud_store.dart';
import 'package:simple_manga_translation/data/repository/store/cloud_store/media_cloud_store.dart';
import 'package:simple_manga_translation/data/repository/store/local_store/hive/box_local_store.dart';
import 'package:simple_manga_translation/domain/interactors/base_interactor/base_interactor.dart';
import 'package:simple_manga_translation/domain/objects/project_objects/project_data.dart';
import 'package:simple_manga_translation/models/hive_models/page_model.dart';
import 'package:simple_manga_translation/models/hive_models/page_type.dart';
import 'package:simple_manga_translation/models/hive_models/project_model.dart';
import 'package:simple_manga_translation/presentation/di_scope/data_scope.dart';
import 'package:simple_manga_translation/presentation/utils/utils.dart';

class ProjectInteractor extends BaseInteractor {
  ProjectInteractor(DataScope dataScope) : super(dataScope);

  Future<void> createProject(ProjectModel projectModel) async {
    ProjectData projectData = await MainCloudStore(dataScope.dataCore.userData)
        .createProject(projectModel.title, projectModel.description);
    projectModel.code = projectData.code;
    final store = BoxLocalStore(dataScope.dataCore.userData);
    await store.addProject(projectModel);
    addFilesToProject(projectModel);
  }

  Future<void> addFilesToProject(ProjectModel projectModel) async {
    int pageIndex = 1;
    Map<int, File> orderedPages = {};
    String? saveDirectory = await Utils.getPagesSaveDirectory(
        dataScope.dataCore.userData, projectModel.title, PageType.Original);
    for (final page in projectModel.pageFiles) {
      File copyFile = await page.copy(saveDirectory + pageIndex.toString() + extension(page.path));
      await BoxLocalStore(dataScope.dataCore.userData)
          .putPage(PageModel(filePath: copyFile.path, order: pageIndex, ofProject: projectModel));
      orderedPages[pageIndex] = copyFile;
      pageIndex++;
    }
    await MediaCloudStore(dataScope.dataCore.userData)
        .sendProjects(projectModel.code, orderedPages.values.toList());
    ProjectData projectData =
        await MainCloudStore(dataScope.dataCore.userData).getPages(projectModel.code);
    for (var page in projectData.pagesData) {
      await BoxLocalStore(dataScope.dataCore.userData).putPage(PageModel(
          code: page.code,
          filePath: orderedPages[page.order]!.path,
          order: page.order,
          urlPath: page.url,
          ofProject: projectModel));
    }
  }

  Future<void> cleanProjectDataFromLocal(String projectCode) async {
    // ProjectData projectData = await MainCloudStore(dataScope.dataCore.userData)
    //     .createProject(projectCreateData.title, projectCreateData.description);
    await BoxLocalStore(dataScope.dataCore.userData).removeProjectsBox(projectCode);
    await BoxLocalStore(dataScope.dataCore.userData).removePages(projectCode);
    String? deleteFolder = await Utils.getDeleteDirectory(projectCode, dataScope.dataCore.userData);
    File(deleteFolder).deleteSync(recursive: true);
  }
}
