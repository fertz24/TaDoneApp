import 'package:cloud_firestore/cloud_firestore.dart';

class TodoModelo { 
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

  List<TodoModelo> todoListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) { 
      final data = doc.data() as Map<String, dynamic>; 

      return TodoModelo( 
        id: doc.id, 
        titulo: data['titulo'] ?? '', 
        descripcion: data['descripcion'] ?? '', 
        completado: data['completado'] ?? false, 
        timestamp: data['creadoA'] ?? Timestamp.now(), 
      );
    }).toList(); 
  }