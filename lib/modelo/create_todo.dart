import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

class CreateTodo {
  final CollectionReference todoCollection =
        FirebaseFirestore.instance.collection("todos");

  User? user = FirebaseAuth.instance.currentUser;
  
  //Para agregar tarea 
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
}