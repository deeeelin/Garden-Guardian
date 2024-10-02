import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:image_picker/image_picker.dart';

import 'package:flutter_app/models/message.dart';
import 'package:flutter_app/models/plant.dart';
import 'package:intl/intl.dart'; // For date formatting
import 'package:cloud_functions/cloud_functions.dart';

// import 'package:flutter_app/repositories/message_repo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_app/repositories/plant_repo.dart';
import 'package:flutter_app/repositories/appUser_repo.dart';
import 'package:flutter_app/models/appUser.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_app/models/growth_log.dart';
import 'package:flutter_app/repositories/growth_log_repo.dart';

// Function to process the image and identify the plant species
// Future<String> identifyPlantSpecies(String imagePath) async {
//   // This function will use the GPT-4 model to identify the species
//   // Implementation will depend on how you interact with the GPT-4 model
//   // For now, we will assume a placeholder implementation
//   String species = await getPlantSpeciesFromImage(imagePath);
//   return species;
// }

// Placeholder for actual implementation
// Future<String> getPlantSpeciesFromImage(String imagePath) async {
//   // Implement your image recognition logic here
//   return "Ficus lyrata"; // Placeholder species name
// }

Map<String, DateTime?> calculateNextCareDates(DateTime plantingDate,
    int wateringCycle, int fertilizationCycle, int pruningCycle) {
  // DateTime today = DateTime.now();
  DateTime nextWateringDate = plantingDate.add(Duration(days: wateringCycle));
  DateTime nextFertilizationDate =
      plantingDate.add(Duration(days: fertilizationCycle));
  DateTime? nextPruningDate =
      pruningCycle > 0 ? plantingDate.add(Duration(days: pruningCycle)) : null;

  return {
    "nextWateringDate": nextWateringDate,
    "nextFertilizationDate": nextFertilizationDate,
    "nextPruningDate": nextPruningDate,
  };
}

// Function to add a new plant
Future<String> addNewPlant(
    String species,
    String base64imageUrl,
    String imageDesMsg,
    int wateringCycle,
    int fertilizationCycle,
    int pruningCycle,
    PlantRepository _plantRepository) async {
  DateTime plantingDate = DateTime.now();

  Map<String, DateTime?> careDates = calculateNextCareDates(
      plantingDate, wateringCycle, fertilizationCycle, pruningCycle);

  //============== img storage ========//
  // Decode the Base64 image
  // Extract the actual base64 string from the input format
  final RegExp base64RegExp = RegExp(r'data:image\/[a-zA-Z]+;base64,');
  String base64String = base64imageUrl.replaceFirst(base64RegExp, '');

  Uint8List imageBytes = base64Decode(base64String);

  //* used in web
  final storageRef = FirebaseStorage.instance
      .ref()
      .child('apps/plants/${DateTime.now().millisecondsSinceEpoch}.jpg');
  UploadTask uploadTask = storageRef.putData(imageBytes);
  TaskSnapshot taskSnapshot = await uploadTask;
  String downloadURL = await taskSnapshot.ref.getDownloadURL();

  /** used in android
  // Get the temporary directory to store the image file
  //Directory tempDir = await getTemporaryDirectory();
  //String filePath ='${tempDir.path}/${DateTime.now().millisecondsSinceEpoch}.jpg';
  // File imageFile = File(filePath);
  // await imageFile.writeAsBytes(imageBytes);
  // Upload image to Firebase Storage
  // final storageRef = FirebaseStorage.instance
  //     .ref()
  //     .child('apps/plants/${DateTime.now().millisecondsSinceEpoch}.jpg');
  // await storageRef.putFile(imageFile);
  // String imageUrl = await storageRef.getDownloadURL();
  */

  //============== add to plants collection ========//
  Plant newPlant = Plant(
    nickName: 'wait to be updated',
    locationId: 'living room', //! [TODO] need to be updated by user
    species: species,
    imageUrl: base64imageUrl,
    downloadURL: downloadURL,
    description: imageDesMsg,
    plantingDate: plantingDate,
    wateringCycle: wateringCycle,
    fertilizationCycle: fertilizationCycle,
    pruningCycle: pruningCycle,
    lastCareDate:
        plantingDate, //! [TODO] should be updated when user reports new care
    nextWateringDate: careDates["nextWateringDate"],
    nextFertilizationDate: careDates["nextFertilizationDate"],
    nextPruningDate: careDates["nextPruningDate"],
  );

  //! add to database
  await _plantRepository.addPlant(newPlant);
  debugPrint("Plant added to DB successfully");

  // Formatting the date for a nice output
  String formattedString = 'Plant Details:\n'
      'Species: ${newPlant.species}\n'
      'Planting Date: ${DateFormat('yyyy-MM-dd').format(newPlant.plantingDate ?? DateTime.now())}\n'
      'Watering Cycle: ${newPlant.wateringCycle} days\n'
      'Fertilization Cycle: ${newPlant.fertilizationCycle} days\n'
      'Pruning Cycle: ${newPlant.pruningCycle! > 0 ? newPlant.pruningCycle.toString() + " days" : "No need to prune!"}\n'
      'Next Watering Date: ${DateFormat('yyyy-MM-dd').format(careDates["nextWateringDate"]!)}\n'
      'Next Fertilization Date: ${DateFormat('yyyy-MM-dd').format(careDates["nextFertilizationDate"]!)}\n'
      'Next Pruning Date: ${careDates["nextPruningDate"] != null ? DateFormat('yyyy-MM-dd').format(careDates["nextPruningDate"]!) : "No need to prune!"}';

  return formattedString;
}

