import 'package:cloud_firestore/cloud_firestore.dart';

class DeleteTodoPresentador {

  //Declaramos una referencia a la colección de "todos" en Firestore, para pdoer acceder a los documentos de las tareas de esta colección
  final todoCollection = FirebaseFirestore.instance.collection('todos');

  //Función asincrónica que recibe como parámetro el id del documento que se quiere eliminar
  Future <void> eliminarTodo(String id) async {
    
    //Accedemos al documento de ese id dentro de la colección y este se va a eliminar.
    //Con await nos aseguramos de que la operación de complete antes de continuar con otra cosa
    return await todoCollection.doc(id).delete();
  }
  //Con esta función eliminamos una tarea específica de Firestore con su id
}