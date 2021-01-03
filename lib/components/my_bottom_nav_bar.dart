import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:cttenglish/constants.dart';
import 'package:cttenglish/models/NavItem.dart';
import 'package:cttenglish/size_config.dart';

class MyBottomNavBar extends StatelessWidget {
  final Function(int) onTap;

  const MyBottomNavBar({Key key, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double defaultSize = SizeConfig.defaultSize;
    return Consumer<NavItems>(
      builder: (context, navItems, child) => Container(
        padding: EdgeInsets.symmetric(horizontal: defaultSize * 3), //30
        
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              offset: Offset(0, -7),
              blurRadius: 30,
              color: Color(0xFF4B1A39).withOpacity(0.2),
            ),
          ],
        ),
        child: SafeArea(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(
              navItems.items.length,
              (index) => buildIconNavBarItem(
                isActive: navItems.selectedIndex == index ? true : false,
                icon: navItems.items[index].icon,
                press: () {
                  navItems.chnageNavIndex(index: index);
                  
                  if (navItems.items[index].destinationChecker()) {
                    onTap(index);
                    
                  }
                 
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  IconButton buildIconNavBarItem(
      {IconData icon, Function press, bool isActive = false}) {
    return IconButton(
      icon: Icon(icon, color: isActive ? kPrimaryColor : Color(0xFFD1D4D4), size: 22,),
      onPressed: press,
    );
  }
}
