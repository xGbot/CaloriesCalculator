import 'package:flutter/material.dart';
import '../food_items.dart';


class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final dbMeals = MealPlansDB();
  List<MealPlans> meals = [];

  @override
  void initState() {
    super.initState();
    getMealsFromDB();
  }

  // get all foods from db
  Future<void> getMealsFromDB() async {
    final mealsDB = await dbMeals.getMealPlans();

    setState(() {
      meals = mealsDB;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calories Calculator'),
        backgroundColor: Colors.lightBlue,
      ),
      backgroundColor: Colors.lightBlue[100],
      body: SingleChildScrollView(
        child: Container(
          height: 650,
          width: 750,
          padding: const EdgeInsets.all(10),
          margin: const EdgeInsets.all(15),
          child: SingleChildScrollView(
            child: DataTable(
              columns: const [
                DataColumn(label: Text("Food")),
                DataColumn(label: Text("Cals")),
                DataColumn(label: Text("Date")),
              ],
              rows: meals.map((meal) {
                return DataRow(
                  selected: true,
                  onLongPress: () {
                    Navigator.pushNamed(context, '/edit_plan', arguments: meal.id);
                    setState(() {
                      getMealsFromDB();
                    });
                  },
                  cells: [
                    DataCell(Text(meal.food)),
                    DataCell(Text(meal.cals.toString())),
                    DataCell(Text(meal.date))
                  ]
                );
              }).toList()
            ),
          )
        ),
      ),

      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () async{
              Navigator.pushNamed(context, '/add_food');
            },
            backgroundColor: Colors.lightBlue,
            child: const Icon(Icons.food_bank),
          ),

          const SizedBox(height: 10),

          FloatingActionButton(
            onPressed: () async{
              Navigator.pushNamed(context, '/meal_plan');
            },
            backgroundColor: Colors.lightBlue,
            child: const Icon(Icons.add),
          ),
        ]
      ),

    );
  }
}