import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';


class FoodItemsDB {
  static Database? _db;
  static const String tableName = 'food_items';

  Future<Database> get database async{
    if (_db != null) {
      return _db!;
    }

    _db = await initDatabase();
    return _db!;
  }

  Future<Database> initDatabase() async {
    final path = join(await getDatabasesPath(), 'food_items.db');
    return await openDatabase(path, version: 1, onCreate: _createDatabase);
  }

  Future<void> _createDatabase(Database db, int version) async {
    await db.execute(
      '''
      CREATE TABLE $tableName(id INTEGER PRIMARY KEY, name TEXT, cals DOUBLE)
      '''
    );
  }

  Future<void> insertFood(Food food) async {
    final db = await database;
    final id = await db.insert(tableName, food.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
    print("ID HERE $id");
    food.id = id;
  }

  Future<List<Food>> getFoods() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(tableName);
    return List.generate(maps.length, (i) {
      return Food(
          id: maps[i]['id'] as int,
          name: maps[i]['name'] as String,
          cals: maps[i]['cals'] as double,
      );
    });
  }

  Future<void> updateFood(Food food) async {
    final db = await database;
    await db.update(tableName, food.toMap(), where: 'id = ?', whereArgs: [food.id]);
  }

  Future<void> deleteFood(int id) async {
    final db = await database;
    await db.delete(tableName, where: 'id = ?', whereArgs: [id]);
  }
}

class Food{
  late int id;
  final String name;
  final double cals;

  Food({
    required this.id,
    required this.name,
    required this.cals,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'cals': cals,
    };
  }

  @override
  String toString() {
    return '$id,$name,$cals';
  }
}

class MealPlansDB {
  static Database? _db;
  static const String tableName = 'meal_plans';

  Future<Database> get database async{
    if (_db != null) {
      return _db!;
    }

    _db = await initDatabase();
    return _db!;
  }

  Future<Database> initDatabase() async {
    final path = join(await getDatabasesPath(), 'meal_plans.db');
    return await openDatabase(path, version: 1, onCreate: _createDatabase);
  }

  Future<void> _createDatabase(Database db, int version) async {
    await db.execute(
      '''     
      CREATE TABLE $tableName(id INTEGER PRIMARY KEY, date TEXT, cals DOUBLE, food TEXT)
      '''
    );
  }

  Future<List<MealPlans>> getMealPlans() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(tableName);
    return List.generate(maps.length, (i) {
      return MealPlans(
        id: maps[i]['id'] as int,
        date: maps[i]['date'] as String,
        cals: maps[i]['cals'] as double,
        food: maps[i]['food'] as String
      );
    });
  }
  
  Futute<MealPlans> getMeal(int id) async {
    final db = await database;
    return MealPlans(id: id, date: date, cals: cals, food: food)
  }

  Future<void> insertMealPlan(MealPlans mealPlans) async {
    final db = await database;
    final id = await db.insert(tableName, mealPlans.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
    mealPlans.id = id;
  }

  Future<void> updateMealPlan(MealPlans mealPlans) async {
    final db = await database;
    await db.update(tableName, mealPlans.toMap(), where: 'id = ?', whereArgs: [mealPlans.id]);
  }

  Future<void> deleteMealPlan(int id) async {
    final db = await database;
    await db.delete(tableName, where: 'id = ?', whereArgs: [id]);
  }
}

class MealPlans {
  late int id;
  final String date;
  final double cals;
  final String food;

  MealPlans({
    required this.id,
    required this.date,
    required this.cals,
    required this.food,
  });

  Map<String, dynamic> toMap() {
    return {
      'date': date,
      'cals': cals,
      'food': food,
    };
  }

  @override
  String toString() {
    return 'MealPlans{id: $id, date: $date, cals: $cals, food: $food}';
  }
}
