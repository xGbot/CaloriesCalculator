import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../food_items.dart';

class EditPlan extends StatefulWidget {
  const EditPlan({super.key});

  @override
  State<EditPlan> createState() => _EditPlanState();
}

class _EditPlanState extends State<EditPlan> {
  final TextEditingController targetController = TextEditingController();
  final TextEditingController dateController = TextEditingController();

  DateTime date = DateTime.now();
  final db = FoodItemsDB();
  final dbMeals = MealPlansDB();
  double calories = 0;
  List foods = [];
  List<Food> mealPlan = [];

  // on start get foods from db
  @override
  void initState() {
    super.initState();
    getFoodFromDB();
  }

  // get all foods from db
  Future<void> getFoodFromDB() async {
    final dbFoods = await db.getFoods();

    setState(() {
      foods = dbFoods;
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (picked != null) {
      setState(() {
        date = picked;
        dateController.text =
        '${date.toLocal()}'.split(' ')[0];

      });
    }
  }

  @override
  Widget build(BuildContext context) {
    int? passedID = ModalRoute.of(context)!.settings.arguments as int?;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text("Edit Plan"),
        backgroundColor: Colors.lightBlue,
      ),
      backgroundColor: Colors.lightBlue[100],
      body: Container(
        padding: const EdgeInsets.all(10),
        margin: const EdgeInsets.all(15),
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.all(5),
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.black),
                borderRadius: BorderRadius.circular(10),
              ),
              child: TextField(
                controller: targetController,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: const InputDecoration(
                    hintText: "Target Calories",
                    border: InputBorder.none
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.all(5),
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.black),
                borderRadius: BorderRadius.circular(10),
              ),
              child: TextField(
                controller: dateController,
                readOnly: true,
                onTap: () => _selectDate(context),
                decoration: const InputDecoration(
                  hintText: 'Select Date',
                  suffixIcon: Icon(Icons.calendar_today),
                  border: InputBorder.none,
                ),
              ),
            ),
            SizedBox(
              height: 200,
              child: SingleChildScrollView(

                child: ExpansionTile(
                    title: const Text("Foods", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                    children: [
                      for (var food in foods)
                        ListTile(
                          selected: true,
                          title: Text(
                            food.toString().substring(food.toString().indexOf(',') + 1, food.toString().lastIndexOf(','))
                                + "\t" + food.toString().substring(food.toString().lastIndexOf(',') + 1) + " cals",
                            style: TextStyle(color: Colors.black),
                          ),
                          onTap: () {
                            Food f = Food(
                                id: int.tryParse(food.toString().substring(0, food.toString().indexOf(','))) as int,
                                name: food.toString().substring(food.toString().indexOf(',') + 1, food.toString().lastIndexOf(',')),
                                cals: double.tryParse(food.toString().substring(food.toString().lastIndexOf(',') + 1)) as double
                            );

                            setState(() {
                              mealPlan.add(f);
                              calories += f.cals;
                            });
                          },
                        )
                    ]
                )
              ),
            ),
            SizedBox(
              height: 200,
              child: SingleChildScrollView(
                child: DataTable(
                    columns: const [
                      DataColumn(label: Text("Food")),
                      DataColumn(label: Text("Calories")),
                    ],
                    rows: mealPlan.map((meal) {
                      return DataRow(
                          selected: true,
                          onLongPress: () {
                            int? id = meal.id;
                            setState(() {
                              mealPlan.remove(meal);
                              calories -= meal.cals;
                            });
                          },
                          cells: [
                            DataCell(Text(meal.name)),
                            DataCell(Text(meal.cals.toString()))
                          ]
                      );
                    }).toList()
                ),
              ),
            ),
            SizedBox(height: 10),
            Text("Total Calories $calories", style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
            )),
            SizedBox(height: 25),
            ElevatedButton(
              style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.green)),
              onPressed: () {
                String targetCals = targetController.text;
                if (targetCals.isNotEmpty && dateController.text.isNotEmpty) {
                  MealPlans mp = MealPlans(id: 0, date: dateController.text, cals: double.tryParse(targetCals) as double, food: mealPlan.toString());
                  dbMeals.insertMealPlan(mp);
                  Navigator.pop(context);
                }
              },
              child: Text("Save"),
            )
          ],
        ),
      ),
    );
  }
}