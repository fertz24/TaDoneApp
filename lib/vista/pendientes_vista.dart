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
  User? user = FirebaseAuth.instance.currentUser; 
  late String uid; 

  final CreateTodoPresentador _createTodoPresentador = CreateTodoPresentador(); 
  final UpdateTodoPresentador _updateTodoPresentador = UpdateTodoPresentador(); 
  final DeleteTodoPresentador _deleteTodoPresentador = DeleteTodoPresentador(); 

  @override
  void initState() {
    super.initState();
    uid = FirebaseAuth.instance.currentUser!.uid; 
  }

  @override
  Widget build(BuildContext context) { 
    return StreamBuilder<List<TodoModelo>>(
      stream: _createTodoPresentador.todos, 
      builder: (context, snapshot) { 
        if(snapshot.hasData) { 
          List<TodoModelo> todos = snapshot.data!; 
          return ListView.builder( 
            shrinkWrap: true, 
            physics: NeverScrollableScrollPhysics(
          
            ),
            itemCount: todos.length, 
            itemBuilder: (context, index) { 
              TodoModelo todo = todos[index]; 
              final DateTime dt = todo.timestamp.toDate(); 
              return Container( 
                margin: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white, 
                  borderRadius: BorderRadius.circular(10),
                ),
                
                child: Slidable( 
                  key: ValueKey(todo.id), 
                  
                  endActionPane: ActionPane( 
                    motion: DrawerMotion(), 
                    children: [ 
                      SlidableAction( 
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                        icon: Icons.done, 
                        label: "Mark",
                        onPressed: (context) {
                        _updateTodoPresentador.editarTodoEstado(todo.id, true); 
                      })
                    ],
                  ),
                  startActionPane: ActionPane( 
                    motion: DrawerMotion(), 
                    children: [
                      SlidableAction(
                        backgroundColor: Colors.amber,
                        foregroundColor: Colors.white,
                        icon: Icons.edit, 
                        label: "Edit",
                        onPressed: (context) {
                        _mostrarTarea(context, todo: todo); 
                      }),
                      SlidableAction(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                        icon: Icons.delete, 
                        label: "Delete",
                        onPressed: (context) async{
                          await _deleteTodoPresentador.eliminarTodo(todo.id); 
                      })
                    ],
                  ),
                  child: ListTile( 
                    title: Text(
                      todo.titulo, 
                      style: TextStyle(
                        fontWeight: FontWeight.w500),
                    ),
                    subtitle: Text(todo.descripcion), 
                    trailing: Text('${dt.day}/${dt.month}/${dt.year}', 
                      style: TextStyle(
                        fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              );
            },
          );
        } else {
          return Center(child: CircularProgressIndicator(color: Colors.white)); 
        }
      },
    );
  }

  void _mostrarTarea(BuildContext context, {TodoModelo? todo}) { 

      final TextEditingController _tituloControlador = TextEditingController(text: todo?.titulo);
      final TextEditingController _descripcionControlador = TextEditingController(text: todo?.descripcion); 
      final CreateTodoPresentador _presentador = CreateTodoPresentador(); 
      final UpdateTodoPresentador _update = UpdateTodoPresentador(); 

      showDialog( //Para el popup
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: Colors.white,
            title: Text(todo == null ? "Add Task" : "Edit Task", 

            style: TextStyle(
              fontWeight: FontWeight.w500,
            ),
          ),
          content: SingleChildScrollView( 
            child: Container(
              width: MediaQuery.of(context).size.width,
              child: Column( 
                children: [
                  TextField(
                    controller: _tituloControlador,
                    decoration: InputDecoration(
                      labelText: "Title", 
                      border: OutlineInputBorder(), 
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
            ElevatedButton( 
            style: ElevatedButton.styleFrom( 
              backgroundColor: Colors.indigo, 
              foregroundColor: Colors.white,
            ),
              onPressed: () async {
                if(todo == null) { 

                  await _presentador.crearTodo( 
                  _tituloControlador.text, 
                  _descripcionControlador.text); 
                } else {
                  await _update.editarTodo(todo.id, _tituloControlador.text, _descripcionControlador.text);
                }
                Navigator.pop(context); 
              },
              child: Text(todo == null ? "Add" : "Update"), 
            )
          ],
        );
      },
    );
  }
}