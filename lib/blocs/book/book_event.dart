// lib/bloc/book/book_event.dart
import 'package:equatable/equatable.dart';

abstract class BookEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class FetchBooksEvent extends BookEvent {}
