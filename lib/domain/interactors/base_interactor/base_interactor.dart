import 'package:simple_manga_translation/presentation/di_scope/data_scope.dart';

abstract class BaseInteractor {
  final DataScope dataScope;

  BaseInteractor(this.dataScope);
}
