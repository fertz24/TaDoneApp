import 'package:fer1/vista/login_vista.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomeVista extends StatefulWidget {
  const HomeVista ({super.key});

  @override
  State<HomeVista> createState() => _HomeVistaState();
}
  
class _HomeVistaState extends State<HomeVista> { 
  
    int _botonIndice = 0; //variable que indica que el boton esta activo
    //0 = pendientes, 1 = completadas

    final _widgets = [ //lista de widgets
      
      //Widget para tareas pendientes
      Container(), 

      //Widget para tareas completadas
      Container(),

    ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.indigo,
      appBar: AppBar(
        backgroundColor: Color(0xFF1d2630),
        foregroundColor: Colors.white,
        title: Text("To Do"),
        actions: [ //Boton para cerrar sesion donde, al presionarlo se cerrara la sesion con Firebase
          IconButton(
            onPressed: () async {
              await FirebaseAuth.instance.signOut(); //para salir de la sesion
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => LoginVista())); //una vez que sale entonces, se redirige al loginVista
            },
            icon: Icon(Icons.exit_to_app), //icono de salir de la sesion
          )
        ],
      ),
      body: SingleChildScrollView( //permite desplazamiento vertical
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20),
            Row( //boton para tareas pendientes
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                InkWell(
                  onTap: () {
                    setState(() {
                      _botonIndice = 0; //cuando se presiona el boton para tareas pendientes, el indice cambia a 0
                    });
                  },
                  child: Container( //estilo del boton
                    height: 50,
                    width: MediaQuery.of(context).size.width / 2.2,
                    decoration: BoxDecoration(
                      color: _botonIndice == 0 ? Colors.indigo : Colors.white, //cambia el color y tamaño (si esta activo)
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
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}