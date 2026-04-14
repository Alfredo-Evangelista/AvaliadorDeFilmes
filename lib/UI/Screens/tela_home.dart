import 'package:flutter/material.dart';
import '../../Services/api_service.dart';
import '../Widget/campo_texto.dart';

class TelaHome extends StatefulWidget {
  const TelaHome({super.key, required this.token});
  final String token;

  @override
  State<TelaHome> createState() => _TelaHomeState();
}

class _TelaHomeState extends State<TelaHome> {
  final tituloController = TextEditingController();
  final anoController = TextEditingController();
  final generoController = TextEditingController();
  final diretorController = TextEditingController();
  final notaController = TextEditingController();

  String? tituloErro;
  String? anoErro;
  String? generoErro;
  String? diretorErro;
  String? notaErro;

  List filmes = [];

  Future<void> carregarFilme() async {
    final response = await ApiServices.getFilme(widget.token);

    if (response['status'] == 200) {
      final dados = response['body'];

      setState(() {
        filmes = List.from(dados);
      });
    }
  }
  
  bool validarCampo() {
    int? ano = int.tryParse(anoController.text);
    double? nota = double.tryParse(notaController.text);
    bool temErro = false;
    final anoHoje = DateTime.now().year;

    setState(() {
      if (tituloController.text.isEmpty) {
        tituloErro = 'Título é obrigatório';
        temErro = true;
      } 
      else {
        tituloErro = null;
      }

      if (anoController.text.isEmpty) {
        anoErro = 'Ano é obrigatório';
        temErro = true;
      }
      else if (ano == null) {
        anoErro = 'Ano inválido';
        temErro = true;
      }
      else if (ano < 1875 || ano > anoHoje) {
        anoErro = 'Ano inválido (1875 - {$anoHoje})';
        temErro = true;
      }
      else {
        anoErro = null;
      }

      if (generoController.text.isEmpty) {
        generoErro = 'Gênero é obrigatório';
        temErro = true;
      }
      else {
        generoErro = null;
      }

      if (diretorController.text.isEmpty) {
        diretorErro = 'Diretor é obrigatório';
        temErro = true;
      }
      else {
        diretorErro = null;
      }

      if (notaController.text.isEmpty) {
        notaErro = 'Nota é obrigatório';
        temErro = true;
      }
      else if (nota == null) {
        notaErro = 'Nota inválida';
        temErro = true;
      }
      else if (nota < 0 || nota > 10) {
        notaErro = 'Nota deve estar entre 0 e 10';
        temErro = true;
      }
      else {
        notaErro = null;
      }
    });

    return !temErro;
  }

  @override
  void initState() {
    super.initState();
    carregarFilme();
  }

  @override
  void dispose() {
    tituloController.dispose();
    anoController.dispose();
    generoController.dispose();
    diretorController.dispose();
    notaController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[400],
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.greenAccent,
        title: Text('Biblioteca de filmes',
        style: TextStyle(fontSize: 30)),
      ),
      
