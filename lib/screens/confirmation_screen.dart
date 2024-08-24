import 'package:ecommerce_app/helper/navigation_helper.dart';
import 'package:flutter/material.dart';

class ConfirmationScreen extends StatefulWidget {
  final double? totalPrice;
  final int? totalItems;
  final String? name;
  final String? address;

  const ConfirmationScreen({
    super.key,
    this.totalPrice,
    this.totalItems,
    this.name,
    this.address,
  });

  @override
  State<ConfirmationScreen> createState() => _ConfirmationScreenState();
}

class _ConfirmationScreenState extends State<ConfirmationScreen>
    with SingleTickerProviderStateMixin {
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
    // Start the animation
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onSubmitPressed() {
    setState(() {
      _isLoading = true;
    });
    _controller.forward().then((_) {
      // Simulate a delay for processing
      Future.delayed(const Duration(milliseconds: 500), () {
        setState(() {
          _isLoading = false;
        });
        _controller.reverse();
        CustomNavigationHelper.router.go(CustomNavigationHelper.dashboardPath);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Order Confirmation'),
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Thank you for your order!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const Text(
              'Order Summary:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text('Total Items: ${widget.totalItems}'),
            Text('Total Price: \$${widget.totalPrice!.toStringAsFixed(2)}'),
            const SizedBox(height: 16),
            const Text(
              'Shipping Information:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text('Name: ${widget.name}'),
            Text('Address: ${widget.address}'),
            const Spacer(),
            GestureDetector(
              onTap: () {
                _onSubmitPressed();
              },
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
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text(
                              'Back to Product Listing',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 18),
                            ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
