import 'package:flutter/material.dart';
import 'package:cttenglish/widgets/cache_image.dart';

class Background extends StatelessWidget {
  final Widget child;
  const Background({
    Key key,
    @required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      height: size.height,
      width: double.infinity,
      // Here i can use size.width but use double.infinity because both work as a same
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Positioned(
            top: 0,
            left: 0,
            child: CustomCacheImage(url: "assets/images/signup_top.png"),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            child: CustomCacheImage(url: "assets/images/main_bottom.png"),
          ),
          child,
        ],
      ),
    );
  }
}
