import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sistem_peminjaman_buku_mobile_app/blocs/book_detail/book_detail_event.dart';
import 'package:sistem_peminjaman_buku_mobile_app/blocs/book_detail/book_detail_state.dart';
import 'package:sistem_peminjaman_buku_mobile_app/const/api_url.dart';

class BookDetailBloc extends Bloc<BookDetailEvent, BookDetailState> {
  final Dio dio;

  BookDetailBloc(this.dio) : super(BookDetailInitial()) {
    on<FetchBookDetailEvent>(_fetchDetail);
    on<LoanBookEvent>(_loan);
    on<ReserveBookEvent>(_reserve);
    on<CancelReservationEvent>(_cancelReservation);
  }

  Future<void> _fetchDetail(
      FetchBookDetailEvent event, Emitter<BookDetailState> emit) async {
    emit(BookDetailLoading());

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString("auth_token");
      final response = await dio.get(
        "${baseurl}/api/book-details/${event.bookId}",
        options: Options(headers: {"Authorization": "Bearer $token"}),
      );

      emit(BookDetailLoaded(response.data['data']));
    } catch (e) {
      emit(BookDetailError("Gagal memuat detail buku"));
    }
  }

  Future<void> _loan(LoanBookEvent event, Emitter<BookDetailState> emit) async {
    emit(BookDetailSubmitting());
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString("auth_token");

      await dio.post(
        "${baseurl}/api/loans",
        data: {"book_id": event.bookId},
        options: Options(headers: {"Authorization": "Bearer $token"}),
      );

      add(FetchBookDetailEvent(event.bookId));
    } catch (e) {
      emit(BookDetailError("Gagal meminjam buku"));
    }
  }

  Future<void> _reserve(
      ReserveBookEvent event, Emitter<BookDetailState> emit) async {
    emit(BookDetailSubmitting());
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString("auth_token");

      await dio.post(
        "${baseurl}/api/reservations",
        data: {"book_id": event.bookId},
        options: Options(headers: {"Authorization": "Bearer $token"}),
      );

      add(FetchBookDetailEvent(event.bookId));
    } catch (e) {
      emit(BookDetailError("Gagal melakukan reservasi"));
    }
  }

  Future<void> _cancelReservation(
      CancelReservationEvent event, Emitter<BookDetailState> emit) async {
    emit(BookDetailSubmitting());
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString("auth_token");

      await dio.delete(
        "${baseurl}/api/reservations/${event.reservationId}",
        options: Options(headers: {"Authorization": "Bearer $token"}),
      );
    } catch (e) {
      emit(BookDetailError("Gagal membatalkan reservasi"));
    }
  }
}
