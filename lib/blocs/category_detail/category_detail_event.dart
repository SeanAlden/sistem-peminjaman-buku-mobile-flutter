import 'package:equatable/equatable.dart';

abstract class CategoryDetailEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class FetchCategoryDetailEvent extends CategoryDetailEvent {
  final int categoryId;
  FetchCategoryDetailEvent(this.categoryId);

  @override
  List<Object?> get props => [categoryId];
}
