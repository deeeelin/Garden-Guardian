import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_app/models/todo.dart';

class TodoRepository {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> addTodoItem(Todo todo) async {
    try {
      DocumentReference docRef =
          await _db.collection('todos').add(todo.toMap());
      await docRef.update({'id': docRef.id});
      print('TodoItem added with ID: ${docRef.id}');
    } catch (e) {
      print('Error adding todo item: $e');
    }
  }

  Future<void> updateTodoItem(String id, Map<String, dynamic> data) async {
    try {
      await _db.collection('todos').doc(id).update(data);
      print('TodoItem updated with ID: $id');
    } catch (e) {
      print('Error updating todo item: $e');
    }
  }

  Future<void> deleteTodoItem(String id) async {
    try {
      await _db.collection('todos').doc(id).delete();
      print('TodoItem deleted with ID: $id');
    } catch (e) {
      print('Error deleting todo item: $e');
    }
  }

  Stream<List<Todo>> streamAllTodos() {
    return FirebaseFirestore.instance
        .collection('todos')
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) {
              return Todo(
                id: doc.id,
                title: doc['title'],
                isCompleted: doc['isCompleted'],
              );
            }).toList());
  }
}