Future<String> storeNickname(String nickname) async {
  // store nickname for latest added plant
  PlantRepository plantRepository = PlantRepository();
  String? targetPlantID = await plantRepository.getLatestPlantID();
  if (targetPlantID == null) {
    throw Exception('Plant not found');
  }
  // Update the plant's nickname
  await plantRepository.updatePlant(targetPlantID, {'nickName': nickname});

  return 'Nickname updated successfully!';
}

Future<String> counting_goal(String behavior, String lastCareDate,
    int wateringCycle, int fertilizationCycle, int pruningCycle) async {
  AppUserRepository userRepository = AppUserRepository();
  appUser? user = await userRepository
      .getCurrentAppUser("test"); //! [TODO] need to dynamically change
  // Handle user behavior counting
  if (user == null) {
    throw Exception('User not found');
  }
  debugPrint('User found: ${user.userName}');
  switch (behavior) {
    case 'watering':
      user.cnt_watering += 1;

      // Update the user in Firestore
      await userRepository.createOrUpdateUser(user);
      debugPrint(
          'User updated successfully, user.cnt_watering: ${user.cnt_watering}');
      break;
    // case 'plantNum':
    //   user?.cnt_plantNum = user.cnt_plantNum ?? 0 + 1;
    //   break;
    // case 'plantType':
    //   user?.cnt_plantType = user.cnt_plantType ?? 0 + 1;
    //   break;
    // case 'drink': //! [TODO] connect with water page to count drink
    //   user?.cnt_drink = user.cnt_drink ?? 0 + 300;
    //   break;
    default:
      throw ArgumentError('Unknown behavior: $behavior');
  }

  DateFormat formatter = DateFormat('yyyy-MM-dd');
  DateTime parsedLastActionDate = formatter.parse(lastCareDate);

  DateTime nextWateringDate =
      parsedLastActionDate.add(Duration(days: wateringCycle));
  DateTime nextFertilizationDate =
      parsedLastActionDate.add(Duration(days: fertilizationCycle));
  DateTime? nextPruningDate = pruningCycle > 0
      ? parsedLastActionDate.add(Duration(days: pruningCycle))
      : null;

  // Formatting the date for a nice output
  String formattedString = 'Next Care Dates:\n'
      'Next Watering Date: ${formatter.format(nextWateringDate)}\n'
      'Next Fertilization Date: ${formatter.format(nextFertilizationDate)}\n'
      'Next Pruning Date: ${nextPruningDate != null ? DateFormat('yyyy-MM-dd').format(nextPruningDate) : "No need to prune!"}';

  // Return a map containing user and formatted string
  return formattedString;
}

/*
// deliberately use "plantingDate" in case user reports "i watered the plant yesterday" or "i fertilized the plant last week"
// Function to calculate the next care dates
String calculateNextCareDatesTool(String lastActionDate, int wateringCycle,
    int fertilizationCycle, int pruningCycle) {
  // DateTime today = DateTime.now();
  DateFormat formatter = DateFormat('yyyy-MM-dd');
  DateTime parsedLastActionDate = formatter.parse(lastActionDate);

  DateTime nextWateringDate =
      parsedLastActionDate.add(Duration(days: wateringCycle));
  DateTime nextFertilizationDate =
      parsedLastActionDate.add(Duration(days: fertilizationCycle));
  DateTime? nextPruningDate = pruningCycle > 0
      ? parsedLastActionDate.add(Duration(days: pruningCycle))
      : null;

  // Formatting the date for a nice output
  String formattedString = 'Next Care Dates:\n'
      'Next Watering Date: ${DateFormat('yyyy-MM-dd').format(nextWateringDate)}\n'
      'Next Fertilization Date: ${DateFormat('yyyy-MM-dd').format(nextFertilizationDate)}\n'
      'Next Pruning Date: ${nextPruningDate != null ? DateFormat('yyyy-MM-dd').format(nextPruningDate) : "No need to prune!"}';
  return formattedString;
}
 */
