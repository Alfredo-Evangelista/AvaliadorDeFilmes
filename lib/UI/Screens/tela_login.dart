import 'package:flutter/material.dart';
import '../../Services/api_service.dart';
import '../Widget/campo_texto.dart';
import 'tela_home.dart';

class TelaLogin extends StatefulWidget {
  const TelaLogin({super.key});

  @override
  State<TelaLogin> createState() => _TelaLoginState();
}

class _TelaLoginState extends State<TelaLogin> {

  final usuarioController = TextEditingController();
  final senhaController = TextEditingController();

  @override
  void dispose() {
    usuarioController.dispose();
    senhaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Spacer(flex: 1),
            Text('Bem vindo!',
              style: TextStyle(
                fontSize: 40)),

            Spacer(flex: 1),            
            SizedBox(
              width: 200,
              child: Column(
                children: [
                  CampoTexto(controller: usuarioController, label: 'Usuário', icone: Icons.person),

                  SizedBox(height: 10),
                  
                  CampoTexto(controller: senhaController, label: 'senha', icone: Icons.lock, obscureText: true),

                  SizedBox(height: 20),

                  ElevatedButton(onPressed: () async { 
                    String usuario = usuarioController.text; 
                    String senha = senhaController.text; 
                    
                    final response = await ApiServices.postUser(usuario, senha);
                    
                    if (!mounted) return;
                      
                    int status = response['status'];
                    String mensagem = '';

                    if (status ==  200) {
                      final dados = response['body'];
                      String token = dados['token'];

                      usuarioController.clear();
                      senhaController.clear();

                      Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => TelaHome(token: token)),
                      );
                      return;
                    } 

                    if (status == 400) {
                      mensagem = 'Campo "senha" e/ou "nome" obrigatorio.';
                    }
                    else if (status == 401) {
                      mensagem = 'Usuário e/ou senha inválidos.';                       
                    }
                    else if (status == 502){
                      mensagem = 'Não foi possível fazer o login. \nTente novamente mais tarde.';
                    }

                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text("Aviso"),
                        content: Text(mensagem),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },

                            child: Text("OK"),                          
                          ),
                        ],
                      ),
                    );
                  },
                    child: Text('Entrar'),
                  ),
                ],
              ),
            ),
            Spacer(flex: 2),
          ],
        ),
      ),
    );
  }
}