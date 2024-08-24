import 'package:ecommerce_app/bloc/auth/auth_bloc.dart';
import 'package:ecommerce_app/bloc/auth/auth_event.dart';
import 'package:ecommerce_app/bloc/auth/auth_state.dart';
import 'package:ecommerce_app/constants.dart';
import 'package:ecommerce_app/core/network_connectivity/connectivity_bloc.dart';
import 'package:ecommerce_app/core/network_connectivity/connectivity_state.dart';
import 'package:ecommerce_app/helper/navigation_helper.dart';
import 'package:ecommerce_app/utils/common_function.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  final _formKey = GlobalKey<FormState>();
  String? _userName;
  String? _emailAddress;
  String? _password;
  bool isConnected = true;
  bool _isLoading = false;

  void _onRegistrationPressed() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
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
          if (mounted) {
            context
                .read<AuthBloc>()
                .add(SignupEvent(_userName!, _emailAddress!, _password!));
          }
        });
      });
    }
  }

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Signup')),
      body: BlocListener<ConnectivityBloc, ConnectivityState>(
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
        child: BlocConsumer<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is AuthAuthenticated) {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content: Text('Registered Successfully'),
              ));
              _controller.reverse();
              CustomNavigationHelper.router
                  .go(CustomNavigationHelper.loginPath);
            } else if (state is AuthError) {
              _controller.reverse();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                ),
              );
            }
          },
          builder: (context, state) {
            if (state is AuthLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Username',
                        prefixIcon: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: defaultPadding * 0.75),
                          child: SvgPicture.asset(
                            "assets/icons/message.svg",
                            height: 24,
                            width: 24,
                            colorFilter: ColorFilter.mode(
                                Theme.of(context)
                                    .textTheme
                                    .bodyLarge!
                                    .color!
                                    .withOpacity(0.3),
                                BlendMode.srcIn),
                          ),
                        ),
                      ),
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.text,
                      validator: (value) =>
                          value!.isEmpty ? 'Please enter your username' : null,
                      onSaved: (value) => _userName = value,
                    ),
                    const SizedBox(height: defaultPadding),
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Email Address',
                        prefixIcon: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: defaultPadding * 0.75),
                          child: SvgPicture.asset(
                            "assets/icons/message.svg",
                            height: 24,
                            width: 24,
                            colorFilter: ColorFilter.mode(
                                Theme.of(context)
                                    .textTheme
                                    .bodyLarge!
                                    .color!
                                    .withOpacity(0.3),
                                BlendMode.srcIn),
                          ),
                        ),
                      ),
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) => value!.isEmpty
                          ? 'Please enter your email address'
                          : isValidEmail(value)
                              ? 'Email Address is not valid'
                              : null,
                      onSaved: (value) => _emailAddress = value,
                    ),
                    const SizedBox(height: defaultPadding),
                    TextFormField(
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: "Password",
                        prefixIcon: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: defaultPadding * 0.75),
                          child: SvgPicture.asset(
                            "assets/icons/lock.svg",
                            height: 24,
                            width: 24,
                            colorFilter: ColorFilter.mode(
                                Theme.of(context)
                                    .textTheme
                                    .bodyLarge!
                                    .color!
                                    .withOpacity(0.3),
                                BlendMode.srcIn),
                          ),
                        ),
                      ),
                      validator: (value) =>
                          value!.isEmpty ? 'Please enter your password' : null,
                      onSaved: (value) => _password = value,
                    ),
                    const SizedBox(height: 20),
                    GestureDetector(
                      onTap: () {
                        isConnected
                            ? _onRegistrationPressed()
                            : ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                      'No internet connection. Please check your network settings.'),
                                  backgroundColor: Colors.red,
                                ),
                              );
                      },
                      child: AnimatedBuilder(
                        animation: _animation,
                        builder: (context, child) {
                          return Transform.scale(
                            scale: 1.0 - (_animation.value * 0.1),
                            child: Container(
                              height: 50,
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                color: _isLoading ? Colors.grey : Colors.blue,
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              alignment: Alignment.center,
                              child: _isLoading
                                  ? const CircularProgressIndicator(
                                      color: Colors.white)
                                  : const Text(
                                      'Signup',
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 18),
                                    ),
                            ),
                          );
                        },
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        CustomNavigationHelper.router
                            .go(CustomNavigationHelper.loginPath);
                      },
                      child: const Text('Already have an account? Login'),
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
              ),
            );
          },
        ),
      ),
    );
  }
}
