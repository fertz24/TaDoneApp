//import 'package:fer1/main.dart';
import 'package:fer1/vista/home_vista.dart';
import 'package:fer1/vista/register_vista.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fer1/presentador/login_presentador.dart';
//los package nos proporcionan todo lo que necesitamos para Firebase, 
//material de Flutter para UI asi como nuestras pantallas.

class LoginVista extends StatefulWidget {
  const LoginVista({super.key});
 //se usa un StatefulWidget porque el estado cambiara 
  //clase para la pantalla del log in.

  @override
  State createState() {
    return _LoginState(); //para crear un estado asociado a la pantalla de _loginState
  }
}

class _LoginState extends State<LoginVista> { //logica y diseño de la pantalla

  late String email, password; //variables para guardar lo que el usuario escriba en los campos.
  final _formKey = GlobalKey<FormState>(); //controla el formulario y validar sus campos.
  //con GlobalKey estamos creando una clave única que nos permite controlar el formulario desde afuera del widget
  //

  final LoginPresentador _presentador = LoginPresentador(); //instancia del presentador, este manejará la lógica del login
  String error = ''; //variable para guardar el mensaje de error por si algo falla. 
  
  @override 
  void initState() {//este método se ejecuta al iniciar la pantalla
    super.initState();

  }

  @override 
  Widget build(BuildContext context) {//build construye nuestra interfaz
    debugPrint("Entrando a la login_vista"); //este mensaje es para poder ver en la consola que si esta entrando correctamente a esta pantalla (ayuda del equipo)

    return Scaffold( //estructura base de la pantalla
      backgroundColor: Colors.indigo,
      body: Column( //con column organiza los widgets de forma vertical
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center, //para centrar verticalmente
        children: [ //children es una propiedad que recibe una lista de widgets dentro del contenedor como Column, row, entre otros
          Padding( //agrega espacio alrededor del widget
            padding: const EdgeInsets.all(16.0), //el espacio se define por 16 pixeles en todos los lados
            child: Column( //widget, aqui se aplicará el espacio
              children: [
            Text("Welcome back!", style: TextStyle(color: Colors.white, fontSize: 20)),
            Text("Log in here", style: TextStyle(color: Colors.white, fontSize: 20)),
              ],)
            ),
            Offstage( //nos ayuda a ocultar el contenido si es que error está vacío
              offstage: error == '',
            ),
            
            Padding( //aquí estamos declarando el mensaje de error en color rojo si es que existe
              padding: const EdgeInsets.all(8.0),
              child: Text(error, style: TextStyle(color: Colors.red, fontSize: 16),),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: formulario(),//llamamos al método de formulario el cual tiene los campos de email y contraseña
            ),
          buttonLogin(), //llamado al método de buttonLogin
          nuevousuario(), //llamado al método para ir a la pantalla de registro de usuarios
        ],
      ),
    );
  }

  Widget nuevousuario() { //método para registrar usuario
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(height: 8),
        Text("OR", style: TextStyle(fontSize: 16, color: Colors.white)),
        SizedBox(height: 5),
        TextButton(onPressed: () { //este es el botón que llevará al usuario a la pantalla de registrar usuario
          Navigator.push(context, MaterialPageRoute(builder: (context) => RegisterVista())); //vista del register_vista
        }, child: Text("Create account", style: TextStyle(fontSize: 20, color: Colors.white)),
        )
      ],
    );
  }

  Widget formulario() {
    return Form( //form nos ayuda a agrupar los campos y permite validarlos
      key: _formKey,
      child: Column(children: [
        buildEmail(), //hacemos llamado al método de email
        const Padding(padding: EdgeInsets.only(top: 12)),
        buildPassword() //hacemos llamado al método de contraseña
      ],
    )
  );
}

  Widget buildEmail() { //método para el correo
    return TextFormField( //para devolver el campo de texto con la validacion y al mismo tiempo formato
      style: TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: "Email",
        labelStyle: TextStyle(color: Colors.white70),
        filled: true,
        fillColor: Colors.indigo[700],
        border: OutlineInputBorder(
          borderRadius: new BorderRadius.circular(8),
          borderSide: new BorderSide(color: Colors.white)
        )
      ),
      keyboardType: TextInputType.emailAddress,
      onSaved: (String? value){ //aquí estamos guardando el valor de la variable email
        email = value!;
      },
      validator: (value){ //verificamos que el campo no este vacío
        if(value!.isEmpty) {
          return "Este campo es obligatorio";
        }
        return null;
      },
    );
  }

  Widget buildPassword() { //método para la contraseña, permite 6 caracteres.
    return TextFormField(
      style: TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: "Password",
        labelStyle: TextStyle(color: Colors.white70),
        filled: true,
        fillColor: Colors.indigo[700],
        border: OutlineInputBorder(
          borderRadius: new BorderRadius.circular(8),
          borderSide: new BorderSide(color: Colors.white)
        )
      ),
      obscureText: true, //con este comando ocultamos la contraseña
      validator: (value){ //verificamos igual que el campo no este vacío
        if(value!.isEmpty) {
          return "Este campo es obligatorio";
        }
        return null;
      },
      onSaved: (String? value) {
        password = value!;
      }
    );
  }

  Widget buttonLogin() {
    return FractionallySizedBox( //para ajustar el tamaño del hijo (elevatedButton) según el procentaje del tamaño disponible
      widthFactor: 0.6,
    child: ElevatedButton( //aquí se valida el formulario
      onPressed: () async{ //con async decimos que se pueden ejecutar tareas asíncronas (validar el form, esperar a Firebase)

        if(_formKey.currentState!.validate()) { //para validar el formulario, con ! aseguramos que el valor no es nulo
          _formKey.currentState!.save(); //si se valida, entonces guarda los datos (correo y contraseña)
          
            try { 
                UserCredential? credenciales = await _presentador.login(email, password); //llamamos al método login del presentador (el que usa Firebase para iniciar sesión)
                  if(credenciales !=null && credenciales.user != null) {//verificamos que el resultado del login NO SEA NULL y que tenga un usuario válido (esto nos confirma que el login fue con éxito)

                      Navigator.pushAndRemoveUntil( //inicia la navegación a otra pantalla, el push no solo abre otra pantalla sino que borra el historial anterior para que el usuario no pueda regresar a la pantalla con el botón del celular de retroceso
                      context, //necesario para saber en que parte de la app estamos navegando
                      MaterialPageRoute(builder: (context) => HomeVista()), //pantalla temporal (para sprint 1)
                      (Route<dynamic> route) => false, //en esta función le decimos a Navigator que elimine todas las rutas anteriores para dejar solamente la pantalla de las tareas del usuario que accedió
                      //con false quiere decir que ninguna ruta anterior debe conservarse (pantalla login en este caso)
                    );
                  }
          } on FirebaseAuthException catch (e) { //si ocurre algún error se captura y se mostrará mensaje al usaurio según el error
            debugPrint("Código de error: ${e.code}"); //por si ocurre algún error en la terminal (esto no se muestra al usuario)
            debugPrint("Tipo de error: ${e.runtimeType}"); //""

            setState(() { //mensajes de los posibles errores que pueden existir dentro de la aplicación
              if(e.code == 'user-not-found' || e.code == 'wrong-password' || e.code == 'invalid-credential'){ 
                error = "Credenciales inválidas";
              } else {
                error = "Error inesperado";
              }
            });
          }
        }    
      },
    child: Text("Login")//texto del boton
      ), 
    );
  }
}