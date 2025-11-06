import 'package:fer1/modelo/todo_modelo.dart';
import 'package:fer1/presentador/create_todo_presentador.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class PendientesVista extends StatefulWidget {
  const PendientesVista({super.key});

  @override
  State<PendientesVista> createState() => _PendientesVistaState();
}

class _PendientesVistaState extends State<PendientesVista> {
  User? user = FirebaseAuth.instance.currentUser; //Obtenemos el usuario autenticado actual
  late String uid; //Declaramos una variable late la cual se inicializará después

  final CreateTodoPresentador _createTodoPresentador = CreateTodoPresentador(); //Instancia del presentador para poder manejar la lógica de agregar tareas

  @override
  void initState() {
    super.initState();
    uid = FirebaseAuth.instance.currentUser!.uid; //Obtenemos el UID del usuario autenticado y este se guardará en la variable uid
  }

  @override
  Widget build(BuildContext context) { //Pantalla de las tareas pendientes, en tiempo real
    return StreamBuilder<List<TodoModelo>>( //Escucha cambios en el stream de tareas (todos) y reconstruye la vista cuando hay nuevos datos
      stream: _createTodoPresentador.todos, //Conectamos el stream del presentador (el cual emite la lista de las tareas)
      builder: (context, snapshot) { //Definimos como mostrar los datos definidos
        if(snapshot.hasData) { //Condicional para verificar si hay tareas disponibles
          List<TodoModelo> todos = snapshot.data!; //Extraemos la lista de tareas de snapshot
          return ListView.builder( //Se crea una lista visual de widgets, cada vez que se crea una tarea
            shrinkWrap: true, //Para permitir que la tarea se ajuste al contenido (en vez de que ocupe todo el espacio)
            physics: NeverScrollableScrollPhysics(
                //Desactiva el scroll independiente de la lista
            ),
            itemCount: todos.length, //elemntos de la lista
            itemBuilder: (context, index) { //Define como construir cada elementos visual
              TodoModelo todo = todos[index]; //Para tomar la tarea en la posición actual de la lista
              final DateTime dt = todo.timestamp.toDate(); //Convierte el timestamp de la tarea en un objeto DateTime para mostrar la fecha
              return Container( //Diseño de cada tarea, se mostrará como tarjeta en color blanco
                margin: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white, 
                  borderRadius: BorderRadius.circular(10),
                ),
                  child: ListTile( //Usamos ListTile, este es un widget que organiza el contenido en una fila
                  //es ideal ya que representaremos cada tarea como una tarjeta simple y ordenada
                    title: Text(
                      todo.titulo, //Título de la tarea
                      style: TextStyle(
                        fontWeight: FontWeight.w500, 
                      ),
                    ),
                    subtitle: Text(
                      todo.descripcion, //Descipción de la tarea
                    ),
                    trailing: Text(
                      '${dt.day}/${dt.month}/${dt.year}', //Formato de fecha
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              
            );
          },
        );
        } else {
          return Center(child: CircularProgressIndicator(color: Colors.white)); //Circulo girando (efecto) para indicar que está cargando las tareas
        }
      },
    );
  }
}