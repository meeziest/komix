import 'package:drift/drift.dart';

class Projects extends Table {
  TextColumn get id => text().withLength(min: 1, max: 150)();
  TextColumn get title => text().withLength(min: 6, max: 32)();
  DateTimeColumn get creationTime => dateTime()
      .check(creationTime.isBiggerThan(Constant(DateTime(1970))))
      .withDefault(currentDateAndTime)();
  DateTimeColumn get lastUpdated => dateTime()
      .check(creationTime.isBiggerThan(Constant(DateTime(1970))))
      .withDefault(currentDateAndTime)();
  TextColumn get description => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

class Pages extends Table {
  TextColumn get id => text().withLength(min: 1, max: 150)();
  TextColumn get path => text()();
  BoolColumn get isTranslated => boolean().withDefault(const Constant(false))();
  TextColumn get projectId => text().customConstraint('REFERENCES projects(id) NOT NULL')();

  @override
  Set<Column> get primaryKey => {id};
}

class Bubbles extends Table {
  TextColumn get id => text().withLength(min: 1, max: 150)();
  TextColumn get originalText => text()();
  IntColumn get dx => integer()();
  IntColumn get dy => integer()();
  BoolColumn get isTranslated => boolean().withDefault(const Constant(false))();
  TextColumn get pageId => text().customConstraint('REFERENCES pages(id) NOT NULL')();

  @override
  Set<Column> get primaryKey => {id};
}

class Translations extends Table {
  TextColumn get id => text().withLength(min: 1, max: 150)();
  TextColumn get translationText => text()();
  TextColumn get bubbleId =>
      text().nullable().customConstraint('REFERENCES bubbles(id) NOT NULL')();

  @override
  Set<Column> get primaryKey => {id};
}
