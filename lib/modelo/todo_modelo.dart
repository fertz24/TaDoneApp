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