import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_app/models/appUser.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AppUserRepository {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

/**  listen to the returned stream to receive updates about the user's data
 * 
 * streamUser("someUserId").listen((appUser? user) {
  if (user != null) {
    // Handle the user data (e.g., update UI)
    print("User data updated: ${user.name}");
  } 
});

 * 
*/
  Stream<appUser?> streamUser(String userId) {
    return _db.collection('users').doc(userId).snapshots().map((snapshot) {
      return snapshot.data() == null
          ? null
          : appUser.fromMap(snapshot.data()!, snapshot.id);
    });
  }

  Future<appUser?> getUserByEmail(String email) async {
    QuerySnapshot querySnapshot =
        await _db.collection('users').where('email', isEqualTo: email).get();
    if (querySnapshot.docs.isEmpty) {
      return null;
    }
    return appUser.fromMap(
        querySnapshot.docs.first.data() as Map<String, dynamic>,
        querySnapshot.docs.first.id);
  }

  Future<void> updatePushMessagingToken(String userId, String? token) async {
    await _db
        .collection('users')
        .doc(userId)
        .update({'pushMessagingToken': token});
  }

  Future<void> createOrUpdateUser(appUser user) async {
    Map<String, dynamic> userMap = user.toMap();
    await _db
        .collection('users')
        .doc(user.id)
        .set(userMap); // write to local cache immediately
  }

  Future<appUser?> getCurrentAppUser(String userName) async {
    try {
      QuerySnapshot snapshot = await _db
          .collection('users')
          .where('userName', isEqualTo: userName)
          .limit(1)
          .get();

      if (snapshot.docs.isNotEmpty) {
        // Assuming appUser has a fromMap constructor that takes a map and the document ID
        return appUser.fromMap(
            snapshot.docs.first.data() as Map<String, dynamic>,
            snapshot.docs.first.id);
      } else {
        return null;
      }
    } catch (e) {
      print('Error getting current app user: $e');
      return null;
    }
  }

  Future<void> incrementCntWatering(String userId) async {
    DocumentReference userRef = _db.collection('users').doc(userId);
    await _db.runTransaction((transaction) async {
      DocumentSnapshot snapshot = await transaction.get(userRef);
      if (!snapshot.exists) {
        throw Exception("User does not exist!");
      }
      int newCntWatering =
          (snapshot.data() as Map<String, dynamic>)['cnt_watering'] + 1;
      transaction.update(userRef, {'cnt_watering': newCntWatering});
    });
  }

  Future<void> incrementCntSignin(String userId) async {
    DocumentReference userRef = _db.collection('users').doc(userId);
    await _db.runTransaction((transaction) async {
      DocumentSnapshot snapshot = await transaction.get(userRef);
      if (!snapshot.exists) {
        throw Exception("User does not exist!");
      }
      int newCntSignin =
          (snapshot.data() as Map<String, dynamic>)['cnt_signin'] + 1;
      transaction.update(userRef, {'cnt_signin': newCntSignin});
    });
  }

  Future<void> incrementCntDrink(String userId) async {
    DocumentReference userRef = _db.collection('users').doc(userId);
    await _db.runTransaction((transaction) async {
      DocumentSnapshot snapshot = await transaction.get(userRef);
      if (!snapshot.exists) {
        throw Exception("User does not exist!");
      }
      int newCntDrink =
          (snapshot.data() as Map<String, dynamic>)['cnt_drink'] + 1;
      transaction.update(userRef, {'cnt_drink': newCntDrink});
    });
  }

  Future<appUser?> getUserById(String userId) async {
    DocumentSnapshot docSnapshot =
        await _db.collection('users').doc(userId).get();
    if (!docSnapshot.exists) {
      return null;
    }
    return appUser.fromMap(
        docSnapshot.data() as Map<String, dynamic>, docSnapshot.id);
  }
}
