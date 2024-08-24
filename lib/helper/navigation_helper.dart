import 'package:ecommerce_app/models/product.dart';
import 'package:ecommerce_app/screens/cart_screen.dart';
import 'package:ecommerce_app/screens/checkout_screen.dart';
import 'package:ecommerce_app/screens/confirmation_screen.dart';
import 'package:ecommerce_app/screens/login_screen.dart';
import 'package:ecommerce_app/screens/product_detail_screen.dart';
import 'package:ecommerce_app/screens/product_list_screen.dart';
import 'package:ecommerce_app/screens/signup_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CustomNavigationHelper {
  static final CustomNavigationHelper _instance =
      CustomNavigationHelper._internal();

  static CustomNavigationHelper get instance => _instance;
  static late final GoRouter router;

  static final GlobalKey<NavigatorState> _rootNavigatorKey =
      GlobalKey<NavigatorState>();

  static const String loginPath = '/signin';
  static const String signupPath = '/signup';
  static const String productListing = '/productListing';
  static const String productDetails = '/productDetails';
  static const String cartPage = '/cartPage';
  static const String checkoutPage = '/checkoutPage';
  static const String confirmationPage = '/confirmationPage';

  factory CustomNavigationHelper() {
    return _instance;
  }

  Future<String> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token') ?? '';
    return token;
  }

  CustomNavigationHelper._internal();

  static Future<void> initialize() async {
    var token = await _instance.getToken();
    // print('token in helper:::: $token +++++ ${token.length}');
    var routerConfigVal = loginPath;
    if (token.isEmpty) {
      routerConfigVal = loginPath;
    } else {
      routerConfigVal = productListing;
    }
    router = GoRouter(
      navigatorKey: _rootNavigatorKey,
      initialLocation: routerConfigVal,
      debugLogDiagnostics: true,
      routes: <RouteBase>[
        GoRoute(
          parentNavigatorKey: _rootNavigatorKey,
          path: loginPath,
          pageBuilder: (context, state) {
            return getPage(
              child: const LoginScreen(),
              state: state,
            );
          },
        ),
        GoRoute(
          parentNavigatorKey: _rootNavigatorKey,
          path: signupPath,
          pageBuilder: (context, state) {
            return getPage(
              child: const SignupScreen(),
              state: state,
            );
          },
        ),
        GoRoute(
          parentNavigatorKey: _rootNavigatorKey,
          path: productListing,
          pageBuilder: (context, state) {
            return getPage(
              child: const ProductListScreen(),
              state: state,
            );
          },
        ),
        GoRoute(
          parentNavigatorKey: _rootNavigatorKey,
          path: productDetails,
          pageBuilder: (context, state) {
            final extraData = state.extra as Map<String, dynamic>;
            final List<Product> productList =
                extraData['productList'] as List<Product>;
            final Product product = extraData['product'] as Product;

            // final Product product = state.extra as Product;
            // final List<Product> productList = state.extra as List<Product>;
            return getPage(
              child: ProductDetailScreen(
                product: product,
                productList: productList,
              ),
              state: state,
            );
          },
        ),
        GoRoute(
          parentNavigatorKey: _rootNavigatorKey,
          path: cartPage,
          pageBuilder: (context, state) {
            return getPage(
              child: const CartScreen(),
              state: state,
            );
          },
        ),
        GoRoute(
          parentNavigatorKey: _rootNavigatorKey,
          path: checkoutPage,
          pageBuilder: (context, state) {
            return getPage(
              child: const CheckoutScreen(),
              state: state,
            );
          },
        ),
        GoRoute(
          parentNavigatorKey: _rootNavigatorKey,
          path: confirmationPage,
          pageBuilder: (context, state) {
            final Map<String, dynamic> params =
                state.extra as Map<String, dynamic>;
            return getPage(
              child: ConfirmationScreen(
                totalPrice: params["totalPrice"],
                totalItems: params["totalItems"],
                name: params["name"],
                address: params["address"],
              ),
              state: state,
            );
          },
        ),
        // GoRoute(
        //   parentNavigatorKey: _rootNavigatorKey,
        //   path: otpPath,
        //   pageBuilder: (context, state) {
        //     final Map<String, dynamic> params = state.extra as Map<String, dynamic>;
        //     return getPage(
        //       child: OTPPage(
        //         email: params['emailId'] ?? '',
        //       ),
        //       state: state,
        //     );
        //   },
        // ),
      ],
    );
  }

  static Page getPage({
    required Widget child,
    required GoRouterState state,
  }) {
    return MaterialPage(
      key: state.pageKey,
      child: child,
    );
  }
}
