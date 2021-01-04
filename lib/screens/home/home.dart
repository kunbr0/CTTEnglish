import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cttenglish/models/NavItem.dart';
import 'package:cttenglish/components/my_bottom_nav_bar.dart';
import 'package:cttenglish/screens/home/Screens/routes_push.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedIndex = 0;

  final List<Widget> _screens = NavItems().items.map((e) {
    return e.destination;
  }).toList();

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => NavItems(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: '/',
        onGenerateRoute: RoutesGenerator.generateRoute,
        title: 'Recipe App',
        theme: ThemeData(
          // backgroundColor: Colors.white,
          scaffoldBackgroundColor: Colors.white,
          // We apply this to our appBarTheme because most of our appBar have this style
          appBarTheme: AppBarTheme(color: Colors.white, elevation: 0),
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: DefaultTabController(
          length: 5,
          child: Scaffold(
              resizeToAvoidBottomInset: false,
              body: IndexedStack(
                index: _selectedIndex,
                children: _screens,
              ),
              bottomNavigationBar: Padding(
                  padding: const EdgeInsets.only(bottom: 0.0),
                  child: MyBottomNavBar(
                    onTap: (index) => setState(() => _selectedIndex = index),
                  ))),
        ),
      ),
    );
  }
}
