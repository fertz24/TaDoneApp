import 'package:cloud_firestore/cloud_firestore.dart';

class DeleteTodoPresentador {
  final todoCollection = FirebaseFirestore.instance.collection('todos');

  Future <void> eliminarTodo(String id) async {
    return await todoCollection.doc(id).delete();
  }
}