import 'package:equatable/equatable.dart';
import 'product.dart';

class CartItem extends Equatable {
  final Product? product;
  final int? quantity;

  const CartItem({
    this.product,
    this.quantity,
  });

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      product: Product.fromJson(json['product']),
      quantity: json['quantity'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'product': product?.toJson(),
      'quantity': quantity,
    };
  }

  CartItem copyWith({Product? product, int? quantity}) {
    return CartItem(
      product: product ?? this.product,
      quantity: quantity ?? this.quantity,
    );
  }

  @override
  List<Object?> get props => [product, quantity];
}
