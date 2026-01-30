import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sistem_peminjaman_buku_mobile_app/blocs/loan/loan_event.dart';
import 'package:sistem_peminjaman_buku_mobile_app/blocs/loan/loan_state.dart';
import 'package:sistem_peminjaman_buku_mobile_app/const/api_url.dart';

class LoanBloc extends Bloc<LoanEvent, LoanState> {
  final Dio dio;

  LoanBloc(this.dio) : super(LoanLoading()) {
    on<FetchLoansEvent>(_fetch);
    on<RequestReturnEvent>(_requestReturn);
    on<CancelLoanEvent>(_cancel);
  }

  Future<void> _fetch(FetchLoansEvent event, Emitter<LoanState> emit) async {
    emit(LoanLoading());

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString("auth_token");
      final res = await dio.get(
        "${baseurl}/api/loans",
        options: Options(headers: {"Authorization": "Bearer $token"}),
      );
      emit(LoanLoaded(res.data['data']));
    } catch (e) {
      emit(LoanError("Gagal mengambil data peminjaman"));
    }
  }

  Future<void> _requestReturn(
      RequestReturnEvent event, Emitter<LoanState> emit) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString("auth_token");
      await dio.post(
        "${baseurl}/api/loans/${event.id}/request-return",
        options: Options(headers: {"Authorization": "Bearer $token"}),
      );

      add(FetchLoansEvent());
    } catch (e) {
      emit(LoanError("Gagal meminta pengembalian"));
    }
  }

  Future<void> _cancel(CancelLoanEvent event, Emitter<LoanState> emit) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString("auth_token");
      await dio.delete(
        "${baseurl}/api/loans/${event.id}",
        options: Options(headers: {"Authorization": "Bearer $token"}),
      );

      add(FetchLoansEvent());
    } catch (e) {
      emit(LoanError("Gagal membatalkan peminjaman"));
    }
  }
}
