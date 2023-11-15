import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
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
    return await _database.query('reading_list');
  }

  Future<void> addItem({
    required String title,
    String? publisher,
    String? author,
    int? isbn,
    XFile? image,
    required String review,
  }) async {
    String? base64Image;

    if(image != null) {
      List<int> imageBytes = await image.readAsBytes();
      base64Image = base64Encode(imageBytes);
    }
    await _database.insert(
      'reading_list',
      {
        'title': title,
        'publisher': publisher,
        'author': author,
        'isbn': isbn,
        'image': base64Image,
        'review': review,
        'createdDate': DateTime.now().toIso8601String(),
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    notifyListeners();
  }
}
