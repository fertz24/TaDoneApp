import 'package:cloud_firestore/cloud_firestore.dart';

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

  Future<void> editarTodoEstado (String id, bool completada) async {
    return await todoCollection.doc(id).update({'completada': completada});
  }
}