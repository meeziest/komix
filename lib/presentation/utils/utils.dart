import 'package:flutter/material.dart';

class Utils {
  static void clearRouteStack(BuildContext context) {
    while (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
    }
  }
}
