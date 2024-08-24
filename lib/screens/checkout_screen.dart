import 'package:ecommerce_app/bloc/cart/cart_bloc.dart';
import 'package:ecommerce_app/bloc/cart/cart_event.dart';
import 'package:ecommerce_app/bloc/cart/cart_state.dart';
import 'package:ecommerce_app/helper/navigation_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  _CheckoutScreenState createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  final _formKey = GlobalKey<FormState>();
  String? _name;
  String? _address;
  String? _city;
  String? _postalCode;
  String? _state;
  String? _country;
  String? _paymentMethod; // Default payment method
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
    // Start the animation
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submitOrder(double totalPrice, int totalItems) {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      if (_paymentMethod == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.red,
            content: Text(
              'Please enter your payment method',
              style: TextStyle(color: Colors.white),
            ),
          ),
        );
      } else {
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
            // Mock order submission
            if (mounted) {
              context.read<CartBloc>().add(ClearCart());

              // Show confirmation or navigate to a confirmation page
              // Navigate to Confirmation Screen
              CustomNavigationHelper.router
                  .go(CustomNavigationHelper.confirmationPage, extra: {
                "name": _name,
                "address":
                    '$_address, $_city, $_postalCode, $_state, $_country',
                "totalPrice": totalPrice,
                "totalItems": totalItems,
              });
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Order Placed Successfully!')),
              );
            }
          });
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            // Back button functionality
            CustomNavigationHelper.router.pop();
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              TextFormField(
                decoration: const InputDecoration(labelText: 'Name'),
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.text,
                validator: (value) =>
                    value!.isEmpty ? 'Please enter your name' : null,
                onSaved: (value) => _name = value,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Address'),
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.text,
                validator: (value) =>
                    value!.isEmpty ? 'Please enter your address' : null,
                onSaved: (value) => _address = value,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'City'),
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.text,
                validator: (value) =>
                    value!.isEmpty ? 'Please enter your city' : null,
                onSaved: (value) => _city = value,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Postal Code'),
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.text,
                validator: (value) =>
                    value!.isEmpty ? 'Please enter your postal code' : null,
                onSaved: (value) => _postalCode = value,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'State'),
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.text,
                validator: (value) =>
                    value!.isEmpty ? 'Please enter your state' : null,
                onSaved: (value) => _state = value,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Country'),
                textInputAction: TextInputAction.done,
                keyboardType: TextInputType.text,
                validator: (value) =>
                    value!.isEmpty ? 'Please enter your country' : null,
                onSaved: (value) => _country = value,
              ),
              const SizedBox(height: 20),
              const Text(
                'Payment Method',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              RadioListTile<String>(
                title: const Text('Credit Card'),
                value: 'Credit Card',
                groupValue: _paymentMethod,
                onChanged: (value) {
                  setState(() {
                    _paymentMethod = value;
                  });
                },
              ),
              RadioListTile<String>(
                title: const Text('PayPal'),
                value: 'PayPal',
                groupValue: _paymentMethod,
                onChanged: (value) {
                  setState(() {
                    _paymentMethod = value;
                  });
                },
              ),
              RadioListTile<String>(
                title: const Text('Google Pay'),
                value: 'Google Pay',
                groupValue: _paymentMethod,
                onChanged: (value) {
                  setState(() {
                    _paymentMethod = value;
                  });
                },
              ),
              const SizedBox(height: 20),
              BlocBuilder<CartBloc, CartState>(
                builder: (context, state) {
                  if (state is CartLoaded) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          'Total: \$${state.totalPrice}',
                          style: const TextStyle(fontSize: 20),
                        ),
                        const SizedBox(height: 16),
                        GestureDetector(
                          onTap: () {
                            _submitOrder(state.totalPrice, state.totalItems);
                          },
                          child: AnimatedBuilder(
                            animation: _animation,
                            builder: (context, child) {
                              return Transform.scale(
                                scale: 1.0 - (_animation.value * 0.1),
                                child: Container(
                                  height: 50,
                                  decoration: BoxDecoration(
                                    color:
                                        _isLoading ? Colors.grey : Colors.blue,
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  alignment: Alignment.center,
                                  child: _isLoading
                                      ? const CircularProgressIndicator(
                                          color: Colors.white)
                                      : const Text(
                                          'Place Order',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 18),
                                        ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    );
                  } else {
                    return Container();
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
