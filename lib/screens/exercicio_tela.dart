import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_dotcode/_core/minhas_cores.dart';
import 'package:flutter_dotcode/components/adicionar_editar_sentimento_modal.dart';
import 'package:flutter_dotcode/models/exercicio_modelo.dart';
import 'package:flutter_dotcode/models/sentimento_Modelo.dart';
import 'package:flutter_dotcode/services/sentimento_servico.dart';

class ExercicioTela extends StatelessWidget {
  final ExercicioModelo exercicioModelo;
  ExercicioTela({super.key, required this.exercicioModelo});

  SentimentoServico _sentimentoServico = SentimentoServico();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      appBar: AppBar(
        title: Column(
          children: [
            Text(
              "${exercicioModelo.name}",
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 22),
            ),
            Text(
              "${exercicioModelo.treino}",
              style: TextStyle(color: Colors.white, fontSize: 15),
            ),
          ],
        ),
        centerTitle: true,
        backgroundColor: MinhasCores.azulEscuro,
        elevation: 0,
        toolbarHeight: 72,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(32),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          mostrarAdicionarEditarSentimentoDialog(
            context,
            ideExercicio: exercicioModelo.id,
          );
        },
        child: Icon(Icons.add),
      ),
      body: Container(
        margin: const EdgeInsets.all(8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: ListView(
          children: [
            SizedBox(
              height: 250,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                    onPressed: () {},
                    child: const Text("Enviar foto"),
                  ),
                  ElevatedButton(
                    onPressed: () {},
                    child: const Text("Remover foto"),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            const Text(
              "como fazer?",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            Text("${exercicioModelo.comoFazer}"),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: const Divider(
                color: Colors.black,
              ),
            ),
            const Text(
              "como estou me sentindo!",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            StreamBuilder(
              stream: _sentimentoServico.conectarStream(
                  idExercicio: exercicioModelo.id),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  if (snapshot.hasData &&
                      snapshot.data != null &&
                      snapshot.data!.docs.isNotEmpty) {
                    final List<SentimentoModelo> listaSentimentos = [];

                    for (var doc in snapshot.data!.docs) {
                      listaSentimentos.add(
                        SentimentoModelo.fromMap(
                          doc.data(),
                        ),
                      );
                    }

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: List.generate(
                        listaSentimentos.length,
                        (index) {
                          SentimentoModelo sentimentoAgora =
                              listaSentimentos[index];
                          return ListTile(
                            contentPadding: EdgeInsets.zero,
                            title: Text(sentimentoAgora.sentindo),
                            subtitle: Text(sentimentoAgora.data),
                            leading: Icon(Icons.double_arrow),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  onPressed: () {
                                    mostrarAdicionarEditarSentimentoDialog(
                                      context,
                                      ideExercicio: exercicioModelo.id,
                                      sentimentoModelo: sentimentoAgora,
                                    );
                                  },
                                  icon: Icon(Icons.edit),
                                ),
                                IconButton(
                                    onPressed: () {
                                      _sentimentoServico.removerSentimento(
                                        exercicioId: exercicioModelo.id,
                                        sentimentoId: sentimentoAgora.id,
                                      );
                                    },
                                    icon: const Icon(
                                      Icons.delete,
                                      color: Colors.red,
                                    )),
                              ],
                            ),
                          );
                        },
                      ),
                    );
                  } else {
                    return const Text("Nenhuma anotação de sentimento ainda");
                  }
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
