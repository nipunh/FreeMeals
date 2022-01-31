import 'package:firebase_auth/firebase_auth.dart';
import 'package:freemeals/models/user_model.dart';

class AuthService{


  // Firebase auth instance
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Create UserDoc based on FirebaseUser

  // signIn anonymously
  Future signInAnon() async {
    try {
      UserCredential result  = await _auth.signInAnonymously();
      User? user = result.user;

      

      return user;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // singIn with email and password

  // Registed with email & password

  // signout
}