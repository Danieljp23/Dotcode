import 'package:flutter/material.dart';
import 'package:flutter_dotcode/models/exercicio_modelo.dart';
import 'package:flutter_dotcode/models/sentimento_Modelo.dart';
import 'package:flutter_dotcode/services/sentimento_servico.dart';
import 'package:uuid/uuid.dart';

Future<dynamic> mostrarAdicionarEditarSentimentoDialog(BuildContext context,
    {required String ideExercicio, SentimentoModelo? sentimentoModelo}) {
  return showDialog(
    context: context,
    builder: (context) {
      TextEditingController sentimentoController = TextEditingController();

      if (sentimentoModelo != null) {
        sentimentoController.text = sentimentoModelo.sentindo;
      }

      return AlertDialog(
        title: Text("Como você está se sentindo?"),
        content: TextFormField(
          controller: sentimentoController,
          decoration: InputDecoration(
            label: Text("Qual o sentimento agora?"),
          ),
          maxLines: null,
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text("Cancelar"),
          ),
          ElevatedButton(
            onPressed: () {
              SentimentoModelo sentimento = SentimentoModelo(
                id: Uuid().v1(),
                sentindo: sentimentoController.text,
                data: DateTime.now().toString(),
              );
              if (sentimentoModelo != null) {
                sentimento.id = sentimentoModelo.id;
              }
              SentimentoServico().adicionarSentimento(
                  idExercicio: ideExercicio, sentimentoModelo: sentimento);
              Navigator.pop(context);
            },
            child: Text(
              (sentimentoModelo != null)
                  ? "Editar Sentimento"
                  : "Criar Sentimento",
            ),
          ),
        ],
      );
    },
  );
}
