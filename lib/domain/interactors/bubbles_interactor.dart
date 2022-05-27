import 'package:simple_manga_translation/domain/interactors/base_interactor/base_interactor.dart';
import 'package:simple_manga_translation/models/hive_models/bubble_model.dart';
import 'package:simple_manga_translation/presentation/di_scope/data_scope.dart';

class BubblesInteractor extends BaseInteractor {
  BubblesInteractor(DataScope dataScope) : super(dataScope);

  void addBubbles(List<BubbleModel> bubbleModels) {
    for (final bubble in bubbleModels) {
      dataScope.dataCore.mainRepository.localStore.addBubbleToBox(bubble);
    }
  }
}