      bottomNavigationBar: Container(
        color: Colors.grey[400],
        padding: EdgeInsets.symmetric(vertical: 5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton(onPressed: () {
              final rootContext = context;
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                builder: (context) => Padding(
                  padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom),
                  child: Container(
                    padding: EdgeInsets.all(10),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text("Novo filme", style: TextStyle(fontSize: 18)),
                        SizedBox(height: 10),

                        CampoTexto(controller: tituloController, label: 'Título', icone: Icons.movie_outlined, erro: tituloErro),

                        SizedBox(height: 10),

                        CampoTexto(controller: anoController, label: 'Ano', icone: Icons.calendar_month_outlined, erro: anoErro, keyboardType: TextInputType.number),

                        SizedBox(height: 10),

                        CampoTexto(controller: generoController, label: 'Gênero', icone: Icons.category_outlined, erro: generoErro),

                        SizedBox(height: 10),

                        CampoTexto(controller: diretorController, label: 'Diretor', icone: Icons.person_outline, erro: diretorErro),

                        SizedBox(height: 10),

                        CampoTexto(controller: notaController, label: 'Nota', icone: Icons.star_outline, erro: notaErro, keyboardType: TextInputType.numberWithOptions(decimal: true)),

                        SizedBox(height: 20),

                        ElevatedButton(
                          onPressed: () async {
                            String titulo = tituloController.text;
                            int? ano = int.tryParse(anoController.text);
                            String genero = generoController.text;
                            String diretor = diretorController.text;
                            double? nota = double.tryParse(notaController.text);

                            if (!validarCampo()) return;

                            final response = await ApiServices.postFilme(widget.token, titulo, ano, genero, diretor, nota);
                            int status = response['status'];
                            String mensagem = '';

                            if (status == 201) {
                              mensagem = 'Filme adicionado com sucesso';

                              carregarFilme();

                              tituloController.clear();
                              anoController.clear();
                              generoController.clear();
                              diretorController.clear();
                              notaController.clear();

                            } 

                            else if (status == 403) {
                              mensagem = 'Ação válida apenas para administradores';
                            }
                            
                            Navigator.pop(context);

                            Future.microtask(() {
                              showDialog(
                                context: rootContext,
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
                            });
                          },
                          child: Text("Adicionar"),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.greenAccent),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.add,
                    color: Colors.black),
                  Text('Adicionar',
                    style: TextStyle(color: Colors.black)),
                ],
              ),
            ),
          ],
        ),
      ),
      
      body: Center(
        child:Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: filmes.length,
                itemBuilder: (context, index) {
                  return Card(
                    color: Colors.white,
                    margin: EdgeInsets.all(6),
                    child: Padding(
                      padding: EdgeInsets.all(10),
                      child: ListTile(
                        title: Text(filmes[index]["titulo"],
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,)),
                        subtitle: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(child: 
                              Text("Genero: ${filmes[index]['genero']}",
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis, 
                              ),
                            ),

                            SizedBox(width: 10),

                            Text("Nota: ${filmes[index]['nota']}"),

                            SizedBox(height: 5),
                          ],
                        ),
                        
                        trailing: PopupMenuButton(
                          icon: Icon(Icons.more_horiz),
                          itemBuilder: (context) => [
                            PopupMenuItem(
                              value: 'editar',
                              child: Row(
                                children: [
                                  Icon(Icons.edit),
                                  SizedBox(width: 6),
                                  Text("Editar"),
                                ],
                              ),
                            ),

                            PopupMenuItem(
                              value: 'excluir',
                              child: Row(
                                children: [
                                  Icon(Icons.delete),
                                  SizedBox(width: 6),
                                  Text("Excluir"),
                                ],
                              ),
                            ),
                          ],
                          onSelected: (value) {
                            if (value == 'editar') {
                              int id = filmes[index]["id"];
                              tituloController.text = filmes[index]["titulo"];
                              anoController.text = filmes[index]["ano"].toString();
                              generoController.text = filmes[index]["genero"];
                              diretorController.text = filmes[index]["diretor"];
                              notaController.text = filmes[index]["nota"].toString();

                              final rootContext = context;
                              showModalBottomSheet(
                                context: context,
                                isScrollControlled: true,
                                builder: (context) => Padding(
                                  padding: EdgeInsets.only(
                                    bottom: MediaQuery.of(context).viewInsets.bottom),
                                  child: Container(
                                    padding: EdgeInsets.all(10),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text("Editar filme", style: TextStyle(fontSize: 18)),
                                        SizedBox(height: 10),

                                        CampoTexto(controller: tituloController, label: 'Título', icone: Icons.movie_outlined, erro: tituloErro),

                                        SizedBox(height: 10),

                                        CampoTexto(controller: anoController, label: 'Ano', icone: Icons.calendar_month_outlined, erro: anoErro, keyboardType: TextInputType.number),

                                        SizedBox(height: 10),

                                        CampoTexto(controller: generoController, label: 'Gênero', icone: Icons.category_outlined, erro: generoErro),

                                        SizedBox(height: 10),

                                        CampoTexto(controller: diretorController, label: 'Diretor', icone: Icons.person_outline, erro: diretorErro),

                                        SizedBox(height: 10),

                                        CampoTexto(controller: notaController, label: 'Nota', icone: Icons.star_outline, erro: notaErro, keyboardType: TextInputType.numberWithOptions(decimal: true)),

                                        SizedBox(height: 20),

                                        Row( children: [
                                          TextButton(
                                            onPressed: () async {
                                              String titulo = tituloController.text;
                                              int? ano = int.tryParse(anoController.text);
                                              String genero = generoController.text;
                                              String diretor = diretorController.text;
                                              double? nota = double.tryParse(notaController.text);

                                              if (!validarCampo()) return;

                                              final response = await ApiServices.patchFilme(widget.token, id, titulo, ano, genero, diretor, nota);

                                              int status = response['status'];
                                              String mensagem = '';

                                              if (status == 200) {
                                                mensagem = 'Filme alterado com sucesso';

                                                carregarFilme();
                                                                              
                                                tituloController.clear();
                                                anoController.clear();
                                                generoController.clear();
                                                diretorController.clear();
                                                notaController.clear();

                                                Navigator.pop(context);

                                              } 
                                              else if (status == 403) {
                                                mensagem = 'Ação válida apenas para administradores';
                                              }

                                              else if (status == 404) {
                                                mensagem = 'Filme não encontrado.';
                                              }

                                              Future.microtask(() {
                                                showDialog(
                                                  context: rootContext,
                                                  builder: (dialogcontext) => AlertDialog(
                                                    title: Text("Aviso"),
                                                    content: Text(mensagem),
                                                    actions: [
                                                      TextButton(
                                                        onPressed: () {
                                                          Navigator.pop(dialogcontext);
                                                        },
                                                        child: Text("OK"),
                                                      ),
                                                    ],
                                                  ),
                                                );
                                              });
                                            },
                                            child: Text("OK")),

                                          TextButton(onPressed: () {
                                            Navigator.pop(context);

                                            tituloController.clear();
                                            anoController.clear();
                                            generoController.clear();
                                            diretorController.clear();
                                            notaController.clear();
                                          },
                                            child: Text('Cancelar')),  
                                        ]),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            } 
                            
                            else if (value == 'excluir') {
                              showDialog(context: context,
                                builder: (context) => AlertDialog(
                                  title: Text('Aviso'),
                                  content: Text('Quer mesmo apagar o filme?'),
                                  actions: [
                                    Row(children: [
                                      TextButton(onPressed: () async {
                                        int id = filmes[index]["id"];
                                        final response = await ApiServices.deleteFilme(widget.token, id);
                                        
                                        int status = response['status'];
                                        String mensagem = '';

                                        if (status == 200) {
                                          mensagem = 'Filme excluido com sucesso';
                                          
                                          carregarFilme();
                                        }

                                        else if (status == 403) {
                                          mensagem = 'ID do filme não encontrado.';
                                        }

                                        Navigator.pop(context);

                                         Future.microtask(() {
                                          showDialog(
                                            context: context,
                                            builder: (dialogcontext) => AlertDialog(
                                              title: Text("Aviso"),
                                              content: Text(mensagem),
                                              actions: [
                                                TextButton(
                                                  onPressed: () {
                                                    Navigator.pop(dialogcontext);
                                                  },
                                                  child: Text("OK"),
                                                ),
                                              ],
                                            ),
                                          );
                                        });
                                      },
                                        child: Text("Sim")),

                                      Spacer(),

                                      TextButton(onPressed: () {
                                        Navigator.pop(context);
                                      },
                                        child: Text('Cancelar')),
                                    ]),
                                  ],
                                ),
                              );
                            }
                          },
                        )
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}