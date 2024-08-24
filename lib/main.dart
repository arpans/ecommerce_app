import 'package:ecommerce_app/bloc/auth/auth_bloc.dart';
import 'package:ecommerce_app/bloc/cart/cart_bloc.dart';
import 'package:ecommerce_app/bloc/category/category_bloc.dart';
import 'package:ecommerce_app/bloc/category/category_event.dart';
import 'package:ecommerce_app/bloc/product/product_bloc.dart';
import 'package:ecommerce_app/core/network_connectivity/connectivity_bloc.dart';
import 'package:ecommerce_app/core/network_connectivity/connectivity_event.dart';
import 'package:ecommerce_app/helper/navigation_helper.dart';
import 'package:ecommerce_app/repositories/cart_repository.dart';
import 'package:ecommerce_app/repositories/category_repository.dart';
import 'package:ecommerce_app/repositories/login_repository.dart';
import 'package:ecommerce_app/repositories/product_repository.dart';
import 'package:ecommerce_app/repositories/registration_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await CustomNavigationHelper.initialize();
  final sharedPreferences = await SharedPreferences.getInstance();
  final cartRepository = CartRepository(sharedPreferences: sharedPreferences);

  runApp(MyApp(cartRepository: cartRepository));
}

class MyApp extends StatelessWidget {
  final CartRepository cartRepository;

  const MyApp({super.key, required this.cartRepository});

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (BuildContext context) {
        return MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (context) => CartBloc(cartRepository: cartRepository),
            ),
            BlocProvider(
              create: (context) => AuthBloc(
                  cartBloc: context.read<CartBloc>(),
                  // Pass the CartBloc to AuthBloc
                  loginRepository: LoginRepository(),
                  registrationRepository: RegistrationRepository()),
            ),
            BlocProvider(
              create: (context) =>
                  CategoryBloc(categoryRepository: CategoryRepository())
                    ..add(FetchCategories()),
            ),
            BlocProvider(
              create: (context) =>
                  ConnectivityBloc()..add(ConnectivityStarted()),
            ),
            BlocProvider(
              create: (context) =>
                  ProductBloc(productRepository: ProductRepository()),
            ),
          ],
          child: MaterialApp.router(
            debugShowCheckedModeBanner: false,
            title: 'E-Commerce App',
            routerConfig: CustomNavigationHelper.router,
          ),
        );
      },
    );
  }
}
