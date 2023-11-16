class Item {
  String title;
  String? publisher;
  String? author;
  String? isbn;
  String? image;
  String review;
  DateTime createdDate;

  Item({
    required this.review,
    required this.title,
    this.publisher,
    this.author,
    this.isbn,
    this.image,
    required this.createdDate,
  });
}
