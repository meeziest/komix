import 'package:simple_manga_translation/models/hive_models/page_model.dart';
import 'package:simple_manga_translation/presentation/base_components/base_mvp/base_view.dart';
import 'package:simple_manga_translation/presentation/base_components/base_mvp/base_view_model.dart';

class WorkSpaceViewModel extends BaseViewModel {
  WorkSpaceViewModel({ScreenState state = ScreenState.none, required this.projectCode})
      : super(state);

  List<PageModel> pages = [];
  final String projectCode;
}
