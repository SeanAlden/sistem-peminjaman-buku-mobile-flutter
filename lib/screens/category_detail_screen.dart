import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sistem_peminjaman_buku_mobile_app/const/color.dart';

import '../blocs/category_detail/category_detail_bloc.dart';
import '../blocs/category_detail/category_detail_event.dart';
import '../blocs/category_detail/category_detail_state.dart';

class CategoryDetailScreen extends StatefulWidget {
  const CategoryDetailScreen({super.key});

  @override
  State<CategoryDetailScreen> createState() => _CategoryDetailScreenState();
}

class _CategoryDetailScreenState extends State<CategoryDetailScreen> {
  late final int categoryId;
  Timer? refreshTimer;

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      final args =
          ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

      categoryId = args['categoryId'];

      context
          .read<CategoryDetailBloc>()
          .add(FetchCategoryDetailEvent(categoryId));
    });
  }

  @override
  void dispose() {
    refreshTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Category Detail"),
        backgroundColor: orangeThemeColor,
      ),
      body: SafeArea(
        child: BlocBuilder<CategoryDetailBloc, CategoryDetailState>(
          builder: (context, state) {
            if (state is CategoryDetailLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is CategoryDetailError) {
              return Center(child: Text(state.message));
            }

            if (state is CategoryDetailLoaded) {
              final books = state.books;

              if (books.isEmpty) {
                return const Center(
                    child: Text("No books found in this category."));
              }

              return GridView.builder(
                padding: const EdgeInsets.all(16),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 0.65,
                ),
                itemCount: books.length,
                itemBuilder: (context, index) {
                  final item = books[index];

                  final imageUrl =
                      "https://cellar-c2.services.clever-cloud.com/book-image-bucket/${item['image_url']}";

                  return GestureDetector(
                    onTap: () => Navigator.pushNamed(context, '/bookDetail',
                        arguments: {'bookId': item['id']}),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: const [
                          BoxShadow(
                              color: Colors.black12,
                              blurRadius: 6,
                              offset: Offset(0, 3))
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(12),
                                topRight: Radius.circular(12)),
                            child: Image.network(
                              imageUrl,
                              height: 150,
                              width: double.infinity,
                              fit: BoxFit.contain,
                              errorBuilder: (context, error, stackTrace) =>
                                  Image.asset("assets/avatar.png",
                                      height: 150,
                                      width: double.infinity,
                                      fit: BoxFit.contain),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(item['title'],
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold)),
                                const SizedBox(height: 4),
                                Text(item['author'],
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                        fontSize: 14, color: Colors.grey)),
                                const SizedBox(height: 4),
                                Text(
                                    "Durasi Peminjaman: ${item['loan_duration']}",
                                    style: const TextStyle(
                                        fontSize: 12, color: Colors.grey)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
