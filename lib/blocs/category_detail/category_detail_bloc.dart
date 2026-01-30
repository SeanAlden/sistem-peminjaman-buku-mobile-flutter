import 'dart:async';
import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:sistem_peminjaman_buku_mobile_app/const/api_url.dart';

import 'category_detail_event.dart';
import 'category_detail_state.dart';

class CategoryDetailBloc extends Bloc<CategoryDetailEvent, CategoryDetailState> {
  CategoryDetailBloc() : super(CategoryDetailInitial()) {
    on<FetchCategoryDetailEvent>(_onFetchCategoryDetail);
  }

  Future<void> _onFetchCategoryDetail(
      FetchCategoryDetailEvent event, Emitter<CategoryDetailState> emit) async {
    emit(CategoryDetailLoading());

    final url = Uri.parse('${baseurl}/api/categories/${event.categoryId}');

    try {
      final res = await http.get(url);

      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);

        if (data['success'] == true) {
          emit(CategoryDetailLoaded(
            category: data['data'],
            books: data['data']['books'] ?? [],
          ));
        } else {
          emit(CategoryDetailError(data['message'] ?? 'Failed to load category.'));
        }
      } else {
        emit(CategoryDetailError('Server error ${res.statusCode}'));
      }
    } catch (e) {
      emit(CategoryDetailError('Error: $e'));
    }
  }
}
