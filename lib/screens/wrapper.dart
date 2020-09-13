import 'dart:ui';

import 'package:cttenglish/models/user.dart';
import 'package:cttenglish/screens/authenticate/authenticate.dart';
import 'package:cttenglish/screens/home/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatelessWidget {
  Future<bool> kPrecache(List<String> listAssetPath) async {
    await Future.forEach(listAssetPath, (path) async {
      if (path.substring(path.length - 3) == "svg") {
        await precachePicture(
            ExactAssetPicture(SvgPicture.svgStringDecoder, path), null);
      } else {
        //await precacheImage(AssetImage(path), null);
        // await precachePicture(
        //     ExactAssetPicture(PictureInfoDecoder(path), path ), null);
      }

      // await precachePicture(
      //       ExactAssetPicture(SvgPicture.svgStringDecoder, path), null);
    });
    return true;
  }

  Future<bool> loadAssetAuthenticate() async {
    await kPrecache([
      'assets/icons/login.svg',
      'assets/icons/signup.svg',
      'assets/icons/chat.svg'
    ]);
    return true;
  }

  Future<bool> loadAssetHome() async {
    await kPrecache([
      'assets/icons/home.svg',
      'assets/icons/list.svg',
      'assets/icons/camera.svg',
      'assets/icons/chef_nav.svg',
      'assets/icons/user.svg',
      'assets/icons/menu.svg',
      'assets/images/logo.svg',
      'assets/icons/search.svg'
    ]);
    return true;
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);

    // return either the Home or Authenticate widget
    if (user == null) {
      return FutureBuilder<bool>(
          builder: (context, projectSnap) {
            if (projectSnap.data == true)
              return Authenticate();
            else {
              return Text("Loading...");
            }
          },
          future: loadAssetAuthenticate());
    } else {
      return FutureBuilder<bool>(
          builder: (context, projectSnap) {
            if (projectSnap.data == true)
              return Home();
            else {
              return Text("Loading...");
            }
          },
          future: loadAssetHome());
    }
  }
}
