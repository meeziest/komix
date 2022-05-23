import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:simple_manga_translation/data/repository/store/local_store/tables.dart';
import 'package:simple_manga_translation/domain/objects/user_data.dart';

part 'main_local_store.g.dart';

@DriftDatabase(tables: [Projects, Pages, Bubbles, Translations])
class MainLocalStore extends _$MainLocalStore {
  MainLocalStore(UserData? userData) : super(_openConnection(userData));

  @override
  int get schemaVersion => 5;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (Migrator m) {
          return m.createAll();
        },
        onUpgrade: (Migrator m, int from, int to) async {},
      );

  Future<List<Project>> getAllProjects() => select(projects).get();

  Future<List<Project>> getProjectById(int projectId) async {
    return (select(projects)..where((p) => p.id.equals(projectId))).get();
  }

  Stream<List<Project>> watchAllProjects() => select(projects).watch();

  Future insertProject(Project project) => into(projects).insert(project);

  Future updateProject(Project project) => update(projects).replace(project);

  Future deleteProject(Project project) => delete(projects).delete(project);

  Future<List<Page>> getAllPages() => select(pages).get();

  Future<List<Page>> getAllPagesOfProject(int projectId) async {
    return (select(pages)..where((p) => p.projectId.equals(projectId))).get();
  }

  Stream<List<Page>> watchAllPages() => select(pages).watch();

  Future insertPages(Page page) => into(pages).insert(page);

  Future updatePage(Page page) => update(pages).replace(page);

  Future deletePage(Page page) => delete(pages).delete(page);

  Future<List<Bubble>> getAllBubbles() => select(bubbles).get();

  Future<List<Bubble>> getAllBubblesOfPage(int pageId) async {
    return (select(bubbles)..where((b) => b.pageId.equals(pageId))).get();
  }

  Stream<List<Bubble>> watchAllBubbles() => select(bubbles).watch();

  Future insertBubbles(Bubble bubble) => into(bubbles).insert(bubble);

  Future updateBubble(Bubble bubble) => update(bubbles).replace(bubble);

  Future deleteBubble(Bubble bubble) => delete(bubbles).delete(bubble);

  Future<List<Translation>> getAllTranslations() => select(translations).get();

  Future<List<Translation>> getTranslationsOfBubble(int bubbleId) async {
    return (select(translations)..where((t) => t.bubbleId.equals(bubbleId))).get();
  }

  Stream<List<Translation>> watchAllTranslations() => select(translations).watch();

  Future insertTranslation(Translation translation) => into(translations).insert(translation);

  Future updateTranslation(Translation translation) => update(translations).replace(translation);

  Future deleteTranslation(Translation translation) => delete(translations).delete(translation);

  Future dropTables() async {
    final Migrator migrator = createMigrator();
    final iterator = allTables.toList().reversed.iterator;
    while (iterator.moveNext()) {
      await migrator.deleteTable(iterator.current.actualTableName);
    }
    migrator.createAll();
  }
}

LazyDatabase _openConnection(UserData? userData) {
  return LazyDatabase(() async {
    driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(
        dbFolder.path, userData != null ? userData.userId : Platform.localHostname, 'db.sqlite'));
    return NativeDatabase(file);
  });
}
