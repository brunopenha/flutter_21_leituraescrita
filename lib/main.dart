import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

void main() async {
  var dados = await leituraDados();

  if (dados != null) {
    String mensagem = await leituraDados();
    print(mensagem);
  }
  runApp(new MaterialApp(
    title: 'IO',
    home: new Inicio(),
  ));
}

class Inicio extends StatefulWidget {
  @override
  _InicioState createState() => new _InicioState();
}

class _InicioState extends State<Inicio> {
  @override
  Widget build(BuildContext context) {
    var _campoDadosEntrada = new TextEditingController();

    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Leitura/Escrita'),
        centerTitle: true,
        backgroundColor: Colors.greenAccent,
      ),
      body: new Container(
        padding: const EdgeInsets.all(13.4),
        alignment: Alignment.topCenter,
        child: new ListTile(
          title: new TextField(
            controller: _campoDadosEntrada,
            decoration: new InputDecoration(
              labelText: 'Escreva algo...',
            ),
          ),
          subtitle: new FlatButton(
              color: Colors.redAccent,
              onPressed: () {
                // salva no arquivo
                escreveDados(_campoDadosEntrada.text);
              },
              child: new Column(
                children: <Widget>[
                  new Text('Salva os Dados'),
                  new Padding(padding: new EdgeInsets.all(14.5)),
                  new Text(('Os dados salvos irão por aqui..')),
                  new FutureBuilder(
                    future: leituraDados(),
                    builder:
                        (BuildContext contexto, AsyncSnapshot<String> dado) {
                      if (dado.hasData != null) {
                        return new Text(
                          dado.data.toString(),
                          style: new TextStyle(
                            color: Colors.white,
                          ),
                        );
                      } else {
                        return new Text('Nenhum dado foi salvo');
                      }
                    },
                  ),
                ],
              )),
        ),
      ),
    );
  }
}

Future<String> get _caminhoLocal async {
  final diretorio = await getApplicationDocumentsDirectory();

  return diretorio.path; // /home/directory:text
}

Future<File> get _arquivoLocal async {
  final caminho = await _caminhoLocal;
  return new File('$caminho/dados.txt'); // /home/directory/dados.txt
}

// Escreve e faz a leitura do nosso arquivo
Future<File> escreveDados(String mensagem) async {
  final arquivo = await _arquivoLocal;

  // escreve no arquivo
  return arquivo.writeAsString('$mensagem');
}

Future<String> leituraDados() async {
  String dados;

  try {
    final arquivo = await _arquivoLocal;

    // Leitura
    dados = await arquivo.readAsString();
  } catch (e) {
    dados = "Nada foi escrito por enquanto...";
  }

  return dados;
}
