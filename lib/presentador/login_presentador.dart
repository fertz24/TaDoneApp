import 'package:firebase_auth/firebase_auth.dart'; 

class LoginPresentador {

  Future<UserCredential?> login(String email, String password) async { 

    return await FirebaseAuth.instance.signInWithEmailAndPassword( 
      email: email, 
      password: password, 
    );
  }
}