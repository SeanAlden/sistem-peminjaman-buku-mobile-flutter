abstract class BookDetailEvent {}

class FetchBookDetailEvent extends BookDetailEvent {
  final int bookId;
  FetchBookDetailEvent(this.bookId);
}

class LoanBookEvent extends BookDetailEvent {
  final int bookId;
  LoanBookEvent(this.bookId);
}

class ReserveBookEvent extends BookDetailEvent {
  final int bookId;
  ReserveBookEvent(this.bookId);
}

class CancelReservationEvent extends BookDetailEvent {
  final int reservationId;
  CancelReservationEvent(this.reservationId);
}
