import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fer1/modelo/todo_modelo.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

class CreateTodoPresentador {

  final CollectionReference todoCollection =
        FirebaseFirestore.instance.collection("todos");
  User? user = FirebaseAuth.instance.currentUser;
  

  Future<DocumentReference> crearTodo( 
    String titulo, String descripcion) async {
      return await todoCollection.add({ 
        'uid': user!.uid, 
        'titulo': titulo, 
        'descripcion': descripcion,
        'completado': false, 
        'creadoA': FieldValue.serverTimestamp(), 
    });
  }

  Stream<List<TodoModelo>> get todos{ 
    return todoCollection.where('uid', isEqualTo: user!.uid).where('completado', 
            isEqualTo: false).snapshots().map(todoListFromSnapshot); 
  }
}