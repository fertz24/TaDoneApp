import 'package:cloud_firestore/cloud_firestore.dart';

final todoCollection = FirebaseFirestore.instance.collection('todos');

class UpdateTodoPresentador {
  
  //Función asincrónica el cual recibe un id (del documento de Firestore) y los nuevos valores los cuales son el título y descripción de la tarea a editar
  Future<void> editarTodo(String id, String titulo, String descripcion) async { 
  final editarTodoCollection =
      FirebaseFirestore.instance.collection("todos").doc(id); //Creamos una referencia al documento específico dentro de la colección de "todos" 
      //utilizando el id que se le proporcionó a esa tarea, esto apunta de forma directa al registro que se quiere modificar

      return await editarTodoCollection.update({ //Ejecuta la operación de la actualización en Firestore
        'titulo': titulo, //Se actualiza el campo título del documento con el nuevo valor que recibió desde el parámetro
        'descripcion': descripcion, // "" el campo descripción
    });
  }
  //Esta función se encarga de buscar la tarea por medio del id en Firestore y 
  //actualiza el título y descripción en base a los nuevos valores


  //Función asincrónica que recibe el id del documento y un valor bool de completada lo cual indica si la tarea está hecha (true) o pendiente (false)
  Future<void> editarTodoEstado (String id, bool completada) async { 
    return await todoCollection.doc(id).update({'completada': completada});
    //Accede al documento con ese id dentro de la colección "todos" y este actualiza el campo de bool con el valor que recibió, 
    //con await espera a que Firestore complete la operación antes de continuar
  }
  //Este método se encarga de marcar una tarea como completada o no, actualizando su estado en Firestore.
}