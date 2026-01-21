// lib/bloc/favorite/favorite_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'favorite_event.dart';
import 'favorite_state.dart';
import '../../repositories/favorite_repository.dart';

class FavoriteBloc extends Bloc<FavoriteEvent, FavoriteState> {
  final FavoriteRepository repository;

  FavoriteBloc(this.repository) : super(FavoriteInitial()) {
    on<FetchFavoritesEvent>(_onFetchFavorites);
    on<ToggleFavoriteEvent>(_onToggleFavorite);
  }

  // Future<void> _onFetchFavorites(FetchFavoritesEvent event, Emitter<FavoriteState> emit) async {
  //   emit(FavoriteLoading());
  //   try {
  //     final favs = await repository.fetchFavorites();
  //     // backend returns book objects; convert to list of ids
  //     final ids = favs.map<int>((b) => (b['id'] as num).toInt()).toList();
  //     emit(FavoriteLoaded(ids));
  //   } catch (e) {
  //     emit(FavoriteError(e.toString()));
  //   }
  // }

  Future<void> _onFetchFavorites(
    FetchFavoritesEvent event,
    Emitter<FavoriteState> emit,
  ) async {
    emit(FavoriteLoading());
    try {
      final favs = await repository.fetchFavorites();
      emit(FavoriteLoaded(favs)); // ⬅️ SIMPAN FULL DATA
    } catch (e) {
      emit(FavoriteError(e.toString()));
    }
  }

  Future<void> _onToggleFavorite(
      ToggleFavoriteEvent event, Emitter<FavoriteState> emit) async {
    final currentState = state;
    List<int> ids = [];
    if (currentState is FavoriteLoaded)
      // ids = List<int>.from(currentState.favoriteBookIds);
      ids = List<int>.from(currentState.books);

    try {
      await repository.toggleFavorite(event.bookId,
          currentlyFavorited: event.currentlyFavorited);

      // Update local list optimistically
      if (event.currentlyFavorited) {
        ids.remove(event.bookId);
      } else {
        ids.add(event.bookId);
      }
      emit(FavoriteLoaded(List<int>.from(ids)));
    } catch (e) {
      // keep previous state and emit error optionally
      emit(FavoriteError(e.toString()));
      // revert to previous if available
      if (currentState is FavoriteLoaded) emit(currentState);
    }
  }
}
