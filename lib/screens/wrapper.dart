import 'package:flutter/material.dart';
import './on_board.dart';

class Wrapper extends StatefulWidget {
  @override
  _WrapperState createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  @override
  Widget build(BuildContext context) {
    return OnBoardScreen(context: context);
  }
}
