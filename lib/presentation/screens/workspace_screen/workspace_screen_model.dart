import 'package:simple_manga_translation/models/hive_models/page_model.dart';
import 'package:simple_manga_translation/models/hive_models/page_type.dart';
import 'package:simple_manga_translation/presentation/base_components/base_mvp/base_view.dart';
import 'package:simple_manga_translation/presentation/base_components/base_mvp/base_view_model.dart';
import 'package:simple_manga_translation/presentation/screens/workspace_screen/workspace_screen_presenter.dart';

class WorkSpaceViewModel extends BaseViewModel {
  WorkSpaceViewModel({ScreenState state = ScreenState.none, required this.projectCode})
      : super(state);

  List<PageModel> currentPages = [];

  List<PageModel> originalPages = [];
  List<PageModel> translatedPages = [];
  List<PageModel> cleanedPages = [];

  Map<String, BubbleField> bubbleFields = {};

  PageType pageType = PageType.Original;

  final String projectCode;
}
