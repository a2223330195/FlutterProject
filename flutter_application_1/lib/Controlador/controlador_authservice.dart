import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<UserCredential?> signIn(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      // Si la autenticación es exitosa, devolvemos userCredential
      return userCredential;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No existe un usuario con ese correo electrónico.');
      } else if (e.code == 'wrong-password') {
        print('La contraseña proporcionada es incorrecta.');
      }
      return null;
    } catch (e) {
      print(e);
      return null;
    }
  }
}
