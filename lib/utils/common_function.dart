import 'package:ecommerce_app/helper/navigation_helper.dart';
import 'package:flutter/material.dart';

BuildContext? get ctx =>
    CustomNavigationHelper.router.routerDelegate.navigatorKey.currentContext;

bool isValidEmail(String val) => !RegExp(r'^(([^<>()[\]\\.,;:\s@"]+(\.[^<>()[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$').hasMatch(val);

void showToastMessage(BuildContext context, bool isSuccess, String? message,
    {Color? color, Color? textColor}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        message ?? "",
        style: TextStyle(color: textColor ?? Colors.white),
      ),
      backgroundColor: color ?? (isSuccess ? Colors.green : Colors.red),
    ),
  );
}
