import 'package:simple_manga_translation/data/repository/store/cloud_store/main_cloud_store.dart';
import 'package:simple_manga_translation/domain/objects/user_data.dart';

import 'store/local_store/main_local_store.dart';

class MainRepository {
  static final Map<String, MainRepository> _instance = {};
  late MainCloudStore cloudStore;
  late MainLocalStore localStore;
  late UserData userData;

  MainRepository._internal(this.userData) {
    _instance[userData.uniqueId] = this;
    cloudStore = MainCloudStore(userData);
    localStore = MainLocalStore(userData);
  }

  factory MainRepository(UserData userData) =>
      _instance[userData.userId] ?? MainRepository._internal(userData);
}
