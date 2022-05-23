import 'package:simple_manga_translation/presentation/base_components/base_mvp/base_view.dart';
import 'package:simple_manga_translation/presentation/base_components/base_mvp/base_view_model.dart';

import 'main_screen_presenter.dart';

class MainScreenModel extends BaseViewModel {
  MainScreenModel({ScreenState state = ScreenState.none}) : super(state);

  Sections currentSection = Sections.projects;
}
