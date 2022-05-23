import 'package:simple_manga_translation/presentation/base_components/base_mvp/base_view.dart';
import 'package:simple_manga_translation/presentation/base_components/base_mvp/base_view_model.dart';

class CodeVerificationViewModel extends BaseViewModel {
  CodeVerificationViewModel(ScreenState state) : super(state);

  late String email;
}
