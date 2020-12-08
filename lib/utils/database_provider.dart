import 'package:peer_route_app/configs/importer.dart';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

DatabaseProvider db = DatabaseProvider.instance;

/// スマホでSQLiteを使用して永続的にデータを保存する
/// [_databaseName] DB名
/// [_databaseVersion] なんのバージョンなのかわからないが1がはいる
/// [table] テーブル名
/// [ColumnId] column 1
/// [ColumnName] column 2
class DatabaseProvider {
  static final _databaseName = "peer_bandai.db";
  static final _databaseVersion = 1;

  static final table = 'get_coupon';

  static final columnId = 'id';
  static final columnName = 'coupon';

  /// DatabaseProviderクラスをシングルトンにするためのコンストラクタ
  DatabaseProvider._privateConstructor();
  static final DatabaseProvider instance =
      DatabaseProvider._privateConstructor();

  /// DBにアクセスするためのメソッド
  static Database _database;
  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await _initDatabase();
    return _database;
  }

  /// データベースを開く
  /// データベースがない場合は作る
  /// [documentsDirectory] アプリケーション専用のファイルを配置するディレクトリへのパスを返す
  /// [path] DBがあるパス
  _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
    );
  }

  /// DBを作成する
  Future _onCreate(Database db, int version) async {
    // ダブルクォートもしくはシングルクォート3つ重ねることで改行で文字列を作成できる。$変数名は、クラス内の変数のこと（文字列の中で使える）
    await db.execute('''
          CREATE TABLE $table (
            $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
            $columnName INTEGER NOT NULL UNIQUE
          )
          ''');
  }

  /// 挿入
  Future<int> insert(Map<String, dynamic> row) async {
    Database db = await instance.database;
    return await db.insert(table, row,
        conflictAlgorithm: ConflictAlgorithm.ignore);
  }

  /// 全件取得
  Future<List<Map<String, dynamic>>> queryAllRows() async {
    Database db = await instance.database;
    return await db.query(table);
  }

  /// データ件数取得
  Future<int> queryRowCount() async {
    Database db = await instance.database;
    return Sqflite.firstIntValue(
        await db.rawQuery('SELECT COUNT(*) FROM $table'));
  }

  /// 更新
  Future<int> update(Map<String, dynamic> row) async {
    Database db = await instance.database;
    int id = row[columnId];
    print([id]);
    return await db.update(table, row, where: '$columnId = ?', whereArgs: [id]);
  }

  /// 削除
  Future<int> delete(int id) async {
    Database db = await instance.database;
    return await db.delete(table, where: '$columnId = ?', whereArgs: [id]);
  }
}
