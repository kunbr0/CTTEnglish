import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:cttenglish/screens/home/Screens/home/components/body.dart';
import 'package:cttenglish/size_config.dart';
import 'package:cttenglish/constants.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: buildAppBar(),
      body: Body(),
      // We are not able to BottomNavigationBar because the icon parameter dont except SVG
      // We also use Provied to manage the state of our Nav
      //bottomNavigationBar: MyBottomNavBar(),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      leading: IconButton(
        icon: SvgPicture.asset("assets/icons/menu.svg"),
        onPressed: () {},
      ),
      // On Android by default its false
      centerTitle: true,
      //title: Image.asset("assets/images/logo.png"),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset("assets/images/logo.svg", width: 40),
          SizedBox(width: 10),
          Text(
            'CTT English', style: 
            TextStyle(
              color: kTextColor
            ),
          )
        ],
      ),
      actions: <Widget>[
        IconButton(
          icon: SvgPicture.asset("assets/icons/search.svg"),
          onPressed: () {},
        ),
        SizedBox(
          // It means 5 because by out defaultSize = 10
          width: SizeConfig.defaultSize * 0.5,
        )
      ],
    );
  }
}
