import 'package:flutter/material.dart';

class RoundBoxDecoration extends StatefulWidget {
  final Widget child;
  RoundBoxDecoration({Key key, @required this.child}) : super(key: key);
  @override
  _RoundBoxDecorationState createState() => _RoundBoxDecorationState();
}

class _RoundBoxDecorationState extends State<RoundBoxDecoration> {
  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.symmetric(horizontal: 9, vertical: 0),
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(20.0)),
            color: Colors.white,
            boxShadow: [
              BoxShadow(color: Colors.black.withAlpha(100), blurRadius: 10.0),
            ]),
        child: widget.child);
  }
}
