import 'package:flutter/material.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            backgroundColor: Colors.white,
            body: SafeArea(
              child: Center(
                child: Text('Route Error: ${settings.name}'),
              ),
            ),
          ),
        );
    }
  }
}
