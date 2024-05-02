import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_dotcode/models/sentimento_Modelo.dart';

class SentimentoServico {
  String userId;
  SentimentoServico() : userId = FirebaseAuth.instance.currentUser!.uid;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static const String key = "sentimentos";

  Future<void> adicionarSentimento(
      {required String idExercicio,
      required SentimentoModelo sentimentoModelo}) async {
    return await _firestore
        .collection(userId) //coleção usuário
        .doc(idExercicio) //documento exercicio
        .collection(
            key) //cria uma coleção dentro do exercicio que está dentro da coleção userId
        .doc(sentimentoModelo
            .id) //cria o sentimento no documento dentro da pasta sentimentos que foi criada
        .set(sentimentoModelo
            .toMap()); //passa para o map da classe para criar o objeto
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> conectarStream(
   { required  String idExercicio}) {
    return _firestore
        .collection(userId)
        .doc(idExercicio)
        .collection(key)
        .orderBy("data", descending: true)
        .snapshots();
  }

  Future<void> removerSentimento(
      {required String exercicioId, required String sentimentoId}) async {
    return _firestore
        .collection(userId)
        .doc(exercicioId)
        .collection(key)
        .doc(sentimentoId)
        .delete();
  }
}
