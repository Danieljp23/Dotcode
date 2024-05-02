import 'package:flutter/material.dart';
import 'package:flutter_dotcode/_core/meu_SnackBar.dart';
import 'package:flutter_dotcode/_core/minhas_cores.dart';
import 'package:flutter_dotcode/components/decoration_field_autentication.dart';
import 'package:flutter_dotcode/services/autenticacao_services.dart';

class AutenticacaoTela extends StatefulWidget {
  const AutenticacaoTela({super.key});

  @override
  State<AutenticacaoTela> createState() => _AutencacaoTelaState();
}

class _AutencacaoTelaState extends State<AutenticacaoTela> {
  bool queroEntrar = true;
  final _formKey = GlobalKey<FormState>();

  TextEditingController _emailController = TextEditingController();
  TextEditingController _senhaController = TextEditingController();
  TextEditingController _nomeController = TextEditingController();

  AutenticacaoServices _autenServices = AutenticacaoServices();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  MinhasCores.azulTopoGradiente,
                  MinhasCores.azulBaixoGradiente,
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Center(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Container(
                          height: 100, child: Image.asset("assets/logo.png")),
                      Text(
                        "GymApp",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 48,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                      SizedBox(
                        height: 32,
                      ),
                      TextFormField(
                        controller: _emailController,
                        decoration: getInputDecoration("E-mail"),
                        validator: (String? value) {
                          if (value == "") {
                            return "O e-mail não pode ser vazio";
                          }
                          if (value!.length < 5) {
                            return "E-mail muito curto";
                          }
                          if (!value.contains("@")) {
                            return "E-mail inválido";
                          }
                          return null;
                        },
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      TextFormField(
                        controller: _senhaController,
                        decoration: getInputDecoration("Senha"),
                        validator: (String? value) {
                          if (value == "") {
                            return "A senha não pode ser vazia";
                          }
                          if (value!.length < 6) {
                            return "Senha muito curta";
                          }
                          return null;
                        },
                        obscureText: true,
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Visibility(
                        visible: !queroEntrar,
                        child: Column(
                          children: [
                            TextFormField(
                              decoration: getInputDecoration("Confirma senha"),
                              validator: (String? value) {
                                if (value == "") {
                                  return "A senha não pode ser vazia";
                                }
                                if (value!.length < 6) {
                                  return "Senha muito curto";
                                } //if(_confirmaSenhaController.text == _SenhaController.text){
                                // return "As senhas não são iguais";
                                // }
                                return null;
                              },
                              obscureText: true,
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            TextFormField(
                              controller: _nomeController,
                              decoration: getInputDecoration("Nome"),
                              validator: (String? value) {
                                if (value == "") {
                                  return "Campo obrigatório";
                                }
                                if (value!.length < 3) {
                                  return "Nome muito curto";
                                }

                                return null;
                              },
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      ElevatedButton(
                        style:ElevatedButton.styleFrom(backgroundColor: MinhasCores.azulBaixoGradiente),
                        onPressed: () {
                          botaoPrincipalClicado();
                        },
                        child: Text((queroEntrar) ? "Entrar" : "Cadastrar"),
                      ),
                      Divider(),
                      TextButton(
                          onPressed: () {
                            setState(() {
                              queroEntrar = !queroEntrar;
                            });
                          },
                          child: Text((queroEntrar)
                              ? "Ainda não tem uma conta ? Cadastre-se!"
                              : "Já tem uma conta? Entre!")),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  botaoPrincipalClicado() {
    String name = _nomeController.text;
    String senha = _senhaController.text;
    String email = _emailController.text;
    if (_formKey.currentState!.validate()) {
      if (queroEntrar) {
        print("entrada valida");
        _autenServices.logarUsuarios(email: email, senha: senha).then((String ? erro) {
          if(erro!=null){
            mostrarSnackBar(context: context, texto: erro);
          }
            
          
        });
      } else {
        print("Cadastro Validado");
        print(
            "${_emailController.text}, ${_senhaController.text}, ${_nomeController}");
        _autenServices.cadastrarUsurario(
          name: name,
          email: email,
          senha: senha,
        ).then((String? erro) {
if(erro != null){
mostrarSnackBar(context: context, texto: erro);
}
        },
        );
      }
    } else {
      print("inválido");
    }
  }
}
