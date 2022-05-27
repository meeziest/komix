import 'package:simple_manga_translation/data/repository/store/local_store/hive/box_local_store.dart';
import 'package:simple_manga_translation/domain/interactors/base_interactor/base_interactor.dart';
import 'package:simple_manga_translation/models/hive_models/page_model.dart';
import 'package:simple_manga_translation/presentation/di_scope/data_scope.dart';

class ProjectPagesInteractor extends BaseInteractor {
  ProjectPagesInteractor(DataScope dataScope) : super(dataScope);

  Future<List<PageModel>> getPagesOfProject(String projectCode) async {
    List<PageModel> pageModels =
        await BoxLocalStore(dataScope.dataCore.userData).getPagesByProjectCode(projectCode);
    return pageModels;
  }
}
