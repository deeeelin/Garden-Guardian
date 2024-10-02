import 'package:cloud_firestore/cloud_firestore.dart';

class GrowthLog {
  // final String id;
  final String name;
  final String imageUrl;
  final String description;
  final Timestamp timestamp;

  GrowthLog({
    // required this.id,
    required this.name,
    required this.imageUrl,
    required this.description,
    required this.timestamp,
  });

  // Factory method to create a GrowthLog from a Firestore document
  factory GrowthLog.fromDocument(DocumentSnapshot doc) {
    return GrowthLog(
      // id: doc.id,
      name: doc['name'],
      imageUrl: doc['imageUrl'],
      description: doc['description'],
      timestamp: doc['timestamp'],
    );
  }

  // Method to convert a GrowthLog to a map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'imageUrl': imageUrl,
      'description': description,
      'timestamp': timestamp,
    };
  }
}
