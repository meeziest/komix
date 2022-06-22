import 'package:simple_manga_translation/data/repository/shared_preferences_repository.dart';

class ServerUrlData {
  static String baseUrl() {
    String? baseUrl = SharedPreferencesRepository().getServerUrl();
    return baseUrl != null && baseUrl.isNotEmpty ? baseUrl : '8f14-212-13-131-69.eu.ngrok.io';
  }
}
