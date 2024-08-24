import 'package:ecommerce_app/models/cart_item.dart';
import 'package:equatable/equatable.dart';

abstract class CartState extends Equatable {
  const CartState();

  @override
  List<Object?> get props => [];
}

class CartLoading extends CartState {}

class CartLoaded extends CartState {
  final List<CartItem> items;

  const CartLoaded({this.items = const <CartItem>[]});

  int get totalItems =>
      items.fold(0, (total, current) => total + current.quantity!);

  double get totalPrice => items.fold(0,
      (total, current) => total + current.product!.price! * current.quantity!);

  @override
  List<Object?> get props => [items];
}


class CartError extends CartState {}
