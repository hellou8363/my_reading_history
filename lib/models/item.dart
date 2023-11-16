class Item {
  int? id;
  String title;
  String? publisher;
  String? author;
  String? isbn;
  String? image;
  String review;
  DateTime createdDate;

  Item({
    this.id,
    required this.title,
    required this.review,
    this.publisher,
    this.author,
    this.isbn,
    this.image,
    required this.createdDate,
  });
}
