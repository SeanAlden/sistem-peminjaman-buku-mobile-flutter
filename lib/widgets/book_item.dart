import 'package:flutter/material.dart';

class BookItem extends StatefulWidget {
  final dynamic book;
  const BookItem({required this.book});

  @override
  State<BookItem> createState() => _BookItemState();
}

class _BookItemState extends State<BookItem> {
  @override
  Widget build(BuildContext context) {
    final imageUrl = widget.book['image_url'];

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 3)),
        ],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: imageUrl != null && imageUrl != ""
                ? Image.network(
                    "https://cellar-c2.services.clever-cloud.com/book-image-bucket/$imageUrl",
                    width: 90,
                    height: 130,
                    fit: BoxFit.contain,
                  )
                : Image.asset(
                    "assets/avatar.png",
                    width: 90,
                    height: 130,
                    fit: BoxFit.contain,
                  ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.book['title'],
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  "oleh ${widget.book['author']}",
                  style: const TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 12),
                Text(
                  widget.book['stock'] > 0
                      ? "Tersedia: ${widget.book['stock']}"
                      : "Tidak Tersedia",
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color:
                        widget.book['stock'] > 0 ? Colors.green : Colors.red,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
