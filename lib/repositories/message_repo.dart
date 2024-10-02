import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:flutter_app/models/message.dart';

class MessageRepository {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  Stream<List<Message>> streamViewMessages() {
    // all of the message in db with username != null (not system message)

    return _db
        .collection('messages')
        // .where('role',isNotEqualTo: 'system') //filter message with role == system ( system message)
        .orderBy('timeStamp', descending: false)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => Message.fromMap(doc.data())).toList();
    });
  }

  Stream<List<Message>> streamContentMessages() {
    // all of the message in db
    return _db
        .collection('messages')
        .orderBy('timeStamp', descending: false)
        .limitToLast(2)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => Message.fromMap(doc.data())).toList();
    });
  }

  Future<void> addMessage(Message m) async {
    debugPrint('Adding message: ${m.text}');

    // currentTokenCount += _calculateTokenCount(m.text) +
    //     _calculateTokenCount(m.base64ImageUrl) +
    //     _calculateTokenCount(m.timeStamp.toString()) +
    //     _calculateTokenCount(m.imageDescription);

    // if (currentTokenCount * 1.3 >= maxInputTokens) { // for debug
    //    await _storeInDatabase(m);
    // }
    await _storeInDatabase(m);
  }

  // int _calculateTotalTokenCount() {
  //   return messages.fold(0, (sum, message) =>
  //       sum + _calculateTokenCount(message.text) +
  //           _calculateTokenCount(message.base64ImageUrl) +
  //           _calculateTokenCount(message.timeStamp.toString()) +
  //           _calculateTokenCount(message.imageDescription));
  // }

  Future<void> _storeInDatabase(Message message) async {
    try {
      debugPrint('Storing message in database: ${message.text}');

      // final HttpsCallable callable =  FirebaseFunctions.instance.httpsCallable('storeInDatabase');

      debugPrint('Callable created, waiting for response from database');

      // final response = await callable.call(<String, dynamic>{
      //   'role': message.role,
      //   'text': message.text,
      //   'base64ImageUrl': message.base64ImageUrl,
      //   'timeStamp': message.timeStamp.toString(),
      //   'imageDescription': message.imageDescription,
      //   'stringtoEmbed': message.text + (message.imageDescription ?? '') + message.timeStamp.toString(),
      //  // 'servertimeStamp' : FieldValue.serverTimestamp()
      // });

      DocumentReference docRef = await FirebaseFirestore.instance
          .collection('messages')
          .add(await message.toMap());

      debugPrint('Received response from database: ${docRef.id}');
    } catch (e) {
      debugPrint('Error storing message in database: $e');
    }
  }

  //* used in heatmap
  Future<int> countTodayMessages() async {
    DateTime now = DateTime.now();
    DateTime startOfDay = DateTime(now.year, now.month, now.day);
    DateTime endOfDay = startOfDay.add(Duration(days: 1));

    QuerySnapshot snapshot = await _db
        .collection('messages')
        .where('timeStamp', isGreaterThanOrEqualTo: startOfDay)
        .where('timeStamp', isLessThan: endOfDay)
        .get();

    return snapshot.docs.length;
  }
}
