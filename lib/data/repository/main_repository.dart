import 'package:simple_manga_translation/data/repository/store/cloud_store/main_cloud_store.dart';
import 'package:simple_manga_translation/data/repository/store/cloud_store/media_cloud_store.dart';
import 'package:simple_manga_translation/data/repository/store/local_store/hive/box_local_store.dart';
import 'package:simple_manga_translation/domain/objects/user_data.dart';

class MainRepository {
  static final Map<String, MainRepository> _instance = {};
  late MainCloudStore cloudStore;
  late MediaCloudStore mediaCloudStore;
  late BoxLocalStore localStore;
  late UserData userData;

  MainRepository._internal(this.userData) {
    _instance[userData.uniqueId] = this;
    cloudStore = MainCloudStore(userData);
    mediaCloudStore = MediaCloudStore(userData);
    _prepareHive();
  }

  void _prepareHive() async {
    BoxLocalStore.prepare();
    localStore = BoxLocalStore(userData);
  }

  factory MainRepository(UserData userData) =>
      _instance[userData.userId] ?? MainRepository._internal(userData);
}
