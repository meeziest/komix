import 'package:simple_manga_translation/presentation/base_components/base_mvp/base_view.dart';
import 'package:simple_manga_translation/presentation/base_components/base_mvp/base_view_model.dart';
import 'package:simple_manga_translation/presentation/screens/auth_screen/authentication_screen_presenter.dart';

class AuthenticationScreenModel extends BaseViewModel {
  AuthenticationScreenModel({ScreenState state = ScreenState.none}) : super(state);

  AuthSection authSection = AuthSection.login;
}
