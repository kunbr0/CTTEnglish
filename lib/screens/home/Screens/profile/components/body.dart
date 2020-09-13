import 'package:flutter/material.dart';
import 'package:cttenglish/size_config.dart';
import 'package:cttenglish/services/auth.dart';

import 'info.dart';
import 'profile_menu_item.dart';

class Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          Info(
            image: "assets/images/tangkhanhchuong_ava.jpg",
            name: "Tang Khanh Chuong",
            email: "chuongtangkhanh@gmail.com",
          ),
          SizedBox(height: SizeConfig.defaultSize * 2), //20
          ProfileMenuItem(
            iconSrc: "assets/icons/bookmark_fill.svg",
            title: "Saved words",
            press: () {},
          ),
          ProfileMenuItem(
            iconSrc: "assets/icons/chef_color.svg",
            title: "Achivements",
            press: () {},
          ),
          ProfileMenuItem(
            iconSrc: "assets/icons/language.svg",
            title: "Translator",
            press: () {},
          ),
          ProfileMenuItem(
            iconSrc: "assets/icons/info.svg",
            title: "Logout",
            press:  () async {
                      await AuthService.signOut();
                    },
          ),
        ],
      ),
    );
  }
}
