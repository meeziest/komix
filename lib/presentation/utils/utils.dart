import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path/path.dart' as path_lib;
import 'package:simple_manga_translation/data/repository/shared_preferences_repository.dart';
import 'package:simple_manga_translation/domain/objects/user_data.dart';
import 'package:simple_manga_translation/models/hive_models/page_type.dart';

class Utils {
  static void clearRouteStack(BuildContext context) {
    while (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
    }
  }

  static Future<String> createFolderInAppDocDir(String folderName, {String? path}) async {
    final Directory _appDocDir = Directory(path ?? await getDefaultProjectsFolder());
    final Directory _appDocDirFolder = Directory('${_appDocDir.path}/$folderName/');

    if (await _appDocDirFolder.exists()) {
      return _appDocDirFolder.path;
    } else {
      final Directory _appDocDirNewFolder = await _appDocDirFolder.create(recursive: true);
      return _appDocDirNewFolder.path;
    }
  }

  static Future<String> getDefaultProjectsFolder() async {
    return [(await getDbPath()), 'projects'].join(r'\');
  }

  static Future<String?> getSaveDirectory(UserData userData) async {
    String? saveDirectory = SharedPreferencesRepository().getProjectSavePath(userData);
    return saveDirectory;
  }

  static Future<String> getPagesSaveDirectory(UserData userData, String name, PageType type) async {
    String? saveDirectory = await getSaveDirectory(userData);
    if (saveDirectory == null) {
      saveDirectory = await createFolderInAppDocDir('$name/' + type.string);
    } else {
      saveDirectory = await createFolderInAppDocDir('$name/' + type.string, path: saveDirectory);
    }
    return saveDirectory;
  }

  static Future<String> getDeleteDirectory(String name, UserData userData) async {
    String? saveDirectory = await getSaveDirectory(userData);
    if (saveDirectory == null) {
      saveDirectory = await createFolderInAppDocDir(name);
    } else {
      saveDirectory = await createFolderInAppDocDir(name, path: saveDirectory);
    }
    return saveDirectory;
  }

  /// Windows C:\Users\$MyUsername\AppData\Local\$packageName\userdata\
  static Future<String> getDbPath({String? filename, String? folder1}) async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String packageName = packageInfo.packageName;
    String appData = CrossPath.getDatabasePath();
    String dbFolder = 'userdata';
    String appNameFolder = packageName;

    String pathWithAppNameFolder = path_lib.join(appData, appNameFolder);
    final withAppNameFolder = Directory(pathWithAppNameFolder);
    if (!withAppNameFolder.existsSync()) {
      withAppNameFolder.createSync();
    }

    String pathWithDbFolder = path_lib.join(appData, appNameFolder, dbFolder);
    final withDbFolder = Directory(pathWithDbFolder);
    if (!withDbFolder.existsSync()) {
      withDbFolder.createSync();
    }

    String path = path_lib.join(appData, appNameFolder, dbFolder, folder1);
    final dir = Directory(path);
    if (!dir.existsSync()) {
      dir.createSync();
    }
    String pathToFile = path_lib.join(path, filename?.replaceAll(':', ''));
    return pathToFile;
  }
}

extension MapFromList<Element> on List<Element> {
  Map<Key, Element> toMap<Key>(MapEntry<Key, Element> Function(Element e) getEntry) =>
      Map.fromEntries(map(getEntry));

  Map<Key, Element> toMapWhereKey<Key>(Key Function(Element e) getKey) =>
      Map.fromEntries(map((e) => MapEntry(getKey(e), e)));
}

class CrossPath {
  static const MethodChannel _channel = MethodChannel('cross_path');

  static Future<String?> get platformVersion async {
    final String? version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  static String getDatabasePath() => _getPlatformSpecificPath();

  static String _getPlatformSpecificPath() {
    String os = Platform.operatingSystem;
    switch (os) {
      case 'windows':
        return _verify(_findWindows());
    }
    throw Exception('Platform-specific cache path for platform "$os" was not found');
  }

  static String _verify(String path) {
    if (Directory(path).existsSync()) {
      return path;
    }
    throw Exception(
        'The user application path for this platform ("$path") does not exist on this system');
  }

  static String _findWindows() {
    return path_lib.join(Platform.environment['UserProfile']!, 'AppData', 'Local');
  }
}
