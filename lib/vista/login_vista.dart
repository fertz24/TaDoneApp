//import 'package:fer1/main.dart';
import 'package:fer1/vista/home_vista.dart';
import 'package:fer1/vista/register_vista.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fer1/presentador/login_presentador.dart';


class LoginVista extends StatefulWidget {
  const LoginVista({super.key});

  @override
  State createState() {
    return _LoginState(); 
  }
}

class _LoginState extends State<LoginVista> { 

  late String email, password; 
  final _formKey = GlobalKey<FormState>(); 
 
  final LoginPresentador _presentador = LoginPresentador(); 
  String error = ''; 
  
  @override 
  void initState() {
    super.initState();

  }

  @override 
  Widget build(BuildContext context) {
    debugPrint("Entrando a la login_vista"); 

    return Scaffold( 
      backgroundColor: Colors.indigo,
      body: Column( 
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center, 
        children: [ 
          Padding( 
            padding: const EdgeInsets.all(16.0), 
            child: Column( 
              children: [
            Text("Welcome back!", style: TextStyle(color: Colors.white, fontSize: 20)),
            Text("Log in here", style: TextStyle(color: Colors.white, fontSize: 20)),
              ],)
            ),
            Offstage( 
              offstage: error == '',
            ),
            
            Padding( 
              padding: const EdgeInsets.all(8.0),
              child: Text(error, style: TextStyle(color: Colors.red, fontSize: 16),),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: formulario(),
            ),
          buttonLogin(),
          nuevousuario(), 
        ],
      ),
    );
  }

  Widget nuevousuario() { 
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(height: 8),
        Text("OR", style: TextStyle(fontSize: 16, color: Colors.white)),
        SizedBox(height: 5),
        TextButton(onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => RegisterVista())); 
        }, child: Text("Create account", style: TextStyle(fontSize: 20, color: Colors.white)),
        )
      ],
    );
  }

  Widget formulario() {
    return Form( 
      key: _formKey,
      child: Column(children: [
        buildEmail(),
        const Padding(padding: EdgeInsets.only(top: 12)),
        buildPassword() 
      ],
    )
  );
}

  Widget buildEmail() { 
    return TextFormField( 
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
      onSaved: (String? value){ 
        email = value!;
      },
      validator: (value){ 
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
      obscureText: true, 
      validator: (value){ 
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
    return FractionallySizedBox( 
      widthFactor: 0.6,
    child: ElevatedButton( 
      onPressed: () async{ 

        if(_formKey.currentState!.validate()) { 
          _formKey.currentState!.save(); 
          
            try { 
                UserCredential? credenciales = await _presentador.login(email, password); 
                  if(credenciales !=null && credenciales.user != null) {//verificamos que el resultado del login NO SEA NULL y que tenga un usuario válido (esto nos confirma que el login fue con éxito)

                      Navigator.pushAndRemoveUntil( //inicia la navegación a otra pantalla, el push no solo abre otra pantalla sino que borra el historial anterior para que el usuario no pueda regresar a la pantalla con el botón del celular de retroceso
                      context, //necesario para saber en que parte de la app estamos navegando
                      MaterialPageRoute(builder: (context) => HomeVista()), //pantalla home (sprint 2)
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