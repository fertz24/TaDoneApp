import 'package:fer1/vista/home_vista.dart';
import 'package:fer1/vista/login_vista.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart'; //librería que permite inicializar y conectar la app (Flutter) con los servicios de Firebase

void main() async { //Funcion principal que arranca la aplicación y se pone como async porque va a ejecutar tareas que tardan un poco (como inicializar Firebase)

  WidgetsFlutterBinding.ensureInitialized();//Confirma que Flutter este listo antes de cualquier inicialización como en este caso Firebase
  //este es obligatorio ya que estamos usando a async
  debugPrint("Antes de Firebase.initializeApp"); //ayuda para el equipo sobre errores (no se muestran al usuario)
  await Firebase.initializeApp( //llama a Firebase para iniciar la conexión con el proyecto, 
  //utilizamos await indicando que el programa debe esperar a que el Firebase se encuentre listo antes de empezar. 

    options: const FirebaseOptions( //en este bloque empezamos a definir credenciales y configuración del proyecto que creamos en Firebase
    apiKey: "AIzaSyC5MW-8qSmUlhoD2manD-csclElOQBt8Ok",
    appId: "1:215244080211:android:a878ea192ee9fe378df2a6",
    messagingSenderId: "215244080211",
    projectId: "tadone-99353",
    storageBucket: "tadone-99353.appspot.com",
  ), //todas estas opciones son los datos que identifican a la aplicación en Firebase para así poder utilizar los servicios
 );
  debugPrint("Despues de Firebase.initializeApp"); //ayuda para el equipo sobre errores (no se muestran al usuario)

  runApp(MyApp()); //lanza la app en panralla, aquí empieza la interfaz
}

class MyApp extends StatelessWidget { 

  //Creamos una instancia unica de Firebase Auth para acceder a funciones el cual es verificar
  //si hay un usuario autenticado
  final FirebaseAuth _auth = FirebaseAuth.instance; 

    @override
    Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, 

      //Definimos la pantalla inciial de la app, si el usuario esta autenticado entonces muestra HomeVista
      //sino muestra loginVista
      home: _auth.currentUser != null ? HomeVista() : LoginVista(), 
      //con esta linea decimos que si _auth.currentUser no es null (sesión activa) entonces mostrará HomeVista
      //si es null (sesión no activa) entonces mostrará LoginVista
    );
  }
}