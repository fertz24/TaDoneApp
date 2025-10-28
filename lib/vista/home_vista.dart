//import 'package:fer1/vista/login_vista.dart';
//import 'package:fer1/modelo/todo_modelo.dart';
import 'package:fer1/presentador/create_todo_presentador.dart';
import 'package:flutter/material.dart';
//import 'package:firebase_auth/firebase_auth.dart';

class HomeVista extends StatefulWidget {
  const HomeVista ({super.key});

  @override
  State<HomeVista> createState() => _HomeVistaState();
}
  
class _HomeVistaState extends State<HomeVista> { 
    
    int _botonIndice = 0; //variable que indica que el boton esta activo
    //0 = pendientes, 1 = completadas
    
    final _widgets = [
      //Tareas pendientes widget
      Container()
    ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF1d2630), 
      appBar: AppBar(
        backgroundColor: Color(0xFF1d2630),
        foregroundColor: Colors.white,
        title: Text("To Do"),
        actions: [ //Boton para cerrar sesion donde, al presionarlo se cerrara la sesion con Firebase
          IconButton(
            onPressed: null,
            //onPressed: () async {
              //await FirebaseAuth.instance.signOut(); //para salir de la sesion
              //Navigator.pushReplacement(context,
                  //MaterialPageRoute(builder: (context) => LoginVista())); //una vez que sale entonces, se redirige al loginVista
            //},
            icon: Icon(Icons.exit_to_app, color: Colors.white) //icono de salir de la sesion
          )
        ],
      ),
      body: SingleChildScrollView( //permite desplazamiento vertical, evita overflows (que el contenido no quepa en la pantalla)
      //util para pantallas con botones que cambiaran dinamicamente (en este caso tareas pendientes y completadas)
        
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20),
            Row( //boton para tareas pendientes
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                InkWell( //InkWell detecta movimientos tactiles (como una animacion para cuando el usuario interactue con el boton)
                  borderRadius: BorderRadius.circular(10),
                  onTap: () {
                    setState(() {
                      _botonIndice = 0; //cuando se presiona el boton para tareas pendientes, el indice cambia a 0
                    });
                  },
                  child: Container( //estilo del boton
                    height: 50, 
                    width: MediaQuery.of(context).size.width / 2.2, //tamaño de casi la mitad de la pantalla
                    decoration: BoxDecoration(
                      color: _botonIndice == 0 ? Colors.indigo : Colors.white, //si es 0 (activo) entonces es color Indigo sino entonces sera color blanco
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center( //texto del boton con un estilo (si esta seleccionado)
                      child: Text(
                        "Pending",
                        style: TextStyle(
                          fontSize: _botonIndice == 0 ? 16 : 14, //si el boton es 0 entonces la fuente sera de tamaño 16 sino tamaño 14
                          //para resaltar el boton cuando esta activo 
                          fontWeight: FontWeight.w500,
                          color: 
                              _botonIndice == 0 ? Colors.white : Colors.black38, //si el boton es 0 (activo) el texto es blanco sino sera gris oscuro
                        ),
                      ),
                    ),
                  ),
                ),
                
                //boton de tareas completadas
                InkWell( //InkWell detecta movimientos tactiles (como una animacion para cuando el usuario interactue con el boton)
                  borderRadius: BorderRadius.circular(10),
                  onTap: () {
                    setState(() {
                      _botonIndice = 1; //cuando se presiona el boton para tareas completadas, el indice cambia a 1
                    });
                  },
                  child: Container( //estilo del boton
                    height: 50,
                    width: MediaQuery.of(context).size.width / 2.2,
                    decoration: BoxDecoration(
                      color: _botonIndice == 1 ? Colors.indigo : Colors.white, //si es 1 (activo) entonces es color Indigo sino entonces sera color blanco
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center( //texto del boton con un estilo (si esta seleccionado)
                      child: Text(
                        "Completed",
                        style: TextStyle(
                          fontSize: _botonIndice == 1 ? 16 : 14, //si el boton es 1 entonces la fuente sera de tamaño 16 sino tamaño 14
                          //para resaltar el boton cuando esta activo 
                          fontWeight: FontWeight.w500,
                          color: 
                              _botonIndice == 1 ? Colors.white : Colors.black38, //si el boton es 1 (activo) el texto es blanco sino sera gris oscuro
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
    void _mostrarTarea(BuildContext context) { //Funcion del onPressed
      final TextEditingController _tituloControlador = TextEditingController(); //Creamos un controlador para poder capturar lo que el usuario escribe en los campos de titulo y descripcion
      final TextEditingController _descripcionControlador = TextEditingController(); //Para la descripcion de la tarea
      final CreateTodoPresentador _presentador = CreateTodoPresentador(); //Instanciamos la clase del create_todo_presentador para poder llamar a crearTodo si el usuario guarda la tarea

      showDialog( //Para el popup
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: Colors.white,
            title: Text("Add Task",
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
            ElevatedButton( //Boton para guardar la tarea
            style: ElevatedButton.styleFrom( //Estilo del boton Add
              backgroundColor: Colors.indigo, 
              foregroundColor: Colors.white,
            ),
              onPressed: () async {
                await _presentador.crearTodo( //Llamamos al metodo crearTodo del presentador, enviando el texto que el usuario escribio en los campos de...
                  _tituloControlador.text, //titulo de la tarea (captura el texto)
                  _descripcionControlador.text, //descripcion de la tarea
                );
                Navigator.pop(context); //Cierra el popup despues de guardar la tarea
              },
              child: Text("Add"),
            )
          ],
        );
      },
    );
  }
}