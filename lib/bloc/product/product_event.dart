import 'package:equatable/equatable.dart';

abstract class ProductEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class FetchProducts extends ProductEvent {
  final String category;

  FetchProducts(this.category);

  @override
  List<Object?> get props => [category];
}

