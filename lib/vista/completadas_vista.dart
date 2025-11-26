import 'package:fer1/modelo/todo_modelo.dart';
import 'package:fer1/presentador/delete_todo_presentador.dart';
import 'package:fer1/presentador/update_todo_presentador.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class CompletadasVista extends StatefulWidget {
  const CompletadasVista({super.key});

  @override
  State<CompletadasVista> createState() => _CompletadasVistaState();
}

class _CompletadasVistaState extends State<CompletadasVista> {
  User? user = FirebaseAuth.instance.currentUser; 
  late String uid; 
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
      stream: _updateTodoPresentador.todosCompletados, 
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
                  color: Colors.white54, 
                  borderRadius: BorderRadius.circular(10),
                ),
                
                child: Slidable( 
                  key: ValueKey(todo.id), 
                  
                  endActionPane: ActionPane( 
                    motion: DrawerMotion(),
                    children: [ 
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
                        fontWeight: FontWeight.w500,
                        decoration: TextDecoration.lineThrough, 
                      ),
                    ),
                    subtitle: Text(
                      todo.descripcion, 
                      style: TextStyle(
                        decoration: TextDecoration.lineThrough, 
                      ),
                    ), 
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
}