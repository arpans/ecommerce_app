import 'dart:io';

import 'package:ecommerce_app/bloc/auth/auth_bloc.dart';
import 'package:ecommerce_app/bloc/auth/auth_event.dart';
import 'package:ecommerce_app/bloc/auth/auth_state.dart';
import 'package:ecommerce_app/bloc/cart/cart_bloc.dart';
import 'package:ecommerce_app/bloc/cart/cart_event.dart';
import 'package:ecommerce_app/bloc/cart/cart_state.dart';
import 'package:ecommerce_app/bloc/category/category_bloc.dart';
import 'package:ecommerce_app/bloc/category/category_event.dart';
import 'package:ecommerce_app/bloc/category/category_state.dart';
import 'package:ecommerce_app/bloc/product/product_bloc.dart';
import 'package:ecommerce_app/bloc/product/product_event.dart';
import 'package:ecommerce_app/bloc/product/product_state.dart';
import 'package:ecommerce_app/core/network_connectivity/connectivity_bloc.dart';
import 'package:ecommerce_app/core/network_connectivity/connectivity_state.dart';
import 'package:ecommerce_app/helper/navigation_helper.dart';
import 'package:ecommerce_app/models/product.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  bool isConnected = true;

  @override
  void initState() {
    super.initState();
  }

  Widget _buildCategoryFilter(BuildContext context, CategoryLoaded state) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      height: 50.0,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: state.categories.length,
        itemBuilder: (ctx, index) {
          if (state.selectedCategory != null) {
            context
                .read<ProductBloc>()
                .add(FetchProducts(state.selectedCategory!));
          }
          return _buildCategoryChip(
              context, state, index, state.categories[index]);
        },
      ),
    );
  }

  Widget _buildCategoryChip(
      BuildContext context, CategoryLoaded state, int index, String category) {
    final category = state.categories[index];
    final isSelected = category == state.selectedCategory;
    return GestureDetector(
      onTap: () {
        // Dispatch the SelectCategory event
        context.read<CategoryBloc>().add(SelectCategory(category));
        // Fetch products for the selected category
        isConnected
            ? context.read<ProductBloc>().add(FetchProducts(category))
            : const SnackBar(
                content: Text(
                    'No internet connection. Please check your network settings.'),
                backgroundColor: Colors.red,
              );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4.0),
        child: Chip(
          label: Text(
            category.toUpperCase(),
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.black,
            ),
          ),
          backgroundColor: isSelected ? Colors.blue : Colors.grey[300],
        ),
      ),
    );
  }

  Widget _buildProductCard(BuildContext context, Product product) {
    return Card(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.network(product.image ?? "",
              height: 100, width: double.infinity, fit: BoxFit.contain),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              product.title ?? "",
              overflow: TextOverflow.ellipsis,
              maxLines: Platform.isAndroid ? 1 : 3,
              style: TextStyle(
                fontSize: Platform.isAndroid ? 14.0 : 16.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              '\$${product.price}',
              style: const TextStyle(fontSize: 16.0),
            ),
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: () {
                context.read<CartBloc>().add(AddProduct(product));
              },
              child: const Text('Add to Cart'),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ConnectivityBloc, ConnectivityState>(
      listener: (context, state) {
        if (state is ConnectivityLoadSuccess) {
          if (state.isConnected == false) {
            setState(() {
              isConnected = false;
            });
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                    'No internet connection. Please check your network settings.'),
                backgroundColor: Colors.red,
              ),
            );
          } else {
            setState(() {
              isConnected = true;
            });
          }
        }
      },
      child: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          if (state is AuthLoggedOut) {
            // Navigate to the login page when logged out
            // CustomNavigationHelper.router.pop();
            Future.microtask(() {
              CustomNavigationHelper.router
                  .go(CustomNavigationHelper.loginPath);
            });
          }
          return Scaffold(
            appBar: AppBar(
              title: const Text('Product Listing'),
              actions: [
                IconButton(
                  icon: const Icon(Icons.logout),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Logout'),
                        content: const Text('Are you sure you want to logout?'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              CustomNavigationHelper.router.pop();
                            },
                            child: const Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () async {
                              SharedPreferences prefs =
                                  await SharedPreferences.getInstance();
                              prefs.setString("token", "");
                              prefs.clear();
                              if (context.mounted) {
                                context.read<AuthBloc>().add(Logout());
                              }
                              CustomNavigationHelper.router.pop();
                            },
                            child: const Text('Yes'),
                          ),
                        ],
                      ),
                    );
                  },
                ),
                BlocBuilder<CartBloc, CartState>(
                  builder: (context, state) {
                    int itemCount = 0;
                    if (state is CartLoaded) {
                      itemCount = state.items.length;
                    }
                    return Stack(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.shopping_cart),
                          onPressed: () {
                            CustomNavigationHelper.router
                                .push(CustomNavigationHelper.cartPage);
                          },
                        ),
                        if (itemCount > 0)
                          Positioned(
                            right: 8,
                            top: 8,
                            child: Container(
                              padding: const EdgeInsets.all(2),
                              decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              constraints: const BoxConstraints(
                                minWidth: 18,
                                minHeight: 18,
                              ),
                              child: Text(
                                '$itemCount',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                      ],
                    );
                  },
                ),
              ],
            ),
            body: Column(
              children: [
                BlocBuilder<CategoryBloc, CategoryState>(
                  builder: (context, state) {
                    if (state is CategoryLoading) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    } else if (state is CategoryLoaded) {
                      return _buildCategoryFilter(context, state);
                    } else if (state is CategoryError) {
                      return Center(child: Text(state.message));
                    }

                    return const Center(child: Text('No categories available'));
                  },
                ),
                Expanded(
                  child: BlocBuilder<ProductBloc, ProductState>(
                    builder: (context, state) {
                      if (state is ProductLoading) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      } else if (state is ProductLoaded) {
                        return GridView.builder(
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 3 / 4,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                          ),
                          itemCount: state.products.length,
                          itemBuilder: (context, index) {
                            final product = state.products[index];
                            return GestureDetector(
                              onTap: () {
                                CustomNavigationHelper.router.push(
                                  CustomNavigationHelper.productDetails,
                                  extra: {
                                    'productList': state.products,
                                    'product': product,
                                  },
                                );
                              },
                              child: Hero(
                                tag: product.id ?? 0,
                                child: _buildProductCard(context, product),
                              ),
                            );
                          },
                        );
                      } else if (state is ProductError) {
                        return Center(
                          child: Text(state.message),
                        );
                      }
                      return const Center(
                        child: Text('Select a category to view products'),
                      );
                    },
                  ),
                ),
                if (!isConnected)
                  const Padding(
                    padding: EdgeInsets.only(top: 16.0),
                    child: Text(
                      'Please connect to the internet to log in.',
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
