import 'dart:ui';

class Record {
  String title;
  String? publisher;
  String? author;
  int? isbn;
  String? image;
  String review;
  DateTime createdDate;

  Record({
    required this.review,
    required this.title,
    this.publisher,
    this.author,
    this.isbn,
    this.image,
    required this.createdDate,
  });
}