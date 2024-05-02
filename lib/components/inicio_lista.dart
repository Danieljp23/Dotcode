import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_dotcode/_core/minhas_cores.dart';
import 'package:flutter_dotcode/models/exercicio_modelo.dart';
import 'package:flutter_dotcode/screens/exercicio_tela.dart';
import 'package:flutter_dotcode/services/exercicio_services.dart';

class InicioItemLista extends StatelessWidget {
  final ExercicioModelo exercicioModelo;
  final ExercicioServico servico;
  const InicioItemLista(
      {super.key, required this.exercicioModelo, required this.servico});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ExercicioTela(
              exercicioModelo: exercicioModelo,
            ),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              blurRadius: 3,
              spreadRadius: 1,
              offset: const Offset(2, 2),
              color: Colors.black.withAlpha(125),
            ),
          ],
          borderRadius: BorderRadius.circular(16),
        ),
        height: 100,
        margin: EdgeInsets.symmetric(
          vertical: 8,
          horizontal: 32,
        ),
        child: Stack(
          children: [
            Align(
              alignment: Alignment.bottomRight,
              child: Container(
                decoration: BoxDecoration(
                  color: MinhasCores.azulEscuro,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(16),
                      bottomRight: Radius.circular(16)),
                ),
                height: 30,
                width: 150,
                child: Center(
                  child: Text(
                    exercicioModelo.treino,
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 8,
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: 200,
                        child: Text(
                          exercicioModelo.name,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: MinhasCores.azulEscuro,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(Icons.edit),
                            onPressed: () {},
                          ),
                          IconButton(
                            onPressed: () {
                              SnackBar snackBar = SnackBar(
                                backgroundColor: Colors.red,
                                content: Text(
                                  "Desejar remover ${exercicioModelo.name}?",
                                ),
                                action: SnackBarAction(
                                  label: "REMOVER",
                                  textColor: Colors.white,
                                  onPressed: () {
                                    servico.removerExercicio(
                                        idExercicio: exercicioModelo.id);
                                  },
                                ),
                              );
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackBar);
                            },
                            icon: Icon(
                              Icons.delete,
                              color: Colors.red,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      SizedBox(
                        width: 150,
                        child: Text(
                          exercicioModelo.comoFazer,
                          overflow: TextOverflow.ellipsis,
                        ),
                      )
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
