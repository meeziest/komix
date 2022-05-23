// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'main_local_store.dart';

// **************************************************************************
// MoorGenerator
// **************************************************************************

// ignore_for_file: type=lint
class Project extends DataClass implements Insertable<Project> {
  final int id;
  final String title;
  final DateTime creationTime;
  final String description;
  Project(
      {required this.id,
      required this.title,
      required this.creationTime,
      required this.description});
  factory Project.fromData(Map<String, dynamic> data, {String? prefix}) {
    final effectivePrefix = prefix ?? '';
    return Project(
      id: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}id'])!,
      title: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}title'])!,
      creationTime: const DateTimeType()
          .mapFromDatabaseResponse(data['${effectivePrefix}creation_time'])!,
      description: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}description'])!,
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['title'] = Variable<String>(title);
    map['creation_time'] = Variable<DateTime>(creationTime);
    map['description'] = Variable<String>(description);
    return map;
  }

  ProjectsCompanion toCompanion(bool nullToAbsent) {
    return ProjectsCompanion(
      id: Value(id),
      title: Value(title),
      creationTime: Value(creationTime),
      description: Value(description),
    );
  }

  factory Project.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Project(
      id: serializer.fromJson<int>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      creationTime: serializer.fromJson<DateTime>(json['creationTime']),
      description: serializer.fromJson<String>(json['description']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'title': serializer.toJson<String>(title),
      'creationTime': serializer.toJson<DateTime>(creationTime),
      'description': serializer.toJson<String>(description),
    };
  }

  Project copyWith(
          {int? id,
          String? title,
          DateTime? creationTime,
          String? description}) =>
      Project(
        id: id ?? this.id,
        title: title ?? this.title,
        creationTime: creationTime ?? this.creationTime,
        description: description ?? this.description,
      );
  @override
  String toString() {
    return (StringBuffer('Project(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('creationTime: $creationTime, ')
          ..write('description: $description')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, title, creationTime, description);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Project &&
          other.id == this.id &&
          other.title == this.title &&
          other.creationTime == this.creationTime &&
          other.description == this.description);
}

class ProjectsCompanion extends UpdateCompanion<Project> {
  final Value<int> id;
  final Value<String> title;
  final Value<DateTime> creationTime;
  final Value<String> description;
  const ProjectsCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.creationTime = const Value.absent(),
    this.description = const Value.absent(),
  });
  ProjectsCompanion.insert({
    this.id = const Value.absent(),
    required String title,
    this.creationTime = const Value.absent(),
    required String description,
  })  : title = Value(title),
        description = Value(description);
  static Insertable<Project> custom({
    Expression<int>? id,
    Expression<String>? title,
    Expression<DateTime>? creationTime,
    Expression<String>? description,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (creationTime != null) 'creation_time': creationTime,
      if (description != null) 'description': description,
    });
  }

  ProjectsCompanion copyWith(
      {Value<int>? id,
      Value<String>? title,
      Value<DateTime>? creationTime,
      Value<String>? description}) {
    return ProjectsCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      creationTime: creationTime ?? this.creationTime,
      description: description ?? this.description,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (creationTime.present) {
      map['creation_time'] = Variable<DateTime>(creationTime.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ProjectsCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('creationTime: $creationTime, ')
          ..write('description: $description')
          ..write(')'))
        .toString();
  }
}

