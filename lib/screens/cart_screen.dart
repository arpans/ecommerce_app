import 'package:ecommerce_app/bloc/cart/cart_bloc.dart';
import 'package:ecommerce_app/bloc/cart/cart_event.dart';
import 'package:ecommerce_app/bloc/cart/cart_state.dart';
import 'package:ecommerce_app/helper/navigation_helper.dart';
import 'package:ecommerce_app/models/cart_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen>
    with SingleTickerProviderStateMixin {
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  late AnimationController _controller;
  late Animation<double> _animation;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onCheckoutPressed() {
    setState(() {
      _isLoading = true;
    });
    _controller.forward().then((_) {
      // Simulate a delay for processing
      Future.delayed(const Duration(seconds: 2), () {
        setState(() {
          _isLoading = false;
        });
        _controller.reverse();
        CustomNavigationHelper.router.push(CustomNavigationHelper.checkoutPage);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Shopping Cart'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            // Back button functionality
            CustomNavigationHelper.router.pop();
          },
        ),
        actions: [
          BlocBuilder<CartBloc, CartState>(
            builder: (context, state) {
              // Check if the cart is loaded and has items
              bool showClearIcon =
                  state is CartLoaded && state.items.isNotEmpty;
              return showClearIcon
                  ? IconButton(
                      icon: const Icon(Icons.remove_shopping_cart_outlined),
                      onPressed: () {
                        // Show a confirmation dialog before clearing the cart
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Clear Cart'),
                            content: const Text(
                                'Are you sure you want to clear the cart?'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  CustomNavigationHelper.router.pop();
                                },
                                child: const Text('Cancel'),
                              ),
                              TextButton(
                                onPressed: () {
                                  context.read<CartBloc>().add(ClearCart());
                                  CustomNavigationHelper.router.pop();
                                },
                                child: const Text('Clear'),
                              ),
                            ],
                          ),
                        );
                      },
                    )
                  : Container(); // Return an empty container if the icon should not be displayed
            },
          ),
        ],
      ),
      body: BlocBuilder<CartBloc, CartState>(
        builder: (context, state) {
          if (state is CartLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is CartLoaded) {
            if (state.items.isEmpty) {
              return const Center(child: Text('Your cart is empty'));
            }
            return Column(
              children: [
                Expanded(
                  child: AnimatedList(
                    key: _listKey,
                    initialItemCount: state.items.length,
                    itemBuilder: (context, index, animation) {
                      final item = state.items[index];
                      return _buildCartItem(item, animation);
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text('Total: \$${state.totalPrice}',
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 16),
                      GestureDetector(
                        onTap: _onCheckoutPressed,
                        child: AnimatedBuilder(
                          animation: _animation,
                          builder: (context, child) {
                            return Transform.scale(
                              scale: 1.0 - (_animation.value * 0.1),
                              child: Container(
                                height: 50,
                                decoration: BoxDecoration(
                                  color: _isLoading ? Colors.grey : Colors.blue,
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                alignment: Alignment.center,
                                child: _isLoading
                                    ? const CircularProgressIndicator(
                                        color: Colors.white)
                                    : const Text(
                                        'Proceed to Checkout',
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 18),
                                      ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          } else {
            return const Text('Something went wrong!');
          }
        },
      ),
    );
  }

  Widget _buildCartItem(CartItem? item, Animation<double> animation) {
    return SizeTransition(
      sizeFactor: animation,
      child: Card(
        child: ListTile(
          leading: Image.network(item!.product!.image ?? "",
              height: 50, width: 50, fit: BoxFit.contain),
          title: Text(
            item.product!.title ?? "",
            maxLines: 2,
          ),
          subtitle: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.remove),
                onPressed: () {
                  context.read<CartBloc>().add(DecrementQuantity(item.product));
                },
              ),
              Text('Quantity: ${item.quantity}'),
              IconButton(
                icon: const Icon(Icons.add),
                onPressed: () {
                  context.read<CartBloc>().add(IncrementQuantity(item.product));
                },
              ),
            ],
          ),
          trailing: Text('\$${item.product!.price! * item.quantity!}'),
        ),
      ),
    );
  }
}
