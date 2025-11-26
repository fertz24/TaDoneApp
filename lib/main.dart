import 'package:fer1/vista/home_vista.dart';
import 'package:fer1/vista/login_vista.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart'; 

void main() async { 

  WidgetsFlutterBinding.ensureInitialized();
  debugPrint("Antes de Firebase.initializeApp"); 
  await Firebase.initializeApp( 
    options: const FirebaseOptions( 
    apiKey: "AIzaSyC5MW-8qSmUlhoD2manD-csclElOQBt8Ok",
    appId: "1:215244080211:android:a878ea192ee9fe378df2a6",
    messagingSenderId: "215244080211",
    projectId: "tadone-99353",
    storageBucket: "tadone-99353.appspot.com",
  ), 
 );
  debugPrint("Despues de Firebase.initializeApp"); 

  runApp(MyApp()); 
}

class MyApp extends StatelessWidget { 

  final FirebaseAuth _auth = FirebaseAuth.instance; 

    @override
    Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, 
      home: _auth.currentUser != null ? HomeVista() : LoginVista(), 
    );
  }
}