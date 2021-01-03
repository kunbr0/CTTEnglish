import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cttenglish/screens/home/Screens/reader/reader_screen.dart';
import 'package:cttenglish/screens/home/Screens/quiz/home.dart';
import 'package:cttenglish/screens/home/Screens/reader/Test/reader.dart';

class RoutesGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;

    switch (settings.name) {
      // Reader
      case '/reader':
        if (args is String) {
          debugPrint(args);
          return CupertinoPageRoute(
              //builder: (_) => ReaderScreen(data: args ?? ''));
              builder: (_) => KReader(
                  url: "https://jsonplaceholder.typicode.com/posts" ?? ''));
        } else {
          return _errorRoute();
        }
        break;

      case '/quiz_app':
        return CupertinoPageRoute(builder: (_) => QuizHomePage());

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
