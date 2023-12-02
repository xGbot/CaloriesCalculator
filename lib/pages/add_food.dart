import 'package:flutter/material.dart';
import 'package:flutter_calories_calculator/food_items.dart';

class AddFood extends StatefulWidget {
  const AddFood({super.key});

  @override
  State<AddFood> createState() => _AddFoodState();
}

class _AddFoodState extends State<AddFood> {
  final TextEditingController foodController = TextEditingController();
  final TextEditingController calController = TextEditingController();
  final db = FoodItemsDB();
  List foods = [];

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


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text("Food Items"),
        backgroundColor: Colors.lightBlue,
      ),
      backgroundColor: Colors.lightBlue[100],
      body: Container(
        padding: const EdgeInsets.all(10),
        margin: const EdgeInsets.all(15),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                margin: const EdgeInsets.all(10),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.black),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextField(
                  controller: foodController,
                  textCapitalization: TextCapitalization.words,
                  decoration: const InputDecoration(
                    hintText: "Food",
                    border: InputBorder.none
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Container(
                margin: const EdgeInsets.all(10),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.black),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextField(
                  controller: calController,
                  decoration: const InputDecoration(
                      hintText: "Calories",
                      border: InputBorder.none
                  ),
                ),
              ),
              Container(
                height: 350,
                child: SingleChildScrollView(
                  child: DataTable(
                    columns: const [
                      DataColumn(label: Text("ID")),
                      DataColumn(label: Text("Food")),
                      DataColumn(label: Text("Calories")),
                    ],
                    rows: foods.map((food) {
                      return DataRow(
                        selected: true,
                        onLongPress: () {
                          int? id = int.tryParse(food.toString().substring(0, food.toString().indexOf(',')));
                          db.deleteFood(id as int);
                          setState(() {
                            getFoodFromDB();
                          });
                        },
                        cells: [
                          DataCell(Text(food.toString().substring(0, food.toString().indexOf(',')))),
                          DataCell(Text(food.toString().substring(food.toString().indexOf(',') + 1, food.toString().lastIndexOf(',')))),
                          DataCell(Text(food.toString().substring(food.toString().lastIndexOf(',') + 1))),
                        ]
                      );
                    }).toList()
                  ),
                ),
              ),

              const SizedBox(height: 20),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.green)
                    ),
                    onPressed: () {
                      String foodName = foodController.text;
                      double? foodCals = double.tryParse(calController.text);

                      if (foodName.isNotEmpty && foodCals != 0) {
                        Food food = Food(id: 1, name: foodName.trim(), cals: foodCals as double);
                        db.insertFood(food);

                        foodController.text = "";
                        calController.text = "";

                        setState(() {
                          getFoodFromDB();
                        });
                      }
                    },
                    child: const Text("Save")
                  ),
                  ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.red)
                    ),
                    onPressed: (){Navigator.pop(context);},
                    child: const Text("Cancel")
                  )
                ],

              )

            ],
          ),
        )
      ),
    );
  }
}
