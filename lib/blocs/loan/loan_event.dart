abstract class LoanEvent {}

class FetchLoansEvent extends LoanEvent {}

class RequestReturnEvent extends LoanEvent {
  final int id;
  RequestReturnEvent(this.id);
}

class CancelLoanEvent extends LoanEvent {
  final int id;
  CancelLoanEvent(this.id);
}
