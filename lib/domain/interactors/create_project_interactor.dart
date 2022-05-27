import 'dart:io';

import 'package:path/path.dart';
import 'package:simple_manga_translation/data/repository/store/local_store/hive/box_local_store.dart';
import 'package:simple_manga_translation/domain/interactors/base_interactor/base_interactor.dart';
import 'package:simple_manga_translation/domain/objects/project_objects/project_data.dart';
import 'package:simple_manga_translation/models/hive_models/page_model.dart';
import 'package:simple_manga_translation/models/hive_models/project_model.dart';
import 'package:simple_manga_translation/presentation/di_scope/data_scope.dart';
import 'package:simple_manga_translation/presentation/utils/utils.dart';

class ProjectInteractor extends BaseInteractor {
  ProjectInteractor(DataScope dataScope) : super(dataScope);

  Future<void> createProject(ProjectModel projectModel) async {
    // ProjectData projectData = await MainCloudStore(dataScope.dataCore.userData)
    //     .createProject(projectModel.title, projectModel.description);
    final store = BoxLocalStore(dataScope.dataCore.userData);
    String? saveDirectory = await getSaveDirectory(projectModel.code);
    await store.addProject(projectModel);
    int pageIndex = 1;
    for (final page in projectModel.pageFiles) {
      File copyFile = await page.copy(saveDirectory + pageIndex.toString() + extension(page.path));
      store.addPageToBox(PageModel(filePath: copyFile.path, ofProject: projectModel));
      pageIndex++;
    }
  }

  Future<void> cleanProjectDataFromLocal(String projectCode) async {
    // ProjectData projectData = await MainCloudStore(dataScope.dataCore.userData)
    //     .createProject(projectCreateData.title, projectCreateData.description);
    await BoxLocalStore(dataScope.dataCore.userData).removeProjectsBox(projectCode);
    String? deleteFolder = await getDeleteDirectory(projectCode);
    File(deleteFolder).deleteSync(recursive: true);
  }

  Future<String> getSaveDirectory(String name) async {
    String? saveDirectory = await Utils.getSaveDirectory(dataScope.dataCore.userData);
    if (saveDirectory == null) {
      saveDirectory = await Utils.createFolderInAppDocDir('$name/original');
    } else {
      saveDirectory = await Utils.createFolderInAppDocDir('$name/original', path: saveDirectory);
    }
    return saveDirectory;
  }

  Future<String> getDeleteDirectory(String name) async {
    String? saveDirectory = await Utils.getSaveDirectory(dataScope.dataCore.userData);
    if (saveDirectory == null) {
      saveDirectory = await Utils.createFolderInAppDocDir(name);
    } else {
      saveDirectory = await Utils.createFolderInAppDocDir(name, path: saveDirectory);
    }
    return saveDirectory;
  }

  void getAll(ProjectData projectData) {
    // dataScope.dataCore.mainRepository.localStore.insertProject(Project(
    //   id: projectData.code,
    //   title: projectData.title,
    //   description: projectData.description,
    //   creationTime: DateTime.now(),
    //   lastUpdated: DateTime.now(),
    // ));
  }
}
