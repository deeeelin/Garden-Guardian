import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/models/drink_water.dart';

class DrinkWaterRepository {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final timeout = const Duration(seconds: 10);

  Stream<List<DrinkWater>> streamDrinkWaters() {
    return _db.collection('drinkwaters').snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) =>
              DrinkWater.fromMap(doc.data() as Map<String, dynamic>, doc.id))
          .toList();
    });
  }

  Future<void> addDrinkWater(DrinkWater drinkwater) async {
    Map<String, dynamic> drinkwaterMap = drinkwater.toMap();
    // Remove 'id' because Firestore automatically generates a unique document ID for each new document added to the collection.
    drinkwaterMap.remove('id');

    try {
      DocumentReference docRef = await _db
          .collection('drinkwaters')
          .add(drinkwaterMap) // write to local cache immediately
          .timeout(timeout); // Add timeout to handle network issues

      debugPrint('Drinkwater added with ID: ${docRef.id}');
    } catch (e) {
      debugPrint('Error adding drinkwater: $e');
    }
  }
}
