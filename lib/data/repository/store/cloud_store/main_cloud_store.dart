import 'package:simple_manga_translation/data/repository/store/cloud_store/base/base_user_api_request.dart';
import 'package:simple_manga_translation/domain/objects/user_data.dart';

class MainCloudStore extends BaseUserApiRequest {
  MainCloudStore(UserData userData) : super(userData);
}
