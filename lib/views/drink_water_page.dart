import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_app/models/drink_water.dart';
import 'package:flutter_app/view_models/all_drink_waters_vm.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/repositories/appUser_repo.dart';

class DrinkWaterPage extends StatefulWidget {
  const DrinkWaterPage({super.key});

  @override
  State<DrinkWaterPage> createState() => _DrinkWaterPageState();
}

class _DrinkWaterPageState extends State<DrinkWaterPage> {
  final _form = GlobalKey<FormState>();
  var dailyWater = 2000;
  var _enteredWater = 0;

  @override
  Widget build(BuildContext context) {
    final allDrinkWatersViewModel =
        Provider.of<AllDrinkWatersViewModel>(context);
    final drinkwaters = allDrinkWatersViewModel.drinkwaters;
    var total = 0;

    for (var water in drinkwaters) {
      total += water.water;
    }

    if (total > dailyWater) {
      _incrementCntDrink();
    }

    if (allDrinkWatersViewModel.isInitializing) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    return Scaffold(
      backgroundColor: Colors.green[50],
      appBar: AppBar(
        title: const Text(
          'Water Yourself!',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 93, 176, 117),
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Consumer<AllDrinkWatersViewModel>(
        builder: (context, viewModel, _) {
          return Column(
            children: [
              const SizedBox(height: 20),
              Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: 200,
                    height: 200,
                    child: CircularProgressIndicator(
                      value: total / dailyWater,
                      color: Theme.of(context).colorScheme.primary,
                      backgroundColor: Colors.grey,
                    ),
                  ),
                  Text(
                    '$total mL',
                    style: const TextStyle(
                        fontSize: 25, fontWeight: FontWeight.w400),
                  )
                ],
              ),
              const SizedBox(height: 10),
              const Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.all(15),
                  child: Text(
                    'Records',
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Expanded(
                flex: 4,
                child: Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    if (drinkwaters.isEmpty)
                      const Center(child: Text('No records.'))
                    else
                      ListView.builder(
                        itemCount: viewModel.drinkwaters.length,
                        itemBuilder: (context, index) =>
                            _buildItem(context, viewModel, index),
                      ),
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: IconButton(
                        icon: const Icon(Icons.add),
                        iconSize: 40,
                        color: Theme.of(context).colorScheme.primary,
                        onPressed: () => _showAddDialog(context, viewModel),
                      ),
                    )
                  ],
                ),
              )
            ],
          );
        },
      ),
    );
  }

  Widget _buildItem(
      BuildContext context, AllDrinkWatersViewModel viewModel, int index) {
    final drinkwater = viewModel.drinkwaters[index];

    return AnimatedOpacity(
      opacity: 1.0,
      duration: Duration(milliseconds: 500),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: ListTile(
          contentPadding: EdgeInsets.all(16.0),
          title: Row(
            children: [
              Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  '${drinkwater.water} mL',
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showAddDialog(BuildContext context, AllDrinkWatersViewModel viewModel) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Form(
          key: _form,
          child: AlertDialog(
            title: const Text('Add Record'),
            content: TextFormField(
              key: const ValueKey('water'),
              decoration: const InputDecoration(
                  hintText: "Type the amount of water in mL:"),
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly
              ],
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a valid amount';
                }
                return null;
              },
              onSaved: (value) {
                _enteredWater = int.parse(value!);
              },
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('Cancel'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: const Text('Add'),
                onPressed: () => _submit(context, viewModel),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _submit(
      BuildContext dialogContext, AllDrinkWatersViewModel viewModel) async {
    if (!_form.currentState!.validate()) {
      return;
    }
    _form.currentState!.save();

    final newItem = DrinkWater(water: _enteredWater);

    try {
      await viewModel.addDrinkWater(newItem);

      // Check if the widget is still mounted after async gap
      if (mounted) {
        setState(() {
          // Force rebuild to reflect the new data
        });
        Navigator.of(dialogContext).pop();
      }
    } on TimeoutException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Operation timed out: ${e.message}"),
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }

  Future<void> _incrementCntDrink() async {
    final appUserRepo = AppUserRepository();
    // final userId = appUserRepo.getCurrentUserId();
    await appUserRepo.incrementCntDrink('cV8dyoEmSUZo7QXUiceE1g4YvLm1');
  }
}
