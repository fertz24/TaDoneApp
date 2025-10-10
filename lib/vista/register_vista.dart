import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fer1/presentador/register_presentador.dart';

class register_vista extends StatefulWidget {

  @override
  State createState() {
    return _RegisterState();
  }
}

class _RegisterState extends State<register_vista> {

  late String email, password;
  final _formKey = GlobalKey<FormState>();
  final RegisterPresentador _presentador = RegisterPresentador(); //instancia del presentador
  String error = '';
  
  @override 
  void initState() {
    super.initState();

  }

  @override 
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.indigo,
      appBar: AppBar(
        title: Text("Login to Ta'Done", style: TextStyle(color: Colors.white, fontSize: 18)),
        backgroundColor: Colors.indigo,
        iconTheme: IconThemeData(color: Colors.white),
        toolbarHeight: 40,
      ),

      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
            Text("Welcome to Ta'Done!", style: TextStyle(color: Colors.white, fontSize: 20)),
            Text("Register here", style: TextStyle(color: Colors.white, fontSize: 20)),
              ],
            )
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
          buttonRegister(),
        ],
      ),
    ),
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

  Widget buildPassword() {
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

  Widget buttonRegister() {
    return FractionallySizedBox(
      widthFactor: 0.6,
    child: ElevatedButton(
      onPressed: () async{

        if(_formKey.currentState!.validate()) {
          _formKey.currentState!.save();

          try {
            UserCredential? credenciales = await _presentador.register(email, password);
                  if(credenciales !=null && credenciales.user != null) {
                      Navigator.of(context).pop();
                  }
                } on FirebaseAuthException catch (e) {
                  setState(() {
                    if(e.code == 'email-already-in-use') {
                      error = 'Este correo ya está registrado';
                    } else if (e.code == 'weak-password') {
                      error = 'La contraseña es demasiado débil';
                    } else if (e.code == 'invalid-email') {
                      error = 'El correo no es válido';
                    } else {
                      error = "Error inesperado";
                    }
                  });
                }
              } 
            },
    child: Text("Register")
    ), 
  );
  }
}