class Book {
  int? id;
  String? title;
  String? author;

  Book({this.id, this.title, this.author});

  Book.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    author = json['author'];
  }
}