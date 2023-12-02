import 'package:flutter/material.dart';
import 'package:flutter_calories_calculator/pages/add_food.dart';
import 'package:flutter_calories_calculator/pages/edit_plan.dart';
import 'package:flutter_calories_calculator/pages/home.dart';
import 'package:flutter_calories_calculator/pages/meal_plan.dart';


void main() => runApp(MaterialApp(
    initialRoute: '/home',
    routes: {
      '/home': (context) => Home(),
      '/add_food': (context) => AddFood(),
      '/meal_plan': (context) => MealPlan(),
      '/edit_plan': (context) => EditPlan()
    }
));

