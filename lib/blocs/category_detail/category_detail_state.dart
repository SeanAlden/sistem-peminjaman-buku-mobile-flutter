import 'package:equatable/equatable.dart';

abstract class CategoryDetailState extends Equatable {
  @override
  List<Object?> get props => [];
}

class CategoryDetailInitial extends CategoryDetailState {}

class CategoryDetailLoading extends CategoryDetailState {}

class CategoryDetailLoaded extends CategoryDetailState {
  final Map<String, dynamic> category;
  final List<dynamic> books;

  CategoryDetailLoaded({
    required this.category,
    required this.books,
  });

  @override
  List<Object?> get props => [category, books];
}

class CategoryDetailError extends CategoryDetailState {
  final String message;
  CategoryDetailError(this.message);

  @override
  List<Object?> get props => [message];
}
