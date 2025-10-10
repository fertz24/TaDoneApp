import 'package:firebase_auth/firebase_auth.dart'; 
//importamos el paquete de Firebase el cual nos permitirá usar las funciones de la autenticación
//como es el login y el registro


class LoginPresentador {

  //estamos declarando un método llamado login el cual recibe dos parámetros
  Future<UserCredential?> login(String email, String password) async { //async para poder usar await dentro del método para esperar resultado asíncronos
    //devuelve un Future el cual contiene un UserCredential que este se refiere al resultado del intento del login
    //Future es una palabra reservada que se utiliza con la programación asíncrona, 
    //para representar el resultado de la operaciónque se completará en el futuro.
    //ponemos un ? indicando que puede devolver un null si es que algo falla

    return await FirebaseAuth.instance.signInWithEmailAndPassword( //aqui estamos haciendo uso de Firebase para intentar iniciar sesión con el correo y contraseña
      //con FirebaseAuth.instance accedemos a la instancia del servicio de autenticación
      //con signInWithEmailAndPassword es el método que intenta autenticar al usuario
      email: email, //le pasamos el correo que el usuario escribió
      password: password, //pasamos contraseña
    );
  }
}
//Este presentador solo tiene el método que se conecta con Firebase para iniciar sesión, los datos los recibe desde la vista (login_vista)
//y devuelve el resultado para que la vista decida qué hacer.