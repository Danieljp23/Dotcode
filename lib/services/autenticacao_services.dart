import 'package:firebase_auth/firebase_auth.dart';

class AutenticacaoServices {
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  
  Future<String?> cadastrarUsurario({
    required String name,
    required String email,
    required String senha,
  }) async {
    try {
      UserCredential userCredential =
          await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: senha,
      );
      await userCredential.user!.updateDisplayName(name);
    } on FirebaseAuthException catch (e) {
      if (e.code == "email-already-in-use") {
       return "O usuário já está cadastrado";
      }
      return "Erro desconhecido";
    }
  }
  Future<String?> logarUsuarios({
    required String email, 
    required String senha,
  })async{
  try {
  await  _firebaseAuth.signInWithEmailAndPassword(email: email, password: senha);
    return null;
} on FirebaseAuthException catch (e) {
  return e.message;
}
  }
  Future<void>deslogar() async {
    return _firebaseAuth.signOut();
  }
}
