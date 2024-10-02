import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_app/models/drink_water.dart';
import 'package:flutter_app/repositories/drink_water_repo.dart';

class AllDrinkWatersViewModel with ChangeNotifier {
  final DrinkWaterRepository _drinkwaterRepository;

  List<DrinkWater> _drinkwaters = [];
  List<DrinkWater> get drinkwaters => _drinkwaters;
  StreamSubscription<List<DrinkWater>>? _drinkwatersSubscription;
  bool _isInitializing = true;
  bool get isInitializing => _isInitializing;

  AllDrinkWatersViewModel({DrinkWaterRepository? drinkwaterRepository})
      : _drinkwaterRepository = drinkwaterRepository ?? DrinkWaterRepository() {
    _drinkwatersSubscription =
        _drinkwaterRepository.streamDrinkWaters().listen((drinkwatersData) {
      _isInitializing = false;
      _drinkwaters = drinkwatersData;
      notifyListeners();
    }, onError: (error) {
      _isInitializing = false;
      _drinkwaters = [];
      notifyListeners();
    });
  }

  Stream<List<DrinkWater>> get drinkWatersStream =>
      _drinkwaterRepository.streamDrinkWaters();

  @override
  void dispose() {
    _drinkwatersSubscription?.cancel();
    super.dispose();
  }

  Future<void> addDrinkWater(DrinkWater newDrinkWater) async {
    await _drinkwaterRepository.addDrinkWater(newDrinkWater);
  }
}
