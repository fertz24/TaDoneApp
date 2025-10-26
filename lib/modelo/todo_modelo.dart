import 'package:cloud_firestore/cloud_firestore.dart';

//Inicio del Todo

class TodoModelo { //Agregamos los campos de la tarea los cuales son los siguientes:
  final String id;
  final String titulo;
  final String descripcion;
  final bool completado;
  final Timestamp timestamp;

  TodoModelo ({
  required this.id, 
  required this.titulo, 
  required this.descripcion, 
  required this.completado, 
  required this.timestamp});
}


  //Función pública que recibe un QuerySnapshot (es el resultado de una consulta a Firestore)
  //y este devuelve una lista de objetos TodoModelo
  List<TodoModelo> todoListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) { //Se itera sobre cada documento en el snapshot usando un Map para transformarlo en objeto y luego se forma la lista
      final data = doc.data() as Map<String, dynamic>; //Extraemos los datos del documento como un mapa para poder acceder a los campos con su respectivo nombre

      return TodoModelo( //Creamos una instancia de TodoModelo con los datos del documento
        id: doc.id, 
        titulo: data['titulo'] ?? '', //Se pone ?? por si este no existe o es null entonces se pondrá una cadena vacía
        descripcion: data['descripcion'] ?? '', 
        completado: data['completado'] ?? false, //Si no (??) existe entonces pondrá false
        timestamp: data['creadoA'] ?? Timestamp.now(), //Sino (??) entonces pondrá la hora actual
      );
    }).toList(); //Convertimos el resultado del Map en una lista

    //¿Porqué en el modelo? esta función nos ayuda a convertir los datos en "crudo" de Firestore en objetos del modelo
    //entonces decimos que esta función es responsabilidad del modelo
  }