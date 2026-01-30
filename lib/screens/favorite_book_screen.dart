import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sistem_peminjaman_buku_mobile_app/const/color.dart';
import 'package:sistem_peminjaman_buku_mobile_app/widgets/book_item.dart';
import '../blocs/favorite/favorite_bloc.dart';
import '../blocs/favorite/favorite_event.dart';
import '../blocs/favorite/favorite_state.dart';

class FavoriteBookScreen extends StatefulWidget {
  const FavoriteBookScreen({super.key});

  @override
  State<FavoriteBookScreen> createState() => _FavoriteBookScreenState();
}

class _FavoriteBookScreenState extends State<FavoriteBookScreen> {
  @override
  void initState() {
    super.initState();

    context.read<FavoriteBloc>().add(FetchFavoritesEvent());
  }

  Future<void> _onRefresh() async {
    context.read<FavoriteBloc>().add(FetchFavoritesEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorite Books',
            style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white)),
        centerTitle: true,
        backgroundColor: orangeThemeColor,
      ),
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: BlocBuilder<FavoriteBloc, FavoriteState>(
          builder: (context, state) {
            if (state is FavoriteLoading) {
              return const _LoadingView();
            }

            if (state is FavoriteError) {
              return _ErrorView(message: state.message);
            }

            if (state is FavoriteLoaded) {
              if (state.books.isEmpty) {
                return const _EmptyView();
              }

              return RefreshIndicator(
                onRefresh: _onRefresh,
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  itemCount: state.books.length,
                  itemBuilder: (context, index) {
                    final book = state.books[index];
                    return BookItem(book: book);
                  },
                ),
              );
            }

            return const SizedBox();
          },
        ),
      ),
    );
  }
}

class _LoadingView extends StatelessWidget {
  const _LoadingView();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 16),
          Text("Memuat Favorit...", style: TextStyle(fontSize: 16)),
        ],
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  final String message;
  const _ErrorView({required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 48, color: Colors.red),
            const SizedBox(height: 16),
            const Text(
              "Oops! Terjadi Kesalahan",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyView extends StatelessWidget {
  const _EmptyView();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.favorite_border, size: 48, color: Colors.grey),
          SizedBox(height: 12),
          Text(
            "Belum Ada Favorit",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 4),
          Text("Tambahkan buku ke favoritmu!",
              style: TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }
}
