import 'package:simple_manga_translation/data/repository/authentication_repository.dart';
import 'package:simple_manga_translation/data/repository/main_repository.dart';
import 'package:simple_manga_translation/data/repository/shared_preferences_repository.dart';
import 'package:simple_manga_translation/data/repository/user_repository.dart';
import 'package:simple_manga_translation/domain/objects/user_data.dart';

class DataCore {
  UserData userData;

  late AuthenticationRepository authenticationRepository;
  late SharedPreferencesRepository sharedPreferencesRepository;
  late MainRepository mainRepository;
  late UserRepository userRepository;

  DataCore(this.userData) {
    authenticationRepository = AuthenticationRepository();
    sharedPreferencesRepository = SharedPreferencesRepository();
    mainRepository = MainRepository(userData);
    userRepository = UserRepository(userData);
  }

  Future<void> cleanUserData() async {
    await mainRepository.localStore.dropTables();
    await userRepository.clearDb();
  }
}
