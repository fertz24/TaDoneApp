import 'package:flutter/material.dart';

class HomeVista extends StatefulWidget {
  const HomeVista ({super.key});

  @override
  State<HomeVista> createState() => _HomeVistaState();
}
  
class _HomeVistaState extends State<HomeVista> { //pantalla por el momento (mensaje del Sprint 1)
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.indigo,
      body: Center(
        child: 
          Text("App en construcción! 🚧", style: TextStyle(color: Colors.white, fontSize: 24)),
      ),
    );
  }
}