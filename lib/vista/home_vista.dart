import 'package:flutter/material.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage ({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}
  
class _MyHomePageState extends State<MyHomePage> { //pantalla por el momento (mensaje del Sprint 1)
  
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