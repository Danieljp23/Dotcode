import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_dotcode/_core/minhas_cores.dart';
import 'package:flutter_dotcode/components/decoration_field_autentication.dart';
import 'package:flutter_dotcode/models/exercicio_modelo.dart';
import 'package:flutter_dotcode/models/sentimento_Modelo.dart';
import 'package:flutter_dotcode/services/exercicio_services.dart';
import 'package:flutter_dotcode/services/sentimento_servico.dart';
import 'package:uuid/uuid.dart';

mostrarAdicionarEditarExercicioModalModalInicio(BuildContext context,
    {ExercicioModelo? exercicio}) {
  showModalBottomSheet(
      context: context,
      backgroundColor: MinhasCores.azulTopoGradiente,
      isDismissible: false,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(32),
        ),
      ),
      builder: (context) {
        return ExercicioModal(exercicioModelo: exercicio);
      });
}

class ExercicioModal extends StatefulWidget {
  final ExercicioModelo? exercicioModelo;
  const ExercicioModal({super.key, this.exercicioModelo});

  @override
  State<ExercicioModal> createState() => _ExercicioModalState();
}

class _ExercicioModalState extends State<ExercicioModal> {
  TextEditingController nomeCtrl = TextEditingController();
  TextEditingController treinoCtrl = TextEditingController();
  TextEditingController anotacoesCtrl = TextEditingController();
  TextEditingController sentindoCtrl = TextEditingController();

  bool isCarregando = false;

  ExercicioServico _exercicioServico = ExercicioServico();

  @override
  void initState() {
    if (widget.exercicioModelo != null) {
      nomeCtrl.text = widget.exercicioModelo!.name;
      treinoCtrl.text = widget.exercicioModelo!.treino;
      anotacoesCtrl.text = widget.exercicioModelo!.comoFazer;
    }
    super.initState();
  }

  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(32),
      height: MediaQuery.of(context).size.height * 0.9,
      child: Form(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Text(
                        (widget.exercicioModelo != null)
                            ? "Editar ${widget.exercicioModelo!.name}"
                            : "Adicionar exercicio",
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(
                        Icons.close,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                const Divider(),
                Column(
                  children: [
                    const SizedBox(
                      height: 16,
                    ),
                    TextFormField(
                      controller: nomeCtrl,
                      decoration: getInputDecoration(
                        "Qual nome do exercício?",
                        icon: const Icon(
                          Icons.abc,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    TextFormField(
                      controller: treinoCtrl,
                      decoration: getInputDecoration(
                        "Qual treino pertence?",
                        icon: const Icon(
                          Icons.list_alt_rounded,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    TextFormField(
                      controller: anotacoesCtrl,
                      decoration: getInputDecoration(
                        "Quais anotações você tem?",
                        icon: const Icon(
                          Icons.notes_rounded,
                          color: Colors.white,
                        ),
                      ),
                      maxLines: null,
                    ),
                    Visibility(
                      visible: (widget.exercicioModelo == null),
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 16,
                          ),
                          TextFormField(
                            controller: sentindoCtrl,
                            decoration: getInputDecoration(
                              "Como você está se sentindo?",
                              icon: const Icon(
                                Icons.emoji_emotions_rounded,
                                color: Colors.white,
                              ),
                            ),
                            maxLines: null,
                          ),
                          Text(
                            "Campo não é obrigatório",
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.white, fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            //elevated button que executa a função de envio de treino
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: MinhasCores.azulBaixoGradiente),
              onPressed: () {
                enviarClicado();
              },
              child: (isCarregando)
                  ? const SizedBox(
                      height: 16,
                      width: 16,
                      child: CircularProgressIndicator(
                        color: MinhasCores.azulTopoGradiente,
                      ),
                    )
                  : Text(
                      (widget.exercicioModelo != null)
                          ? "Editar Exercício"
                          : "Criar Exercício",
                    ),
            ),
          ],
        ),
      ),
    );
  }

//função que adiciona no CloundFirestore meu treino com base no userId gerado na instancia do FirebaseAuth, e cria seus respectivos atributos
  enviarClicado() {
    String name = nomeCtrl.text;
    String treino = treinoCtrl.text;
    String anotacoes = anotacoesCtrl.text;
    String sentindo = sentindoCtrl.text;
//intancia da classe ExercicioModelo, que cria o objeto ExercicioModelo
    ExercicioModelo exercicio = ExercicioModelo(
      id: const Uuid().v1(),
      name: name,
      treino: treino,
      comoFazer: anotacoes,
    );
    if (widget.exercicioModelo != null) {
      exercicio.id = widget.exercicioModelo!.id;
    }
    _exercicioServico.adicionarExercicio(exercicio).then((value) {
      if (sentindo != "") {
        //condição que delimita se esta cadastrando com sentimento ou não no banco de dados
        SentimentoModelo sentimento = SentimentoModelo(
          id: Uuid().v1(),
          sentindo: sentindo,
          data: DateTime.now().toString(),
        );

        SentimentoServico()
            .adicionarSentimento(
          idExercicio: exercicio.id,
          sentimentoModelo: sentimento,
        )
            .then((value) {
          setState(() {
            isCarregando = false;
          });
          Navigator.pop(context);
        });
      } else {
        Navigator.pop(context);
      }
    });
  }
}
