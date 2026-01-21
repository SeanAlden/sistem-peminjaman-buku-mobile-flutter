import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sistem_peminjaman_buku_mobile_app/blocs/book_detail/book_detail_bloc.dart';
import 'package:sistem_peminjaman_buku_mobile_app/blocs/book_detail/book_detail_event.dart';
import 'package:sistem_peminjaman_buku_mobile_app/blocs/book_detail/book_detail_state.dart';

class BookDetailScreen extends StatelessWidget {
  const BookDetailScreen({super.key});

  @override
  Widget
   build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Map?;
    final int bookId = args?['bookId'];

    return BlocProvider(
      create: (_) => BookDetailBloc(Dio())..add(FetchBookDetailEvent(bookId)),
      child: Scaffold(
        appBar: AppBar(title: const Text("Detail Buku")),
        body: BlocBuilder<BookDetailBloc, BookDetailState>(
          builder: (context, state) {
            if (state is BookDetailLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is BookDetailError) {
              return Center(child: Text(state.message));
            }

            if (state is BookDetailLoaded) {
              final book = state.data;

              final stock = book['stock'];
              final isBorrowed = book['is_borrowed_by_user'];
              final hasReservation = book['has_active_reservation_by_user'];
              final reservationId = book['active_reservation_id'];
              final status = book['active_reservation_status'];

              return SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Image.network(
                        book['image_url'] ?? "",
                        height: 220,
                        errorBuilder: (_, __, ___) => Image.asset("assets/avatar.png", height: 220),
                      ),
                    ),

                    const SizedBox(height: 16),
                    Text(book['title'], style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                    Text("by ${book['author']}", style: const TextStyle(fontSize: 16, color: Colors.grey)),
                    const SizedBox(height: 16),

                    Text(book['description'] ?? ""),
                    const SizedBox(height: 16),

                    Text("Durasi Pinjam: ${book['loan_duration']} hari"),
                    Text("Stok Tersedia: $stock"),
                    const SizedBox(height: 20),

                    _buildActionButton(context, bookId, stock, isBorrowed, hasReservation, reservationId, status)
                  ],
                ),
              );
            }

            return const SizedBox();
          },
        ),
      ),
    );
  }

  Widget _buildActionButton(
    BuildContext context,
    int bookId,
    int stock,
    bool isBorrowed,
    bool hasReservation,
    int? reservationId,
    String? status,
  ) {
    final bloc = context.read<BookDetailBloc>();

    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        minimumSize: const Size.fromHeight(50),
        backgroundColor: isBorrowed
            ? Colors.grey
            : hasReservation
                ? Colors.red
                : stock > 0
                    ? Colors.green
                    : Colors.orange,
      ),
      onPressed: () {
        if (isBorrowed) return;
        if (hasReservation && reservationId != null) {
          bloc.add(CancelReservationEvent(reservationId));
        } else if (stock > 0) {
          bloc.add(LoanBookEvent(bookId));
        } else {
          bloc.add(ReserveBookEvent(bookId));
        }
      },
      child: Text(
        isBorrowed
            ? "Sudah Dipinjam"
            : hasReservation
                ? "Batalkan Reservasi"
                : stock > 0
                    ? "Pinjam Buku"
                    : "Reservasi & Masuk Antrian",
        style: const TextStyle(color: Colors.white),
      ),
    );
  }
}
