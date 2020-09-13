import 'package:flutter/material.dart';

class RecipeBundle {
  final int id, chefs, recipes;
  final String title, description, imageSrc;
  final Color color;

  RecipeBundle(
      {this.id,
      this.chefs,
      this.recipes,
      this.title,
      this.description,
      this.imageSrc,
      this.color});
}

// Demo list
List<RecipeBundle> recipeBundles = [
  RecipeBundle(
    id: 1,
    chefs: 16,
    recipes: 95,
    title: "Cambride IELTS 13 - Academic",
    description: "The trustful IELTS resource for student !",
    imageSrc: "assets/images/cam14.jpg",
    color: Color(0xFFD82D40),
  ),
  RecipeBundle(
    id: 2,
    chefs: 8,
    recipes: 26,
    title: "Vietnamese Tea ",
    description: "The traditional drinks of Vietnam",
    imageSrc: "assets/images/best_2020@2x.png",
    color: Color(0xFF90AF17),
  ),
  RecipeBundle(
    id: 3,
    chefs: 10,
    recipes: 43,
    title: "Food Court",
    description: "What's your favorite food dish make it now",
    imageSrc: "assets/images/food_court@2x.png",
    color: Color(0xFF2DBBD8),
  ),
];
