import 'package:flutter/material.dart';

class CustomNavigatorObserver extends NavigatorObserver {
  final VoidCallback onPop;

  CustomNavigatorObserver({required this.onPop});

  @override
  void didPop(Route route, Route? previousRoute) {
    super.didPop(route, previousRoute);
    onPop();
  }
}
