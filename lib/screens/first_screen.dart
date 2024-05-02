import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_dotcode/_core/minhas_cores.dart';
import 'package:flutter_dotcode/components/adicionar_editar_exercicio_modal.dart';
import 'package:flutter_dotcode/components/inicio_lista.dart';
import 'package:flutter_dotcode/models/exercicio_modelo.dart';
import 'package:flutter_dotcode/services/autenticacao_services.dart';
import 'package:flutter_dotcode/services/exercicio_services.dart';

class TelaInicial extends StatefulWidget {
  final User user;
  const TelaInicial({super.key, required this.user});

  @override
  State<TelaInicial> createState() => _TelaInicialState();
}

class _TelaInicialState extends State<TelaInicial> {
  final ExercicioServico servico = ExercicioServico();
  bool isDecrescente = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      appBar: AppBar(
        elevation: 8,
        shadowColor: Colors.black,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(16),
            bottomRight: Radius.circular(16),
            
          ),
          
        ),
        title: const Text("Tela inicial"),
        actions: [
          IconButton(
              onPressed: () {
                setState(() {
                  isDecrescente = !isDecrescente;
                });
              },
              icon: Icon(Icons.sort_by_alpha_rounded))
        ],
      ),
      drawer: Drawer(
        backgroundColor: MinhasCores.azulTopoGradiente,
        child: ListView(
          children: [
            UserAccountsDrawerHeader(
              decoration: BoxDecoration(color: MinhasCores.azulEscuro),
              currentAccountPicture: const CircleAvatar(
                backgroundImage: AssetImage("assets/goku.png"),
              ),
              accountName: Text((widget.user.displayName != null)
                  ? widget.user.displayName!
                  : ""),
              accountEmail: Text(widget.user.email!),
            ),
            ListTile(
              leading: const Icon(Icons.menu_book_rounded),
              title: const Text("Sobre aplicativo"),
              dense: true,
              onTap: () {},
            ),
            Divider(),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text("Deslogar"),
              dense: true,
              onTap: () {
                AutenticacaoServices().deslogar();
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          mostrarAdicionarEditarExercicioModalModalInicio(context);
        },
        child: const Icon(Icons.add),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: StreamBuilder(
          stream: servico.conectarStreamExercicios(isDecrescente),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else {
              if (snapshot.hasData &&
                  snapshot.data != null &&
                  snapshot.data!.docs.isNotEmpty) {
                List<ExercicioModelo> listaExercicio = [];
                for (var doc in snapshot.data!.docs) {
                  listaExercicio.add(
                    ExercicioModelo.fromMap(
                      doc.data(),
                    ),
                  );
                }
                return ListView(
                  children: List.generate(
                    listaExercicio.length,
                    (index) {
                      ExercicioModelo exercicioModelo = listaExercicio[index];
                      return InicioItemLista(
                        exercicioModelo: exercicioModelo,
                        servico: servico,
                      );
                    },
                  ),
                );
              } else {
                return const Center(
                  child: Text("Ainda nenhuma Exercício. "),
                );
              }
            }
          },
        ),
      ),
    );
  }
}
