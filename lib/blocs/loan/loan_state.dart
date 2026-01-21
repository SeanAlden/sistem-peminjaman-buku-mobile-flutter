abstract class LoanState {}

class LoanLoading extends LoanState {}

class LoanLoaded extends LoanState {
  final List loans;
  LoanLoaded(this.loans);
}

class LoanError extends LoanState {
  final String message;
  LoanError(this.message);
}
