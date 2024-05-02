import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_dotcode/models/exercicio_modelo.dart';
import 'package:flutter_dotcode/models/sentimento_Modelo.dart';

class ExercicioServico {
  String userId;
  ExercicioServico() : userId = FirebaseAuth.instance.currentUser!.uid;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> adicionarExercicio(ExercicioModelo exercicioModelo) async {
    return await _firestore
        .collection(userId)
        .doc(exercicioModelo.id)
        .set(exercicioModelo.toMap());
  }

  
  // no dart o termo Stream arremete a abrir um tunel e analisar em tempo real
  //função que pede toda vez que o usuário esta logado um print da coleção do firestore, de acordo com o Id logado
  Stream<QuerySnapshot<Map<String, dynamic>>> conectarStreamExercicios(
      bool isDecrescente) {
    return _firestore
        .collection(userId)
        .orderBy("treino", descending: isDecrescente)
        .snapshots();
  }

  Future<void> removerExercicio({required String idExercicio}) {
    return _firestore.collection(userId).doc(idExercicio).delete();
  }
}
