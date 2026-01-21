class FavoriteBookModel {
  final int id;
  final String title;
  final String author;
  final String? description;
  final String? imageUrl;
  final int stock;

  FavoriteBookModel({
    required this.id,
    required this.title,
    required this.author,
    this.description,
    this.imageUrl,
    required this.stock,
  });

  factory FavoriteBookModel.fromJson(Map<String, dynamic> json) {
    return FavoriteBookModel(
      id: json['id'],
      title: json['title'],
      author: json['author'],
      description: json['description'],
      imageUrl: json['image_url'],
      stock: json['stock'] ?? 0,
    );
  }
}