class $ProjectsTable extends Projects with TableInfo<$ProjectsTable, Project> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ProjectsTable(this.attachedDatabase, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int?> id = GeneratedColumn<int?>(
      'id', aliasedName, false,
      type: const IntType(),
      requiredDuringInsert: false,
      defaultConstraints: 'PRIMARY KEY AUTOINCREMENT');
  final VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String?> title = GeneratedColumn<String?>(
      'title', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 6, maxTextLength: 32),
      type: const StringType(),
      requiredDuringInsert: true);
  final VerificationMeta _creationTimeMeta =
      const VerificationMeta('creationTime');
  @override
  late final GeneratedColumn<DateTime?> creationTime =
      GeneratedColumn<DateTime?>('creation_time', aliasedName, false,
          check: () => creationTime.isBiggerThan(Constant(DateTime(1970))),
          type: const IntType(),
          requiredDuringInsert: false,
          defaultValue: currentDateAndTime);
  final VerificationMeta _descriptionMeta =
      const VerificationMeta('description');
  @override
  late final GeneratedColumn<String?> description = GeneratedColumn<String?>(
      'description', aliasedName, false,
      type: const StringType(), requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [id, title, creationTime, description];
  @override
  String get aliasedName => _alias ?? 'projects';
  @override
  String get actualTableName => 'projects';
  @override
  VerificationContext validateIntegrity(Insertable<Project> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('title')) {
      context.handle(
          _titleMeta, title.isAcceptableOrUnknown(data['title']!, _titleMeta));
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('creation_time')) {
      context.handle(
          _creationTimeMeta,
          creationTime.isAcceptableOrUnknown(
              data['creation_time']!, _creationTimeMeta));
    }
    if (data.containsKey('description')) {
      context.handle(
          _descriptionMeta,
          description.isAcceptableOrUnknown(
              data['description']!, _descriptionMeta));
    } else if (isInserting) {
      context.missing(_descriptionMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Project map(Map<String, dynamic> data, {String? tablePrefix}) {
    return Project.fromData(data,
        prefix: tablePrefix != null ? '$tablePrefix.' : null);
  }

  @override
  $ProjectsTable createAlias(String alias) {
    return $ProjectsTable(attachedDatabase, alias);
  }
}

class Page extends DataClass implements Insertable<Page> {
  final int id;
  final String path;
  final int? projectId;
  Page({required this.id, required this.path, this.projectId});
  factory Page.fromData(Map<String, dynamic> data, {String? prefix}) {
    final effectivePrefix = prefix ?? '';
    return Page(
      id: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}id'])!,
      path: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}path'])!,
      projectId: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}project_id']),
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['path'] = Variable<String>(path);
    if (!nullToAbsent || projectId != null) {
      map['project_id'] = Variable<int?>(projectId);
    }
    return map;
  }

  PagesCompanion toCompanion(bool nullToAbsent) {
    return PagesCompanion(
      id: Value(id),
      path: Value(path),
      projectId: projectId == null && nullToAbsent
          ? const Value.absent()
          : Value(projectId),
    );
  }

  factory Page.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Page(
      id: serializer.fromJson<int>(json['id']),
      path: serializer.fromJson<String>(json['path']),
      projectId: serializer.fromJson<int?>(json['projectId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'path': serializer.toJson<String>(path),
      'projectId': serializer.toJson<int?>(projectId),
    };
  }

  Page copyWith({int? id, String? path, int? projectId}) => Page(
        id: id ?? this.id,
        path: path ?? this.path,
        projectId: projectId ?? this.projectId,
      );
  @override
  String toString() {
    return (StringBuffer('Page(')
          ..write('id: $id, ')
          ..write('path: $path, ')
          ..write('projectId: $projectId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, path, projectId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Page &&
          other.id == this.id &&
          other.path == this.path &&
          other.projectId == this.projectId);
}

class PagesCompanion extends UpdateCompanion<Page> {
  final Value<int> id;
  final Value<String> path;
  final Value<int?> projectId;
  const PagesCompanion({
    this.id = const Value.absent(),
    this.path = const Value.absent(),
    this.projectId = const Value.absent(),
  });
  PagesCompanion.insert({
    this.id = const Value.absent(),
    required String path,
    this.projectId = const Value.absent(),
  }) : path = Value(path);
  static Insertable<Page> custom({
    Expression<int>? id,
    Expression<String>? path,
    Expression<int?>? projectId,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (path != null) 'path': path,
      if (projectId != null) 'project_id': projectId,
    });
  }

  PagesCompanion copyWith(
      {Value<int>? id, Value<String>? path, Value<int?>? projectId}) {
    return PagesCompanion(
      id: id ?? this.id,
      path: path ?? this.path,
      projectId: projectId ?? this.projectId,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (path.present) {
      map['path'] = Variable<String>(path.value);
    }
    if (projectId.present) {
      map['project_id'] = Variable<int?>(projectId.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PagesCompanion(')
          ..write('id: $id, ')
          ..write('path: $path, ')
          ..write('projectId: $projectId')
          ..write(')'))
        .toString();
  }
}

class $PagesTable extends Pages with TableInfo<$PagesTable, Page> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PagesTable(this.attachedDatabase, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int?> id = GeneratedColumn<int?>(
      'id', aliasedName, false,
      type: const IntType(),
      requiredDuringInsert: false,
      defaultConstraints: 'PRIMARY KEY AUTOINCREMENT');
  final VerificationMeta _pathMeta = const VerificationMeta('path');
  @override
  late final GeneratedColumn<String?> path = GeneratedColumn<String?>(
      'path', aliasedName, false,
      type: const StringType(), requiredDuringInsert: true);
  final VerificationMeta _projectIdMeta = const VerificationMeta('projectId');
  @override
  late final GeneratedColumn<int?> projectId = GeneratedColumn<int?>(
      'project_id', aliasedName, true,
      type: const IntType(),
      requiredDuringInsert: false,
      $customConstraints: 'NULL REFERENCES projects(id)');
  @override
  List<GeneratedColumn> get $columns => [id, path, projectId];
  @override
  String get aliasedName => _alias ?? 'pages';
  @override
  String get actualTableName => 'pages';
  @override
  VerificationContext validateIntegrity(Insertable<Page> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('path')) {
      context.handle(
          _pathMeta, path.isAcceptableOrUnknown(data['path']!, _pathMeta));
    } else if (isInserting) {
      context.missing(_pathMeta);
    }
    if (data.containsKey('project_id')) {
      context.handle(_projectIdMeta,
          projectId.isAcceptableOrUnknown(data['project_id']!, _projectIdMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Page map(Map<String, dynamic> data, {String? tablePrefix}) {
    return Page.fromData(data,
        prefix: tablePrefix != null ? '$tablePrefix.' : null);
  }

  @override
  $PagesTable createAlias(String alias) {
    return $PagesTable(attachedDatabase, alias);
  }
}

class Bubble extends DataClass implements Insertable<Bubble> {
  final int id;
  final String bubbleText;
  final int dx;
  final int dy;
  final int? pageId;
  Bubble(
      {required this.id,
      required this.bubbleText,
      required this.dx,
      required this.dy,
      this.pageId});
  factory Bubble.fromData(Map<String, dynamic> data, {String? prefix}) {
    final effectivePrefix = prefix ?? '';
    return Bubble(
      id: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}id'])!,
      bubbleText: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}bubble_text'])!,
      dx: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}dx'])!,
      dy: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}dy'])!,
      pageId: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}page_id']),
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['bubble_text'] = Variable<String>(bubbleText);
    map['dx'] = Variable<int>(dx);
    map['dy'] = Variable<int>(dy);
    if (!nullToAbsent || pageId != null) {
      map['page_id'] = Variable<int?>(pageId);
    }
    return map;
  }

  BubblesCompanion toCompanion(bool nullToAbsent) {
    return BubblesCompanion(
      id: Value(id),
      bubbleText: Value(bubbleText),
      dx: Value(dx),
      dy: Value(dy),
      pageId:
          pageId == null && nullToAbsent ? const Value.absent() : Value(pageId),
    );
  }

  factory Bubble.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Bubble(
      id: serializer.fromJson<int>(json['id']),
      bubbleText: serializer.fromJson<String>(json['bubbleText']),
      dx: serializer.fromJson<int>(json['dx']),
      dy: serializer.fromJson<int>(json['dy']),
      pageId: serializer.fromJson<int?>(json['pageId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'bubbleText': serializer.toJson<String>(bubbleText),
      'dx': serializer.toJson<int>(dx),
      'dy': serializer.toJson<int>(dy),
      'pageId': serializer.toJson<int?>(pageId),
    };
  }

  Bubble copyWith(
          {int? id, String? bubbleText, int? dx, int? dy, int? pageId}) =>
      Bubble(
        id: id ?? this.id,
        bubbleText: bubbleText ?? this.bubbleText,
        dx: dx ?? this.dx,
        dy: dy ?? this.dy,
        pageId: pageId ?? this.pageId,
      );
  @override
  String toString() {
    return (StringBuffer('Bubble(')
          ..write('id: $id, ')
          ..write('bubbleText: $bubbleText, ')
          ..write('dx: $dx, ')
          ..write('dy: $dy, ')
          ..write('pageId: $pageId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, bubbleText, dx, dy, pageId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Bubble &&
          other.id == this.id &&
          other.bubbleText == this.bubbleText &&
          other.dx == this.dx &&
          other.dy == this.dy &&
          other.pageId == this.pageId);
}

class BubblesCompanion extends UpdateCompanion<Bubble> {
  final Value<int> id;
  final Value<String> bubbleText;
  final Value<int> dx;
  final Value<int> dy;
  final Value<int?> pageId;
  const BubblesCompanion({
    this.id = const Value.absent(),
    this.bubbleText = const Value.absent(),
    this.dx = const Value.absent(),
    this.dy = const Value.absent(),
    this.pageId = const Value.absent(),
  });
  BubblesCompanion.insert({
    this.id = const Value.absent(),
    required String bubbleText,
    required int dx,
    required int dy,
    this.pageId = const Value.absent(),
  })  : bubbleText = Value(bubbleText),
        dx = Value(dx),
        dy = Value(dy);
  static Insertable<Bubble> custom({
    Expression<int>? id,
    Expression<String>? bubbleText,
    Expression<int>? dx,
    Expression<int>? dy,
    Expression<int?>? pageId,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (bubbleText != null) 'bubble_text': bubbleText,
      if (dx != null) 'dx': dx,
      if (dy != null) 'dy': dy,
      if (pageId != null) 'page_id': pageId,
    });
  }

  BubblesCompanion copyWith(
      {Value<int>? id,
      Value<String>? bubbleText,
      Value<int>? dx,
      Value<int>? dy,
      Value<int?>? pageId}) {
    return BubblesCompanion(
      id: id ?? this.id,
      bubbleText: bubbleText ?? this.bubbleText,
      dx: dx ?? this.dx,
      dy: dy ?? this.dy,
      pageId: pageId ?? this.pageId,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (bubbleText.present) {
      map['bubble_text'] = Variable<String>(bubbleText.value);
    }
    if (dx.present) {
      map['dx'] = Variable<int>(dx.value);
    }
    if (dy.present) {
      map['dy'] = Variable<int>(dy.value);
    }
    if (pageId.present) {
      map['page_id'] = Variable<int?>(pageId.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BubblesCompanion(')
          ..write('id: $id, ')
          ..write('bubbleText: $bubbleText, ')
          ..write('dx: $dx, ')
          ..write('dy: $dy, ')
          ..write('pageId: $pageId')
          ..write(')'))
        .toString();
  }
}

class $BubblesTable extends Bubbles with TableInfo<$BubblesTable, Bubble> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BubblesTable(this.attachedDatabase, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int?> id = GeneratedColumn<int?>(
      'id', aliasedName, false,
      type: const IntType(),
      requiredDuringInsert: false,
      defaultConstraints: 'PRIMARY KEY AUTOINCREMENT');
  final VerificationMeta _bubbleTextMeta = const VerificationMeta('bubbleText');
  @override
  late final GeneratedColumn<String?> bubbleText = GeneratedColumn<String?>(
      'bubble_text', aliasedName, false,
      type: const StringType(), requiredDuringInsert: true);
  final VerificationMeta _dxMeta = const VerificationMeta('dx');
  @override
  late final GeneratedColumn<int?> dx = GeneratedColumn<int?>(
      'dx', aliasedName, false,
      type: const IntType(), requiredDuringInsert: true);
  final VerificationMeta _dyMeta = const VerificationMeta('dy');
  @override
  late final GeneratedColumn<int?> dy = GeneratedColumn<int?>(
      'dy', aliasedName, false,
      type: const IntType(), requiredDuringInsert: true);
  final VerificationMeta _pageIdMeta = const VerificationMeta('pageId');
  @override
  late final GeneratedColumn<int?> pageId = GeneratedColumn<int?>(
      'page_id', aliasedName, true,
      type: const IntType(),
      requiredDuringInsert: false,
      $customConstraints: 'NULL REFERENCES pages(id)');
  @override
  List<GeneratedColumn> get $columns => [id, bubbleText, dx, dy, pageId];
  @override
  String get aliasedName => _alias ?? 'bubbles';
  @override
  String get actualTableName => 'bubbles';
  @override
  VerificationContext validateIntegrity(Insertable<Bubble> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('bubble_text')) {
      context.handle(
          _bubbleTextMeta,
          bubbleText.isAcceptableOrUnknown(
              data['bubble_text']!, _bubbleTextMeta));
    } else if (isInserting) {
      context.missing(_bubbleTextMeta);
    }
    if (data.containsKey('dx')) {
      context.handle(_dxMeta, dx.isAcceptableOrUnknown(data['dx']!, _dxMeta));
    } else if (isInserting) {
      context.missing(_dxMeta);
    }
    if (data.containsKey('dy')) {
      context.handle(_dyMeta, dy.isAcceptableOrUnknown(data['dy']!, _dyMeta));
    } else if (isInserting) {
      context.missing(_dyMeta);
    }
    if (data.containsKey('page_id')) {
      context.handle(_pageIdMeta,
          pageId.isAcceptableOrUnknown(data['page_id']!, _pageIdMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Bubble map(Map<String, dynamic> data, {String? tablePrefix}) {
    return Bubble.fromData(data,
        prefix: tablePrefix != null ? '$tablePrefix.' : null);
  }

  @override
  $BubblesTable createAlias(String alias) {
    return $BubblesTable(attachedDatabase, alias);
  }
}

class Translation extends DataClass implements Insertable<Translation> {
  final int id;
  final String originalText;
  final String translationText;
  final int? bubbleId;
  Translation(
      {required this.id,
      required this.originalText,
      required this.translationText,
      this.bubbleId});
  factory Translation.fromData(Map<String, dynamic> data, {String? prefix}) {
    final effectivePrefix = prefix ?? '';
    return Translation(
      id: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}id'])!,
      originalText: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}original_text'])!,
      translationText: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}translation_text'])!,
      bubbleId: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}bubble_id']),
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['original_text'] = Variable<String>(originalText);
    map['translation_text'] = Variable<String>(translationText);
    if (!nullToAbsent || bubbleId != null) {
      map['bubble_id'] = Variable<int?>(bubbleId);
    }
    return map;
  }

  TranslationsCompanion toCompanion(bool nullToAbsent) {
    return TranslationsCompanion(
      id: Value(id),
      originalText: Value(originalText),
      translationText: Value(translationText),
      bubbleId: bubbleId == null && nullToAbsent
          ? const Value.absent()
          : Value(bubbleId),
    );
  }

  factory Translation.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Translation(
      id: serializer.fromJson<int>(json['id']),
      originalText: serializer.fromJson<String>(json['originalText']),
      translationText: serializer.fromJson<String>(json['translationText']),
      bubbleId: serializer.fromJson<int?>(json['bubbleId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'originalText': serializer.toJson<String>(originalText),
      'translationText': serializer.toJson<String>(translationText),
      'bubbleId': serializer.toJson<int?>(bubbleId),
    };
  }

  Translation copyWith(
          {int? id,
          String? originalText,
          String? translationText,
          int? bubbleId}) =>
      Translation(
        id: id ?? this.id,
        originalText: originalText ?? this.originalText,
        translationText: translationText ?? this.translationText,
        bubbleId: bubbleId ?? this.bubbleId,
      );
  @override
  String toString() {
    return (StringBuffer('Translation(')
          ..write('id: $id, ')
          ..write('originalText: $originalText, ')
          ..write('translationText: $translationText, ')
          ..write('bubbleId: $bubbleId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, originalText, translationText, bubbleId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Translation &&
          other.id == this.id &&
          other.originalText == this.originalText &&
          other.translationText == this.translationText &&
          other.bubbleId == this.bubbleId);
}

class TranslationsCompanion extends UpdateCompanion<Translation> {
  final Value<int> id;
  final Value<String> originalText;
  final Value<String> translationText;
  final Value<int?> bubbleId;
  const TranslationsCompanion({
    this.id = const Value.absent(),
    this.originalText = const Value.absent(),
    this.translationText = const Value.absent(),
    this.bubbleId = const Value.absent(),
  });
  TranslationsCompanion.insert({
    this.id = const Value.absent(),
    required String originalText,
    required String translationText,
    this.bubbleId = const Value.absent(),
  })  : originalText = Value(originalText),
        translationText = Value(translationText);
  static Insertable<Translation> custom({
    Expression<int>? id,
    Expression<String>? originalText,
    Expression<String>? translationText,
    Expression<int?>? bubbleId,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (originalText != null) 'original_text': originalText,
      if (translationText != null) 'translation_text': translationText,
      if (bubbleId != null) 'bubble_id': bubbleId,
    });
  }

  TranslationsCompanion copyWith(
      {Value<int>? id,
      Value<String>? originalText,
      Value<String>? translationText,
      Value<int?>? bubbleId}) {
    return TranslationsCompanion(
      id: id ?? this.id,
      originalText: originalText ?? this.originalText,
      translationText: translationText ?? this.translationText,
      bubbleId: bubbleId ?? this.bubbleId,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (originalText.present) {
      map['original_text'] = Variable<String>(originalText.value);
    }
    if (translationText.present) {
      map['translation_text'] = Variable<String>(translationText.value);
    }
    if (bubbleId.present) {
      map['bubble_id'] = Variable<int?>(bubbleId.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TranslationsCompanion(')
          ..write('id: $id, ')
          ..write('originalText: $originalText, ')
          ..write('translationText: $translationText, ')
          ..write('bubbleId: $bubbleId')
          ..write(')'))
        .toString();
  }
}

class $TranslationsTable extends Translations
    with TableInfo<$TranslationsTable, Translation> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TranslationsTable(this.attachedDatabase, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int?> id = GeneratedColumn<int?>(
      'id', aliasedName, false,
      type: const IntType(),
      requiredDuringInsert: false,
      defaultConstraints: 'PRIMARY KEY AUTOINCREMENT');
  final VerificationMeta _originalTextMeta =
      const VerificationMeta('originalText');
  @override
  late final GeneratedColumn<String?> originalText = GeneratedColumn<String?>(
      'original_text', aliasedName, false,
      type: const StringType(), requiredDuringInsert: true);
  final VerificationMeta _translationTextMeta =
      const VerificationMeta('translationText');
  @override
  late final GeneratedColumn<String?> translationText =
      GeneratedColumn<String?>('translation_text', aliasedName, false,
          type: const StringType(), requiredDuringInsert: true);
  final VerificationMeta _bubbleIdMeta = const VerificationMeta('bubbleId');
  @override
  late final GeneratedColumn<int?> bubbleId = GeneratedColumn<int?>(
      'bubble_id', aliasedName, true,
      type: const IntType(),
      requiredDuringInsert: false,
      $customConstraints: 'NULL REFERENCES bubbles(id)');
  @override
  List<GeneratedColumn> get $columns =>
      [id, originalText, translationText, bubbleId];
  @override
  String get aliasedName => _alias ?? 'translations';
  @override
  String get actualTableName => 'translations';
  @override
  VerificationContext validateIntegrity(Insertable<Translation> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('original_text')) {
      context.handle(
          _originalTextMeta,
          originalText.isAcceptableOrUnknown(
              data['original_text']!, _originalTextMeta));
    } else if (isInserting) {
      context.missing(_originalTextMeta);
    }
    if (data.containsKey('translation_text')) {
      context.handle(
          _translationTextMeta,
          translationText.isAcceptableOrUnknown(
              data['translation_text']!, _translationTextMeta));
    } else if (isInserting) {
      context.missing(_translationTextMeta);
    }
    if (data.containsKey('bubble_id')) {
      context.handle(_bubbleIdMeta,
          bubbleId.isAcceptableOrUnknown(data['bubble_id']!, _bubbleIdMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Translation map(Map<String, dynamic> data, {String? tablePrefix}) {
    return Translation.fromData(data,
        prefix: tablePrefix != null ? '$tablePrefix.' : null);
  }

  @override
  $TranslationsTable createAlias(String alias) {
    return $TranslationsTable(attachedDatabase, alias);
  }
}

abstract class _$MainLocalStore extends GeneratedDatabase {
  _$MainLocalStore(QueryExecutor e) : super(SqlTypeSystem.defaultInstance, e);
  late final $ProjectsTable projects = $ProjectsTable(this);
  late final $PagesTable pages = $PagesTable(this);
  late final $BubblesTable bubbles = $BubblesTable(this);
  late final $TranslationsTable translations = $TranslationsTable(this);
  @override
  Iterable<TableInfo> get allTables => allSchemaEntities.whereType<TableInfo>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities =>
      [projects, pages, bubbles, translations];
}
