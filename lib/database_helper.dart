import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
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

  Future<void> addItem({
    required String title,
    String? publisher,
    String? author,
    String? isbn,
    XFile? image,
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

  Future<void> removeItem({required int itemId}) async {
    print('removeItem called');
    await _database.delete(
      'reading_list',
      where: 'id = ?',
      whereArgs: [itemId],
    );
    notifyListeners();
  }

  Future<String> saveImage(XFile image) async {
    String imagePath = image.path;

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
