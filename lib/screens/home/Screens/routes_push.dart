import 'package:flutter/material.dart';
import 'package:cttenglish/screens/home/Screens/reader/reader_screen.dart';

class RoutesGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;

    switch (settings.name) {
      // Reader
      case '/reader':
        if (args is String) {
          return MaterialPageRoute(builder: (_) => ReaderScreen(data: args));
        }
        return _errorRoute();
      
      // Default
      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Error Title'),
        ),
        body: Center(
          child: Text("Error Body"),
        ),
      );
    });
  }
}
