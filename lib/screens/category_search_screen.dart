import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sistem_peminjaman_buku_mobile_app/blocs/category/category_bloc.dart';
import 'package:sistem_peminjaman_buku_mobile_app/blocs/category/category_event.dart';
import 'package:sistem_peminjaman_buku_mobile_app/blocs/category/category_state.dart';
import 'package:sistem_peminjaman_buku_mobile_app/const/color.dart';

class CategorySearchScreen extends StatefulWidget {
  const CategorySearchScreen({super.key});

  @override
  State<CategorySearchScreen> createState() => _CategorySearchScreenState();
}

class _CategorySearchScreenState extends State<CategorySearchScreen> {
  String search = "";
  List<dynamic> filtered = [];

  @override
  void initState() {
    super.initState();

    context.read<CategoryBloc>().add(FetchCategoriesEvent());
  }

  void filterList(List<dynamic> categories) {
    setState(() {
      filtered = categories
          .where((item) => (item['name'] as String)
              .toLowerCase()
              .contains(search.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "Category Search",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: orangeThemeColor,
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: TextField(
                decoration: InputDecoration(
                  hintText: "Cari kategori...",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                ),
                onChanged: (value) {
                  setState(() => search = value);
                  final state = context.read<CategoryBloc>().state;
                  if (state is CategoryLoaded) {
                    filterList(state.categories);
                  }
                },
              ),
            ),
            Expanded(
              child: BlocBuilder<CategoryBloc, CategoryState>(
                builder: (context, state) {
                  if (state is CategoryLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (state is CategoryLoaded) {
                    final displayList = search.isEmpty
                        ? state.categories
                        : state.categories
                            .where((item) => (item['name'] as String)
                                .toLowerCase()
                                .contains(search.toLowerCase()))
                            .toList();

                    if (displayList.isEmpty) {
                      return const Center(
                        child: Text("Kategori tidak ditemukan"),
                      );
                    }

                    return ListView.builder(
                      itemCount: displayList.length,
                      itemBuilder: (context, index) {
                        final item = displayList[index];

                        return InkWell(
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              "/categoryDetail",
                              arguments: {
                                "categoryId": item['id'],
                                "categoryName": item['name'],
                              },
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 14, horizontal: 16),
                            decoration: const BoxDecoration(
                              border: Border(
                                bottom:
                                    BorderSide(color: Colors.grey, width: 0.3),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  item['name'],
                                  style: const TextStyle(
                                      fontSize: 16, color: Colors.black87),
                                ),
                                const Icon(Icons.chevron_right,
                                    color: Colors.grey),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  }

                  if (state is CategoryError) {
                    return Center(
                      child: Text("Error: ${state.message}"),
                    );
                  }

                  return const SizedBox.shrink();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
