import 'package:fer1/modelo/todo_modelo.dart';
import 'package:fer1/presentador/create_todo_presentador.dart';
import 'package:fer1/presentador/delete_todo_presentador.dart';
import 'package:fer1/presentador/update_todo_presentador.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class PendientesVista extends StatefulWidget {
  const PendientesVista({super.key});

  @override
  State<PendientesVista> createState() => _PendientesVistaState();
}

class _PendientesVistaState extends State<PendientesVista> {
  User? user = FirebaseAuth.instance.currentUser; //Obtenemos el usuario autenticado actual
  late String uid; //Declaramos una variable late la cual se inicializará después

  final CreateTodoPresentador _createTodoPresentador = CreateTodoPresentador(); //Instancia del presentador para poder manejar la lógica de agregar tareas
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
                
                child: Slidable( //Permite dezlizar horizontalmente un elemento (la tarea) para poder mostrar las acciones de editar/eliminar
                  key: ValueKey(todo.id), //Se asigna una clave única con todo.id, lo cual ayuda a Flutter el identificar y manejar de forma correcta el Widget cuando se reconstruye la interfaz (se evitan errores visuales o de estado)
                  
                  endActionPane: ActionPane( //Definimos el panel de acciones que es para deslizar el elemento a la IZQUIERDA
                    motion: DrawerMotion(), //Establecemos la animación del deslizamiento tipo "cajón"
                    children: [ //Lista de las acciones
                      SlidableAction( 
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                        icon: Icons.done, //Para marcar la tarea como completada, el ícono de palomita
                        label: "Mark",
                        onPressed: (context) {
                        _updateTodoPresentador.editarTodoEstado(todo.id, true); //Utilizamos el estado de la tarea como completada usando el id
                      })
                    ],
                  ),
                  startActionPane: ActionPane( //Definimos el panel de acciones que es para dezlizar el elemento a la DERECHA
                    motion: DrawerMotion(), 
                    children: [
                      SlidableAction(
                        backgroundColor: Colors.amber,
                        foregroundColor: Colors.white,
                        icon: Icons.edit, //Ícono de lápiz para editar tarea
                        label: "Edit",
                        onPressed: (context) {
                        _mostrarTarea(context, todo: todo); //Llamamos a la función de _mostrarTarea y el objeto todo, 
                        //el cual nos ayuda a abrir el popup de edición con los datos de esa tarea (todo) ya cargados para asi poder editar dicha tarea

                      }),
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
                        fontWeight: FontWeight.w500),
                    ),
                    subtitle: Text(todo.descripcion), //Descipción de la tarea
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

  void _mostrarTarea(BuildContext context, {TodoModelo? todo}) { //Función del onPressed
    //el segundo parámetro es para que la función sepa si debe mostrar una tarea existente para poder editarla
    //o en el caso contrario es crear una nueva tarea (todo es null), esta función sirve para ambos casos

      //Dentro de los paréntesis se asigna un valor inicial al controlador del texto, si todo NO es null entonces se usa todo.titulo/descripcion (editar tarea) o SI es null entonces el campo queda vacío (crear tarea)
      final TextEditingController _tituloControlador = TextEditingController(text: todo?.titulo); //Creamos un controlador para poder capturar lo que el usuario escribe en los campos de título y descripción
      final TextEditingController _descripcionControlador = TextEditingController(text: todo?.descripcion); //Para la descripción de la tarea
      final CreateTodoPresentador _presentador = CreateTodoPresentador(); //Instanciamos la clase del create_todo_presentador para poder llamar a crearTodo si el usuario guarda la tarea
      final UpdateTodoPresentador _update = UpdateTodoPresentador(); //Instanciamos la clase de update_todo_presentador para llamar a update para editar la tarea

      showDialog( //Para el popup
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: Colors.white,
            title: Text(todo == null ? "Add Task" : "Edit Task", //If ternario para decidir que texto mostrar
            //Si todo es null entonces significa que se esta creando una nueva tarea (Add Task) o si todo tiene datos entonces se está editando una tarea existente (Edit Task)

            style: TextStyle(
              fontWeight: FontWeight.w500,
            ),
          ),
          content: SingleChildScrollView( //permitimos que el contenido del popup sea desplazable (este evita errores de desbordamiento en pantallas pequeñas)
            child: Container(
              width: MediaQuery.of(context).size.width,
              child: Column( //Organiza widgets en forma vertical
                children: [
                  TextField(
                    controller: _tituloControlador,
                    decoration: InputDecoration(
                      labelText: "Title", 
                      border: OutlineInputBorder(), //dibuja un borde rectangular con esquinas redondeadas alrededor de un campo de texto
                    ),
                  ),
                  SizedBox(height: 10),
                    TextField(
                    controller: _descripcionControlador,
                    decoration: InputDecoration(
                      labelText: "Description", 
                      border: OutlineInputBorder(),
                    ),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(onPressed: () {
              Navigator.pop(context);
            }, 
            child: Text("Cancel"),
            ),
            ElevatedButton( //Botón para guardar la tarea
            style: ElevatedButton.styleFrom( //Estilo del botón Add
              backgroundColor: Colors.indigo, 
              foregroundColor: Colors.white,
            ),
              onPressed: () async {
                if(todo == null) { //Verificamos si no se pasó una tarea existente
                //Si es null significa que se está creando una nueva tarea

                  await _presentador.crearTodo( //Llamamos al método crearTodo del presentador, enviando el texto que el usuario escribio en los campos de...
                  _tituloControlador.text, //título de la tarea (captura el texto)
                  _descripcionControlador.text); //descripción de la tarea
                } else {
                  //En else, si hay una tarea entonces se está editando una ya existente llamando al editarTodo usando el id y los nuevos valores
                  await _update.editarTodo(todo.id, _tituloControlador.text, _descripcionControlador.text);
                }
                Navigator.pop(context); //Cierra el popup después de guardar la tarea
              },
              child: Text(todo == null ? "Add" : "Update"), //Mostrará el texto "Add" si todo es null (crear tarea) o "Update" si todo tiene datos (editar tarea)
            )
          ],
        );
      },
    );
  }
}