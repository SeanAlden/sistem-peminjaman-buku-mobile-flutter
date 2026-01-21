// lib/bloc/book/book_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'book_event.dart';
import 'book_state.dart';
import '../../repositories/book_repository.dart';

class BookBloc extends Bloc<BookEvent, BookState> {
  final BookRepository repository;

  BookBloc(this.repository) : super(BookInitial()) {
    on<FetchBooksEvent>(_onFetchBooks);
  }

  Future<void> _onFetchBooks(FetchBooksEvent event, Emitter<BookState> emit) async {
    emit(BookLoading());
    try {
      final books = await repository.fetchBooks();
      emit(BookLoaded(books));
    } catch (e) {
      emit(BookError(e.toString()));
    }
  }
}
