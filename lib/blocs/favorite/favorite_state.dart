import 'package:equatable/equatable.dart';

abstract class FavoriteState extends Equatable {
  @override
  List<Object?> get props => [];
}

class FavoriteInitial extends FavoriteState {}

class FavoriteLoading extends FavoriteState {}

class FavoriteLoaded extends FavoriteState {
  final List<dynamic> books;
  FavoriteLoaded(this.books);

  @override
  List<Object?> get props => [books];
}

class FavoriteError extends FavoriteState {
  final String message;
  FavoriteError(this.message);
  @override
  List<Object?> get props => [message];
}
