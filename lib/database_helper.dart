import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper with ChangeNotifier {
  late Database _database;

  DatabaseHelper() {
    initDatabase();
  }

  Future<void> initDatabase() async {
    _database = await openDatabase(
      join(await getDatabasesPath(), 'reading_history_database.db'),
      version: 1,
      onCreate: (Database db, int version) async {
        await db.execute(
          '''
          CREATE TABLE reading_list(
          id INTEGER PRIMARY KEY,
          title TEXT,
          publisher TEXT,
          author TEXT,
          isbn INTEGER,
          image TEXT,
          review TEXT,
          createdDate TEXT)
          ''',
        );
      },
    );
    notifyListeners();
  }

  Future<List<Map<String, dynamic>>> getItemList() async {
    return await _database.query('reading_list', orderBy: 'createdDate DESC');
  }

  Future<Map<String, int>> getDateCountList(int year) async {
    Map<String, int> dateCountList = {};
    List<Map<String, dynamic>> result = await _database.rawQuery('''
    SELECT 
      strftime('%Y', createdDate) as year,
      strftime('%m', createdDate) as month,
      COUNT(*) as monthCount
    FROM reading_list
    WHERE year = ?
    GROUP BY year, month
    ORDER BY month
  ''', [year.toString()]);

    for (Map<String, dynamic> row in result) {
      dateCountList[row['month']] = row['monthCount'];
    }
    return dateCountList;
  }

  Future<List<String>> getYearsList() async {
    List<String> yearsList = [];
    List<Map<String, dynamic>> result = await _database.rawQuery('''
    SELECT DISTINCT strftime('%Y', createdDate) as year
    FROM reading_list
    ORDER BY year
    ''');

    for (Map<String, dynamic> row in result) {
      yearsList.add(row['year']);
    }

    return yearsList;
  }

  Future<void> addItem({
    required String title,
    String? publisher,
    String? author,
    String? isbn,
    String? image,
    required String review,
  }) async {
    String? imageSavePath;

    if (image != null) {
      imageSavePath = await saveImage(image);
    }
    await _database.insert(
      'reading_list',
      {
        'title': title,
        'publisher': publisher,
        'author': author,
        'isbn': isbn,
        'image': imageSavePath,
        'review': review,
        'createdDate': DateTime.now().toIso8601String(),
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    notifyListeners();
  }

  Future<void> updateItem({
    required int id,
    required String title,
    String? publisher,
    String? author,
    String? isbn,
    String? image,
    required String review,
  }) async {
    String? imageSavePath;

    if (image != null) {
      imageSavePath = await saveImage(image);
    }
    await _database.update(
      'reading_list',
      {
        'title': title,
        'publisher': publisher,
        'author': author,
        'isbn': isbn,
        'image': imageSavePath,
        'review': review,
      },
      where: 'id = ?',
      whereArgs: [id],
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    notifyListeners();
  }

  Future<void> removeItem({required int itemId}) async {
    await _database.delete(
      'reading_list',
      where: 'id = ?',
      whereArgs: [itemId],
    );
    notifyListeners();
  }

  Future<String> saveImage(String image) async {
    String imagePath = image;

    Directory appDocDir = await getApplicationDocumentsDirectory();

    DateTime now = DateTime.now();
    String today = '${now.year}${now.month}${now.day}';

    String randomNumber =
        (100000 + DateTime.now().microsecondsSinceEpoch % 900000).toString();

    String savePath = '${appDocDir.path}/${today}_$randomNumber.jpg';

    File(savePath).writeAsBytesSync(await File(imagePath).readAsBytesSync());

    return savePath;
  }
}