Future<String> addGrowthLog(
    String plantNickname,
    String text,
    String base64Image,
    PlantRepository _plantRepository,
    GrowthLogRepository _growthLogRepository) async {
  try {
    // Find the plant by nickname
    final plant = await _plantRepository.getPlantByNickname(plantNickname);
    if (plant == null) {
      return 'Plant not found';
    }

    // Use plant's imageUrl as the default image if base64Image is empty
    final imageUrl = base64Image.isNotEmpty ? base64Image : plant.imageUrl;

    // Create a new growth log entry
    final growthLog = GrowthLog(
      name: plantNickname,
      imageUrl: imageUrl,
      description: text,
      timestamp: Timestamp.now(),
    );

    // Add the growth log entry to the repository
    try {
      // Retrieve the plantID using the plantNickname
      final plantID =
          await _plantRepository.getPlantIDByNickname(plantNickname);
      if (plantID == null) {
        throw Exception('Plant ID not found for nickname: $plantNickname');
      }
      debugPrint('plantID: $plantID');

      // Add the growth log to the repository
      await _growthLogRepository.addGrowthLog(plantID, growthLog);
      debugPrint('Growth log added successfully');
    } catch (e) {
      debugPrint('Failed to add growth log: $e');
    }

    return 'Growth log added successfully';
  } catch (e) {
    debugPrint('Error in addGrowthLog: $e');
    return 'Error adding growth log';
  }
}

Future<String> findSimilarMessage(String query, int queryNum) async {
  debugPrint('Finding and appending similar message for query: $query');

  final results = await _vectorSearch(query, queryNum);

  if (results.isEmpty) {
    debugPrint("Memory database is empty");

    String systemHeader =
        "The database is empty, can't retrieve information of past conversations.";
    return systemHeader;
  } else {
    String systemHeader = """
You just retrieved pass message records from database, every unit of message contains three metadata as the following:
- ROLE :  The role of the prompt, there will only be two kinds of ROLE which is "assistant" and "user", you should see the message of ROLE = "assisant" as the message that you sent, and the message of ROLE = "user" as the message the user sent.
- DATE : The create date of the retrieved message, in the format of 'YYYY-MM-DD HH:MM:SS. 000' . 
- TEXT : The text content of the retrieved message, you should recognize the content.
- IMAGE : If this message contains a image, this metadata contains the description of the image including the name , big picture , and the detail of the image. If the message doesn't contain image , then this metadata will be empty.

Now below is the list of the retrieved messages : 

""";
    String combinedMessages = results.map((result) {
      return """
ROLE : \n${result.role}
DATE : \n${result.timeStamp}
TEXT : \n${result.text} 
IMAGE : \n${result.imageDescription}
    
      """;
    }).join('\n');

    String finalContent = "$systemHeader\n$combinedMessages";

    debugPrint('Retrieved messsage : $finalContent');

    return finalContent;
  }
}

Future<List<Message>> _vectorSearch(String searchString, int queryNum) async {
  try {
    UserCredential userCredential =
        await FirebaseAuth.instance.signInAnonymously();
    debugPrint('Signed in anonymously as: ${userCredential.user?.uid}');

    debugPrint('Performing vector search');

    final HttpsCallable callable = FirebaseFunctions.instance
        .httpsCallable('ext-firestore-vector-search-queryCallable');

    final response = await callable.call(<String, dynamic>{
      'query': searchString,
      'limit': queryNum,
    });
    debugPrint('Vector search response: ${response.data}');

    List<Message> messages = [];

    for (int i = 0; i < queryNum; i++) {
      if (i >= response.data['ids'].length) break;

      debugPrint(
          'Fetching message from Firestore with ID: ${response.data['ids'][i]}');

      final docSnapshot = await FirebaseFirestore.instance
          .collection('messages')
          .doc(response.data['ids'][i])
          .get();

      if (docSnapshot.exists) {
        final data = docSnapshot.data();
        messages.add(Message.fromMap(data ?? {}));
      }
    }

    return messages;
  } catch (e) {
    debugPrint('Error in vector search: $e');
    return [];
  }
}
