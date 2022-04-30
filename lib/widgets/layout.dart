import 'package:flutter/material.dart';

class AppLayout extends StatelessWidget {
  const AppLayout({Key? key, required this.child}) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
          child: child,
        ),
      ),
    );
  }
}
