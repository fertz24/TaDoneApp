import 'package:fer1/vista/login_vista.dart';
import 'package:fer1/modelo/todo_modelo.dart';
import 'package:fer1/presentador/create_todo_presentador.dart';
import 'package:fer1/presentador/update_todo_presentador.dart';
import 'package:fer1/vista/completadas_vista.dart';
import 'package:fer1/vista/pendientes_vista.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomeVista extends StatefulWidget {
  const HomeVista ({super.key});

  @override
  State<HomeVista> createState() => _HomeVistaState();
}
  
class _HomeVistaState extends State<HomeVista> { 
    
    int _botonIndice = 0; 
    
    final List <Widget> _widgets = [ 
      PendientesVista(), 
      CompletadasVista(),
    ];
    
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF1d2630), 
      appBar: AppBar(
        backgroundColor: Color(0xFF1d2630),
        foregroundColor: Colors.white,
        title: Text("To Do"),
        actions: [ 
          IconButton(
            onPressed: () async {
              await FirebaseAuth.instance.signOut(); 
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => LoginVista())); 
            },
            icon: Icon(Icons.exit_to_app, color: Colors.white) 
          )
        ],
      ),
      body: SingleChildScrollView( 
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20),
            Row( 
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                InkWell( 
                  borderRadius: BorderRadius.circular(10),
                  onTap: () {
                    setState(() {
                      _botonIndice = 0; 
                    });
                  },
                  child: Container( 
                    height: 50, 
                    width: MediaQuery.of(context).size.width / 2.2, 
                    decoration: BoxDecoration(
                      color: _botonIndice == 0 ? Colors.indigo : Colors.white,  
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center( 
                      child: Text(
                        "Pending",
                        style: TextStyle(
                          fontSize: _botonIndice == 0 ? 16 : 14, 
                          fontWeight: FontWeight.w500,
                          color: 
                              _botonIndice == 0 ? Colors.white : Colors.black38, 
                        ),
                      ),
                    ),
                  ),
                ),
                
                
                InkWell( 
                  borderRadius: BorderRadius.circular(10),
                  onTap: () {
                    setState(() {
                      _botonIndice = 1; 
                    });
                  },
                  child: Container( 
                    height: 50,
                    width: MediaQuery.of(context).size.width / 2.2,
                    decoration: BoxDecoration(
                      color: _botonIndice == 1 ? Colors.indigo : Colors.white,  
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center( 
                      child: Text(
                        "Completed",
                        style: TextStyle(
                          fontSize: _botonIndice == 1 ? 16 : 14, 
                          fontWeight: FontWeight.w500,
                          color: 
                              _botonIndice == 1 ? Colors.white : Colors.black38, 
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
            SizedBox(height: 30),
              _widgets[_botonIndice], 
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        onPressed: () {
          _mostrarTarea(context);
        }, 
        child: Icon(Icons.add),
      ),
    );
  }
    void _mostrarTarea(BuildContext context, {TodoModelo? todo}) { 

      final TextEditingController _tituloControlador = TextEditingController(text: todo?.titulo); 
      final TextEditingController _descripcionControlador = TextEditingController(text: todo?.descripcion); 
      final CreateTodoPresentador _presentador = CreateTodoPresentador(); 
      final UpdateTodoPresentador _update = UpdateTodoPresentador(); 

      showDialog( 
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
      }
    );
  }
}