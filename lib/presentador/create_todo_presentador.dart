import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fer1/modelo/todo_modelo.dart';
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
        'creadoA': FieldValue.serverTimestamp(), //Se guarda la fecha y hora del servidor al momento de crearse
    });
  }

  //Para obtener tareas pendientes
  Stream<List<TodoModelo>> get todos{ //Con Stream se emiten los datos (en este caso la lista) en tiempo real (nos permite que la app tenga actualzaciones de forma automática cuando cambian los datos en Firebase)
    
    return todoCollection.where('uid', isEqualTo: user!.uid).where('completado', //Se filtra la colección para obtener solo los documentos donde el uid coincida con el usuario actual
            isEqualTo: false).snapshots().map(todoListFromSnapshot); //Ponemos otro filtro para poder obtener solamente las tareas no completadas (por eso false)
            //.snapshots() escuchará los cambios en tiempo real de la consulta filtrada
            //.map(todoListFromSnapShot) convierte cada QuerySnapshot en una lista de objetos (TodoModelo) utilizando la función del modelo
  }
  //En el presentador solo pedirá los datos ya transformados y listos para la vista
}