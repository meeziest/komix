import 'package:drift/drift.dart';

class Projects extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get title => text().withLength(min: 6, max: 32)();
  DateTimeColumn get creationTime => dateTime()
      .check(creationTime.isBiggerThan(Constant(DateTime(1970))))
      .withDefault(currentDateAndTime)();
  DateTimeColumn get lastUpdated => dateTime()
      .check(creationTime.isBiggerThan(Constant(DateTime(1970))))
      .withDefault(currentDateAndTime)();
  TextColumn get description => text().nullable()();
}

class Pages extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get path => text()();
  BoolColumn get isTranslated => boolean().withDefault(const Constant(false))();
  IntColumn get projectId => integer().customConstraint('REFERENCES projects(id) NOT NULL')();
}

class Bubbles extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get originalText => text()();
  IntColumn get dx => integer()();
  IntColumn get dy => integer()();
  BoolColumn get isTranslated => boolean().withDefault(const Constant(false))();
  IntColumn get pageId => integer().customConstraint('REFERENCES pages(id) NOT NULL')();
}

class Translations extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get translationText => text()();
  IntColumn get bubbleId =>
      integer().nullable().customConstraint('REFERENCES bubbles(id) NOT NULL')();
}
