// lib/bloc/favorite/favorite_event.dart
import 'package:equatable/equatable.dart';

abstract class FavoriteEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class FetchFavoritesEvent extends FavoriteEvent {}

class ToggleFavoriteEvent extends FavoriteEvent {
  final int bookId;
  final bool currentlyFavorited;
  ToggleFavoriteEvent({required this.bookId, required this.currentlyFavorited});
  @override
  List<Object?> get props => [bookId, currentlyFavorited];
}
