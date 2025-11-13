import 'package:fer1/modelo/todo_modelo.dart';
import 'package:fer1/presentador/delete_todo_presentador.dart';
import 'package:fer1/presentador/update_todo_presentador.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class CompletadasVista extends StatefulWidget {
  const CompletadasVista({super.key});

  @override
  State<CompletadasVista> createState() => _PendientesVistaState();
}

class _PendientesVistaState extends State<CompletadasVista> {
  User? user = FirebaseAuth.instance.currentUser; //Obtenemos el usuario autenticado actual
  late String uid; //Declaramos una variable late la cual se inicializará después

  final UpdateTodoPresentador _updateTodoPresentador = UpdateTodoPresentador(); //Instancia del update_presentador para manejar la lógica de editar tareas
  final DeleteTodoPresentador _deleteTodoPresentador = DeleteTodoPresentador(); //Instancia del delete_presentador para eliminar las tareas

  @override
  void initState() {
    super.initState();
    uid = FirebaseAuth.instance.currentUser!.uid; //Obtenemos el UID del usuario autenticado y este se guardará en la variable uid
  }

  @override
  Widget build(BuildContext context) { //Pantalla de las tareas pendientes, en tiempo real
    return StreamBuilder<List<TodoModelo>>( //Escucha cambios en el stream de tareas (todos) y reconstruye la vista cuando hay nuevos datos
      stream: _updateTodoPresentador.todosCompletados, //Conectamos la vista con el Stream (todosCompletados), cada vez que se marque la tarea como completada, la lista se actualiza automáticamente en la pantalla
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
                  color: Colors.white54, //Más oscuro
                  borderRadius: BorderRadius.circular(10),
                ),
                
                child: Slidable( //Permite dezlizar horizontalmente un elemento (la tarea) para poder mostrar las acciones de editar/eliminar
                  key: ValueKey(todo.id), //Se asigna una clave única con todo.id, lo cual ayuda a Flutter el identificar y manejar de forma correcta el Widget cuando se reconstruye la interfaz (se evitan errores visuales o de estado)
                  
                  endActionPane: ActionPane( //Definimos el panel de acciones que es para deslizar el elemento a la IZQUIERDA
                    motion: DrawerMotion(), //Establecemos la animación del deslizamiento tipo "cajón"
                    children: [ //Lista de las acciones
                      SlidableAction(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                        icon: Icons.delete, //Ícono de basura para eliminar tarea
                        label: "Delete",
                        onPressed: (context) async{
                          await _deleteTodoPresentador.eliminarTodo(todo.id); //Al presionar el botón se llama el método de eliminarTodo pasando el id para poder borrar la tarea
                      })
                    ],
                  ),
                  
                  child: ListTile( //Usamos ListTile, este es un widget que organiza el contenido en una fila
                  //es ideal ya que representaremos cada tarea como una tarjeta simple y ordenada
                    title: Text(
                      todo.titulo, //Título de la tarea
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        decoration: TextDecoration.lineThrough, //Pone una línea sobre el título (simulando que ya fue hecha una vez que esta en la vista de completadas)
                      ),
                    ),
                    subtitle: Text(
                      todo.descripcion, //Descipción de la tarea
                      style: TextStyle(
                        decoration: TextDecoration.lineThrough, //Pone una línea sobre la descripción
                      ),
                    ), 
                    trailing: Text('${dt.day}/${dt.month}/${dt.year}', //Formato de fecha
                      style: TextStyle(
                        fontWeight: FontWeight.bold),
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