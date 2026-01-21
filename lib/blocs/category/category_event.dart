// lib/bloc/category/category_event.dart
import 'package:equatable/equatable.dart';

abstract class CategoryEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class FetchCategoriesEvent extends CategoryEvent {}
