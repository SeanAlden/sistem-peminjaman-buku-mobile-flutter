import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sistem_peminjaman_buku_mobile_app/blocs/book/book_bloc.dart';
import 'package:sistem_peminjaman_buku_mobile_app/blocs/book/book_event.dart';
import 'package:sistem_peminjaman_buku_mobile_app/blocs/book/book_state.dart';
import 'package:sistem_peminjaman_buku_mobile_app/const/color.dart';

class BookSearchScreen extends StatefulWidget {
  const BookSearchScreen({super.key});

  @override
  State<BookSearchScreen> createState() => _BookSearchScreenState();
}

class _BookSearchScreenState extends State<BookSearchScreen> {
  List<dynamic> books = [];
  List<dynamic> filtered = [];
  String search = "";

  Timer? refreshTimer;

  @override
  void initState() {
    super.initState();

    // Fetch awal
    context.read<BookBloc>().add(FetchBooksEvent());

    // Interval 10 detik seperti React Native
    // refreshTimer = Timer.periodic(
    //   const Duration(seconds: 10),
    //   (_) => context.read<BookBloc>().add(FetchBooksEvent()),
    // );
  }

  @override
  void dispose() {
    refreshTimer?.cancel();
    super.dispose();
  }

  void _filterBooks() {
    setState(() {
      filtered = books
          .where((item) =>
              item['title'].toLowerCase().contains(search.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text(
          "Book Search",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: orangeThemeColor,
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // SEARCH INPUT
              TextField(
                decoration: InputDecoration(
                  hintText: "Cari buku...",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
                onChanged: (value) {
                  search = value;
                  _filterBooks();
                },
              ),

              const SizedBox(height: 16),

              // LIST BUKU
              Expanded(child:
                  // BlocConsumer<BookBloc, BookState>(
                  //   listener: (context, state) {
                  //     if (state is BookLoaded) {
                  //       setState(() {
                  //         books = state.books;
                  //         _filterBooks(); // langsung filter
                  //       });
                  //     }
                  //   },
                  //   builder: (context, state) {
                  //     if (state is BookLoading && books.isEmpty) {
                  //       return const Center(child: CircularProgressIndicator());
                  //     }

                  //     if (state is BookError) {
                  //       return Center(
                  //         child: Text("Gagal memuat buku: ${state.message}"),
                  //       );
                  //     }

                  //     return ListView.builder(
                  //       itemCount: filtered.length,
                  //       itemBuilder: (context, index) {
                  //         final item = filtered[index];

                  //         return GestureDetector(
                  //           onTap: () {
                  //             Navigator.pushNamed(
                  //               context,
                  //               "/book-detail",
                  //               arguments: item.id,
                  //             );
                  //           },
                  //           child: Container(
                  //             margin: const EdgeInsets.only(bottom: 12),
                  //             padding: const EdgeInsets.all(12),
                  //             decoration: BoxDecoration(
                  //               color: Colors.white,
                  //               borderRadius: BorderRadius.circular(12),
                  //               boxShadow: [
                  //                 BoxShadow(
                  //                   color: Colors.black12,
                  //                   blurRadius: 4,
                  //                   offset: Offset(0, 2),
                  //                 ),
                  //               ],
                  //             ),
                  //             child: Row(
                  //               crossAxisAlignment: CrossAxisAlignment.start,
                  //               children: [
                  //                 // GAMBAR BUKU
                  //                 ClipRRect(
                  //                   borderRadius: BorderRadius.circular(8),
                  //                   child: Image.network(
                  //                     item.imageUrl ?? "",
                  //                     width: 70,
                  //                     height: 100,
                  //                     fit: BoxFit.contain,
                  //                     errorBuilder: (context, error, stack) {
                  //                       return Image.asset(
                  //                         "assets/avatar.png",
                  //                         width: 70,
                  //                         height: 100,
                  //                         fit: BoxFit.contain,
                  //                       );
                  //                     },
                  //                   ),
                  //                 ),

                  //                 const SizedBox(width: 12),

                  //                 // TEKS INFO BUKU
                  //                 Expanded(
                  //                   child: Column(
                  //                     crossAxisAlignment: CrossAxisAlignment.start,
                  //                     children: [
                  //                       Text(
                  //                         item.title,
                  //                         maxLines: 1,
                  //                         overflow: TextOverflow.ellipsis,
                  //                         style: const TextStyle(
                  //                           fontSize: 16,
                  //                           fontWeight: FontWeight.bold,
                  //                           color: Colors.black87,
                  //                         ),
                  //                       ),
                  //                       const SizedBox(height: 4),
                  //                       Text(
                  //                         item.author,
                  //                         style: const TextStyle(
                  //                           fontSize: 14,
                  //                           color: Colors.grey,
                  //                         ),
                  //                       ),
                  //                       const SizedBox(height: 6),
                  //                       Text(
                  //                         item.description ?? "",
                  //                         maxLines: 2,
                  //                         overflow: TextOverflow.ellipsis,
                  //                         style: const TextStyle(
                  //                           fontSize: 12,
                  //                           color: Colors.grey,
                  //                         ),
                  //                       ),
                  //                     ],
                  //                   ),
                  //                 )
                  //               ],
                  //             ),
                  //           ),
                  //         );
                  //       },
                  //     );
                  //   },
                  // ),

                  BlocBuilder<BookBloc, BookState>(
                builder: (context, state) {
                  if (state is BookLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (state is BookError) {
                    return Center(
                      child: Text("Gagal memuat buku: ${state.message}"),
                    );
                  }

                  if (state is BookLoaded) {
                    final filtered = state.books
                        .where((item) => item['title']
                            .toLowerCase()
                            .contains(search.toLowerCase()))
                        .toList();

                    return ListView.builder(
                      itemCount: filtered.length,
                      itemBuilder: (context, index) {
                        final item = filtered[index];

                        return GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, "/bookDetail",
                                // arguments: item['id'],
                                arguments: {'bookId': item['id']});
                          },
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 12),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 4,
                                  offset: Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // GAMBAR BUKU
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.network(
                                    item['image_url'] ?? "",
                                    width: 70,
                                    height: 100,
                                    fit: BoxFit.contain,
                                    errorBuilder: (context, error, stack) {
                                      return Image.asset(
                                        "assets/avatar.png",
                                        width: 70,
                                        height: 100,
                                        fit: BoxFit.contain,
                                      );
                                    },
                                  ),
                                ),

                                const SizedBox(width: 12),

                                // TEKS INFO BUKU
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        item['title'],
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black87,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        item['author'],
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey,
                                        ),
                                      ),
                                      const SizedBox(height: 6),
                                      Text(
                                        item['description'] ?? "",
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  }

                  return const SizedBox();
                },
              ))
            ],
          ),
        ),
      ),
    );
  }
}
