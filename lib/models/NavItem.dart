import 'package:flutter/material.dart';
import 'package:cttenglish/screens/home/Screens/home/home_screen.dart';
import 'package:cttenglish/screens/home/Screens/profile/profile_screen.dart';
import 'package:cttenglish/screens/home/Screens/dictionary/dictionary_screen.dart';
import 'package:cttenglish/screens/home/Screens/quiz/home.dart';
import 'package:cttenglish/screens/home/Screens/speaking/speaking.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
//import 'package:cttenglish/screens/home/Screens/youtube/main.dart';
import 'package:cttenglish/screens/home/Screens/youtube/test1.dart';

class NavItem {
  final int id;
  final IconData icon;
  final Widget destination;

  NavItem({this.id, this.icon, this.destination});

// If there is no destination then it help us
  bool destinationChecker() {
    if (destination != null) {
      return true;
    }
    return false;
  }
}

// If we made any changes here Provider package rebuid those widget those use this NavItems
class NavItems extends ChangeNotifier {
  // By default first one is selected
  int selectedIndex = 0;

  void chnageNavIndex({int index}) {
    selectedIndex = index;
    // if any changes made it notify widgets that use the value
    notifyListeners();
  }

  List<NavItem> items = [
    NavItem(
      id: 1,
      icon: MdiIcons.home,
      destination: HomeScreen(),
    ),
    NavItem(
      id: 2,
      icon: MdiIcons.googleTranslate,
      destination: DictionaryScreen(),
    ),
    NavItem(
      id: 3,
      icon: MdiIcons.bookOpenPageVariant,
      destination: QuizHomePage(),
    ),
    NavItem(
      id: 4,
      icon: FontAwesomeIcons.comments,
      destination: SpeechScreen(),
    ),
    NavItem(
      id: 5,
      icon: FontAwesomeIcons.youtube,
      destination: VideoPlayerScreen(),
    ),
    NavItem(
      id: 6,
      icon: MdiIcons.faceProfile,
      destination: ProfileScreen(),
    ),
  ];
}
