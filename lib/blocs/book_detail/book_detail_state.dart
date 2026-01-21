abstract class BookDetailState {}

class BookDetailInitial extends BookDetailState {}

class BookDetailLoading extends BookDetailState {}

class BookDetailLoaded extends BookDetailState {
  final Map<String, dynamic> data;
  BookDetailLoaded(this.data);
}

class BookDetailError extends BookDetailState {
  final String message;
  BookDetailError(this.message);
}

class BookDetailSubmitting extends BookDetailState {}
