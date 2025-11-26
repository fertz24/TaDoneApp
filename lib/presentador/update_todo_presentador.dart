import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fer1/modelo/todo_modelo.dart';
import 'package:firebase_auth/firebase_auth.dart';

final todoCollection = FirebaseFirestore.instance.collection('todos');

class UpdateTodoPresentador {
  
  Future<void> editarTodo(String id, String titulo, String descripcion) async { 
  final editarTodoCollection =
      FirebaseFirestore.instance.collection("todos").doc(id); 

      return await editarTodoCollection.update({ 
        'titulo': titulo, 
        'descripcion': descripcion, 
    });
  }

  Future<void> editarTodoEstado (String id, bool completado) async { 
    return await todoCollection.doc(id).update({'completado': completado});
  }

  Stream<List<TodoModelo>> get todosCompletados { 
    final user = FirebaseAuth.instance.currentUser; 
    return todoCollection 
    .where('uid', isEqualTo: user!.uid) 
    .where('completado', isEqualTo: true) 
    .snapshots()
    .map((snapshot) => todoListFromSnapshot(snapshot)); 
  }
}