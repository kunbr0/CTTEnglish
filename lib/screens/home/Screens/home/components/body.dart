import 'package:flutter/material.dart';
import 'package:cttenglish/models/RecipeBundel.dart';
import 'package:cttenglish/size_config.dart';
import 'package:flutter/rendering.dart';

import 'categories.dart';
import 'recipe_bundel_card.dart';
import './Categories/NewspaperView.dart';


class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}


class _BodyState extends State<Body> {

  int selectedCategoryIndex = 0;
  
  void changeCategoryIndex(int index){
    setState(() {
      selectedCategoryIndex = index;
    });
  }


  Widget switchCategory(int index){
    switch (index) {
      case 0: return CategoryAll();
      case 1: return CategoryNewspaper();
      case 2: return CategoryIelts();
      case 3: return CategoryToeic();
      
      default: return CategoryAll();
    }
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('Line 34: ' + selectedCategoryIndex.toString());
    return SafeArea(
      child: Column(
        children: <Widget>[
          // named constructor
          Categories(onChangeCategoryIndex: changeCategoryIndex,),
          
          //debugPrint(index???) index ????
           // switch ( selectedCategoryIndex) case 0 : . case 1: 
          switchCategory(selectedCategoryIndex)
          
        ],
      ),
    );
  }
}

class CategoryAll extends StatelessWidget {
  const CategoryAll({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
            child: Padding(
              padding:
                  EdgeInsets.symmetric(horizontal: SizeConfig.defaultSize * 2),
              child: GridView.builder(
                itemCount: recipeBundles.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount:
                      SizeConfig.orientation == Orientation.landscape ? 2 : 1,
                  mainAxisSpacing: 20,
                  crossAxisSpacing:
                      SizeConfig.orientation == Orientation.landscape
                          ? SizeConfig.defaultSize * 2
                          : 0,
                  childAspectRatio: 1.65,
                ),
                itemBuilder: (context, index) => RecipeBundelCard(
                  recipeBundle: recipeBundles[index],
                  press: () {
                    debugPrint(index.toString());
                    
                  },
                ),
              ),
            ),
          );
  }
}

class CategoryNewspaper extends StatelessWidget {
  const CategoryNewspaper({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child:  NewspaperView(),
      
    );
  }
}

class CategoryIelts extends StatelessWidget {
  const CategoryIelts({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text('Day la page Ielts');
  }
}

class CategoryToeic extends StatelessWidget {
  const CategoryToeic({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text('Day la page Toeic');
  }
}