import 'package:simple_manga_translation/data/repository/main_repository.dart';
import 'package:simple_manga_translation/data/repository/user_repository.dart';
import 'package:simple_manga_translation/domain/objects/user_data.dart';

class DataCore {
  UserData userData;

  late MainRepository mainRepository;
  late UserRepository userRepository;

  DataCore(this.userData) {
    mainRepository = MainRepository(userData);
    userRepository = UserRepository(userData);
  }

  Future<void> cleanUserData() async {
    await userRepository.clearDb();
  }
}
