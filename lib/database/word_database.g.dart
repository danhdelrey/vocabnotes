// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'word_database.dart';

// **************************************************************************
// FloorGenerator
// **************************************************************************

abstract class $WordDatabaseBuilderContract {
  /// Adds migrations to the builder.
  $WordDatabaseBuilderContract addMigrations(List<Migration> migrations);

  /// Adds a database [Callback] to the builder.
  $WordDatabaseBuilderContract addCallback(Callback callback);

  /// Creates the database and initializes it.
  Future<WordDatabase> build();
}

// ignore: avoid_classes_with_only_static_members
class $FloorWordDatabase {
  /// Creates a database builder for a persistent database.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static $WordDatabaseBuilderContract databaseBuilder(String name) =>
      _$WordDatabaseBuilder(name);

  /// Creates a database builder for an in memory database.
  /// Information stored in an in memory database disappears when the process is killed.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static $WordDatabaseBuilderContract inMemoryDatabaseBuilder() =>
      _$WordDatabaseBuilder(null);
}

class _$WordDatabaseBuilder implements $WordDatabaseBuilderContract {
  _$WordDatabaseBuilder(this.name);

  final String? name;

  final List<Migration> _migrations = [];

  Callback? _callback;

  @override
  $WordDatabaseBuilderContract addMigrations(List<Migration> migrations) {
    _migrations.addAll(migrations);
    return this;
  }

  @override
  $WordDatabaseBuilderContract addCallback(Callback callback) {
    _callback = callback;
    return this;
  }

  @override
  Future<WordDatabase> build() async {
    final path = name != null
        ? await sqfliteDatabaseFactory.getDatabasePath(name!)
        : ':memory:';
    final database = _$WordDatabase();
    database.database = await database.open(
      path,
      _migrations,
      _callback,
    );
    return database;
  }
}

class _$WordDatabase extends WordDatabase {
  _$WordDatabase([StreamController<String>? listener]) {
    changeListener = listener ?? StreamController<String>.broadcast();
  }

  WordDao? _wordDaoInstance;

  Future<sqflite.Database> open(
    String path,
    List<Migration> migrations, [
    Callback? callback,
  ]) async {
    final databaseOptions = sqflite.OpenDatabaseOptions(
      version: 1,
      onConfigure: (database) async {
        await database.execute('PRAGMA foreign_keys = ON');
        await callback?.onConfigure?.call(database);
      },
      onOpen: (database) async {
        await callback?.onOpen?.call(database);
      },
      onUpgrade: (database, startVersion, endVersion) async {
        await MigrationAdapter.runMigrations(
            database, startVersion, endVersion, migrations);

        await callback?.onUpgrade?.call(database, startVersion, endVersion);
      },
      onCreate: (database, version) async {
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `EnglishWordModel` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `name` TEXT NOT NULL, `phonetic` TEXT, `meanings` TEXT NOT NULL)');

        await callback?.onCreate?.call(database, version);
      },
    );
    return sqfliteDatabaseFactory.openDatabase(path, options: databaseOptions);
  }

  @override
  WordDao get wordDao {
    return _wordDaoInstance ??= _$WordDao(database, changeListener);
  }
}

class _$WordDao extends WordDao {
  _$WordDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _englishWordModelInsertionAdapter = InsertionAdapter(
            database,
            'EnglishWordModel',
            (EnglishWordModel item) => <String, Object?>{
                  'id': item.id,
                  'name': item.name,
                  'phonetic': item.phonetic,
                  'meanings': item.meanings
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<EnglishWordModel> _englishWordModelInsertionAdapter;

  @override
  Future<List<EnglishWordModel>?> getAllWordsInDatabase() async {
    return _queryAdapter.queryList('SELECT * FROM EnglishWordModel',
        mapper: (Map<String, Object?> row) => EnglishWordModel(
            name: row['name'] as String,
            meanings: row['meanings'] as String,
            phonetic: row['phonetic'] as String?));
  }

  @override
  Future<List<EnglishWordModel>?> findWordInDatabase(String word) async {
    return _queryAdapter.queryList(
        'SELECT * FROM EnglishWordModel WHERE name LIKE \'%\' || ?1 || \'%\'',
        mapper: (Map<String, Object?> row) => EnglishWordModel(
            name: row['name'] as String,
            meanings: row['meanings'] as String,
            phonetic: row['phonetic'] as String?),
        arguments: [word]);
  }

  @override
  Future<int?> countWord(String word) async {
    return _queryAdapter.query(
        'SELECT COUNT(*) FROM EnglishWordModel WHERE name LIKE \'%\' || ?1 || \'%\'',
        mapper: (Map<String, Object?> row) => row.values.first as int,
        arguments: [word]);
  }

  @override
  Future<void> deleteWord(String word) async {
    await _queryAdapter.queryNoReturn(
        'DELETE FROM EnglishWordModel WHERE name LIKE \'%\' || ?1 || \'%\'',
        arguments: [word]);
  }

  @override
  Future<void> insertWord(List<EnglishWordModel> word) async {
    await _englishWordModelInsertionAdapter.insertList(
        word, OnConflictStrategy.abort);
  }
}
