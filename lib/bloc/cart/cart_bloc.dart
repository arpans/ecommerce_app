import 'package:ecommerce_app/bloc/cart/cart_event.dart';
import 'package:ecommerce_app/bloc/cart/cart_state.dart';
import 'package:ecommerce_app/models/cart_item.dart';
import 'package:ecommerce_app/repositories/cart_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  final CartRepository cartRepository;

  CartBloc({required this.cartRepository}) : super(CartLoading()) {
    on<LoadCart>(_onLoadCart);
    on<AddProduct>(_onAddProduct);
    on<RemoveProduct>(_onRemoveProduct);
    on<IncrementQuantity>(_onIncrementQuantity);
    on<DecrementQuantity>(_onDecrementQuantity);
    on<ClearCart>(_onClearCart);

    add(LoadCart()); // Load the cart items when the bloc is created
  }

  void _onLoadCart(LoadCart event, Emitter<CartState> emit) async {
    emit(CartLoading());
    try {
      final items = cartRepository.loadCartItems();
      emit(CartLoaded(items: items));
    } catch (_) {
      emit(CartError());
    }
  }

  void _onAddProduct(AddProduct event, Emitter<CartState> emit) {
    if (state is CartLoaded) {
      final state = this.state as CartLoaded;

      List<CartItem> items = List.from(state.items);
      int index =
          items.indexWhere((item) => item.product!.id == event.product!.id);

      if (index != -1) {
        items[index] =
            items[index].copyWith(quantity: items[index].quantity! + 1);
      } else {
        items.add(CartItem(product: event.product, quantity: 1));
      }

      cartRepository.saveCartItems(items); // Save to local storage
      emit(CartLoaded(items: items));
    }
  }

  void _onRemoveProduct(RemoveProduct event, Emitter<CartState> emit) {
    if (state is CartLoaded) {
      final state = this.state as CartLoaded;

      List<CartItem> items = List.from(state.items);
      int index =
          items.indexWhere((item) => item.product!.id == event.product!.id);

      if (index != -1) {
        if (items[index].quantity! > 1) {
          items[index] =
              items[index].copyWith(quantity: items[index].quantity! - 1);
        } else {
          items.removeAt(index);
        }

        cartRepository.saveCartItems(items); // Save to local storage
        emit(CartLoaded(items: items));
      }
    }
  }

  void _onIncrementQuantity(IncrementQuantity event, Emitter<CartState> emit) {
    if (state is CartLoaded) {
      final state = this.state as CartLoaded;
      List<CartItem> items = List.from(state.items);
      int index =
          items.indexWhere((item) => item.product!.id == event.product!.id);

      if (index != -1) {
        items[index] =
            items[index].copyWith(quantity: items[index].quantity! + 1);
        cartRepository.saveCartItems(items); // Save to local storage
        emit(CartLoaded(items: items));
      }
    }
  }

  void _onDecrementQuantity(DecrementQuantity event, Emitter<CartState> emit) {
    if (state is CartLoaded) {
      final state = this.state as CartLoaded;
      List<CartItem> items = List.from(state.items);
      int index =
          items.indexWhere((item) => item.product!.id == event.product!.id);

      if (index != -1) {
        if (items[index].quantity! > 1) {
          items[index] =
              items[index].copyWith(quantity: items[index].quantity! - 1);
        } else {
          items.removeAt(index);
        }
        cartRepository.saveCartItems(items); // Save to local storage
        emit(CartLoaded(items: items));
      }
    }
  }

  void _onClearCart(ClearCart event, Emitter<CartState> emit) {
    cartRepository.clearCart(); // Clear local storage
    emit(const CartLoaded(items: []));
  }
}
