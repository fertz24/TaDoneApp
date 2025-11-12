//import 'package:fer1/vista/login_vista.dart';
import 'package:fer1/modelo/todo_modelo.dart';
import 'package:fer1/presentador/create_todo_presentador.dart';
import 'package:fer1/presentador/update_todo_presentador.dart';
import 'package:fer1/vista/completadas_vista.dart';
import 'package:fer1/vista/pendientes_vista.dart';
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
    
    final List <Widget> _widgets = [ //Declaramos una lista fija de widgets
      //Tareas pendientes widget
      PendientesVista(), 

      //Tareas completadas widget
      CompletadasVista(),
    ];
    //Esta lista guarda los 2 widgets principales los cuales son las tareas completadas y pendiente, 
    //Se usa junto con el _boton indice para mostrar dinámicamente uno u otro según lo que presione el usuario

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
              _widgets[_botonIndice], //Accedemos a _widgets según el valor del _botonIndice
              //Si es 0 muestra PendientesVista o si es 1 entonces CompletadasVista
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