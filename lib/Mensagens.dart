import 'dart:async';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:zipzop/model/Mensagem.dart';
import 'model/Usuario.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';


class Mensagens extends StatefulWidget {
  late Usuario contato;

  Mensagens(this.contato);

  @override
  State<Mensagens> createState() => _MensagensState();
}

class _MensagensState extends State<Mensagens> {

  late File _imagem;
  late String _idUsuarioLogado;
  late String _idUsuarioDestinatario;

  FirebaseFirestore db = FirebaseFirestore.instance;

  List<String> listaMensagens = [];
  TextEditingController _controllerMensagem = TextEditingController();

  final _controller = StreamController<QuerySnapshot>.broadcast();
  ScrollController _scrollController = ScrollController();

  _enviarMensagem() {
    String textoMensagem = _controllerMensagem.text;
    if (textoMensagem.isNotEmpty) {
      Mensagem mensagem = Mensagem();
      mensagem.idUsuario = _idUsuarioLogado;
      mensagem.mensagem = textoMensagem;
      mensagem.urlImagem = "";
      mensagem.tipo = "texto";
      mensagem.time = DateTime.now().toUtc();

      _salvarMensagem(_idUsuarioLogado, _idUsuarioDestinatario, mensagem);

      _salvarMensagem(_idUsuarioDestinatario, _idUsuarioLogado, mensagem);
    }
  }

  _salvarMensagem(String idRemetente, String idDestinatario, Mensagem msg) async {
    await db
        .collection("mensagens")
        .doc(idRemetente)
        .collection(idDestinatario)
        .add(msg.toMap());

    //limpar o texto
    _controllerMensagem.clear();
  }

  _enviarFoto() async {

    final ImagePicker _picker = ImagePicker();
   final XFile?  imagemSelecionada = await _picker.pickImage(source: ImageSource.gallery);

   //_uploadImagem();


  }

  _recuperarDadosUsuario() async {
    var usuarioLogado = FirebaseAuth.instance.currentUser;
    _idUsuarioLogado = usuarioLogado!.uid;

    _idUsuarioDestinatario = widget.contato.idUsuario;
    _adicionarListenerMensagens();
  }

  CircularProgressIndicator _adicionarListenerMensagens() {
// Adicionei circularProgressIndicato ao inv??s de Stream<QuerySnapshot> para ter algo com que retornar
    final stream = db
        .collection("mensagens")
        .doc(_idUsuarioLogado)
        .collection(_idUsuarioDestinatario)
        .orderBy('time', descending: false)
        .snapshots();

    stream.listen((dados){
      _controller.add(dados);
      Timer(Duration(seconds: 1), (){
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      });
    });
    return CircularProgressIndicator();
    }

  @override
  void initState() {
    super.initState();
    _recuperarDadosUsuario();
  }

  @override
  Widget build(BuildContext context) {
    var caixaMensagem = Container(
      padding: EdgeInsets.all(8),
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(right: 8),
              child: TextField(
                  controller: _controllerMensagem,
                  autofocus: true,
                  keyboardType: TextInputType.text,
                  style: TextStyle(fontSize: 20),
                  decoration: InputDecoration(
                      contentPadding: EdgeInsets.fromLTRB(32, 8, 32, 8),
                      hintText: "Digite uma mensagem...",
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(4.0)),
                      prefixIcon: IconButton(
                          icon: Icon(Icons.camera_alt_outlined),
                          onPressed: _enviarFoto))),
            ),
          ),
          FloatingActionButton(
            backgroundColor: Color(0xff075E54),
            child: Icon(
              Icons.send_outlined,
              color: Colors.lightBlueAccent,
            ),
            mini: true,
            onPressed: _enviarMensagem,
          )
        ],
      ),
    );

    var stream = StreamBuilder(
        stream: _controller.stream,
        builder: (context, snapshot){
        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.waiting:
            return Center(
              child: Column(
                children: [
                  Text("Carregando mensagens"),
                  CircularProgressIndicator()
                ],
              ),
            );

          case ConnectionState.active:
          case ConnectionState.done:
            QuerySnapshot? querySnapshot = snapshot.data as QuerySnapshot<Object?>?;

            if (snapshot.hasError) {
              return Expanded(
                child: Text("Erro ao carregar os dados!"),
              );

            } else {
              return Expanded(
                child: ListView.builder(
                  controller: _scrollController,
                    itemCount: querySnapshot!.docs.length,
                    itemBuilder: (context, indice) {

                      //recupera mensagem
                      List<DocumentSnapshot> mensagens = querySnapshot.docs.toList();
                      DocumentSnapshot item = mensagens[indice];


                      double larguraContainer =
                          MediaQuery.of(context).size.width * 0.5;

                      Alignment alinhamento = Alignment.centerRight;
                      Color cor = Color(0xffd2ffa5);

                      if(_idUsuarioLogado != item["idUsuario"]){
                        alinhamento = Alignment.centerLeft;
                        cor = Colors.white;
                      }



                      return Align(
                        alignment: alinhamento,
                        child: Padding(
                          padding: EdgeInsets.all(6),
                          child: Container(
                            width: larguraContainer,
                            padding: EdgeInsets.all(16),
                            decoration: BoxDecoration(
                                color: cor,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8))),
                            child: Text(item["mensagem"]),
                          ),
                        ),
                      );
                    }),
              );
            }

        }
      },
      );

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xff075E54),
          title: Text(widget.contato.nome),
        ),
        body: Container(
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("imagens/bg.png"), fit: BoxFit.cover)),
          child: SafeArea(
              child: Container(
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                stream,
                caixaMensagem,
              ],
            ),
          )),
        ));
  }
}

