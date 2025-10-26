import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

class CreateTodoPresentador {

  //Creamos una referencia a la colección que tiene por nombre "todos" en Firestore, donde guardaremos las tareas
  final CollectionReference todoCollection =
        FirebaseFirestore.instance.collection("todos");

  //Obtenemos el usuario actual autenticado de Firebase (pd. puede ser null si no hay sesión activa)
  User? user = FirebaseAuth.instance.currentUser;
  
  //Para agregar tarea 
  Future<DocumentReference> crearTodo( //Función asíncrona donde recibe título y descripción y este devolverá una referencia al documento creado
    String titulo, String descripcion) async {
      return await todoCollection.add({ //Se agrega un nuevo documento a la colección de "todos" con los siguientes campos
        'uid': user!.uid, //ID del usuario autenticado, con ! se asume que no es nulo
        'titulo': titulo, 
        'descripcion': descripcion,
        'completado': false, //Tarea no completada por defecto
        'creadoA': FieldValue.serverTimestamp(), //Se guarada la fecha y hora del servidor al momento de crearse
    });
  }
}