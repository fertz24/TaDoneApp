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

