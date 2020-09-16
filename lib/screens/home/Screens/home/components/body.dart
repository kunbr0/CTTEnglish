import 'package:flutter/material.dart';
import 'package:cttenglish/models/RecipeBundel.dart';
import 'package:cttenglish/size_config.dart';

import 'categories.dart';
import 'recipe_bundel_card.dart';

class Body extends StatelessWidget {
  final Function openReader = (context) {
    Navigator.of(context)
        .pushNamed('/reader', arguments: 'After the country managed to bring the second wave of the pandemic under control, the transport ministry earlier this month proposed reopening flights to mainland China, Japan, and South Korea starting September 15, followed by Laos, Cambodia and Taiwan starting September 22. The ministry estimates the number of arrivals to be quarantined per week at about 5,000 in Hanoi and HCMC.');
  };

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: <Widget>[
          Categories(),
          Expanded(
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
                    openReader(context);
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
