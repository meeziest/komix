import 'package:path/path.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:simple_manga_translation/data/repository/store/cloud_store/media_cloud_store.dart';
import 'package:simple_manga_translation/domain/interactors/base_interactor/base_interactor.dart';
import 'package:simple_manga_translation/models/hive_models/page_model.dart';
import 'package:simple_manga_translation/presentation/di_scope/data_scope.dart';
import 'package:simple_manga_translation/presentation/utils/utils.dart';

class DownloadInteractor extends BaseInteractor {
  DownloadInteractor(DataScope dataScope) : super(dataScope);

  Future<void> downloadFile(PageModel pageModel) async {
    final status = await Permission.locationWhenInUse.request();
    if (status == PermissionStatus.granted) {
      String? saveDirectory = await Utils.getPagesSaveDirectory(
          dataScope.dataCore.userData, pageModel.ofProject.title, pageModel.pageType);
      await MediaCloudStore(dataScope.dataCore.userData)
          .downloadFile(pageModel.urlPath, saveDirectory + basename(pageModel.filePath));
    }
  }
}
