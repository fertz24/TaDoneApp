import 'package:firebase_auth/firebase_auth.dart';

class RegisterPresentador {

  Future<UserCredential?> register(String email, String password) async {

    return await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email, 
      password: password,
      );
  }
}