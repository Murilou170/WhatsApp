import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:zipzop/model/Mensagem.dart';
import 'model/Usuario.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Mensagens extends StatefulWidget {

  late Usuario contato;

  Mensagens(this.contato);


  @override
  State<Mensagens> createState() => _MensagensState();
}

class _MensagensState extends State<Mensagens> {

  late String _idUsuarioLogado;

List<String> listaMensagens = [


];
  TextEditingController _controllerMensagem = TextEditingController();
  _enviarMensagem(){

    String textoMensagem = _controllerMensagem.text;
    if(textoMensagem.isNotEmpty){



      Mensagem mensagem = Mensagem();
      mensagem.idUsuario = "";
      mensagem.mensagem  = textoMensagem;
      mensagem.urlImagem = "";
      mensagem.tipo      = "texto";

    }

  }

  _enviarFoto(){}

    _recuperarDadosUsuario() async{

      var usuarioLogado = FirebaseAuth.instance.currentUser;
    _idUsuarioLogado = usuarioLogado!.uid;
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
                    borderRadius: BorderRadius.circular(4.0)
                   ),
              prefixIcon: IconButton(
                  icon: Icon(Icons.camera_alt_outlined),
                  onPressed: _enviarFoto
              )
                  )
                ),
              ),
            ),

          FloatingActionButton(
            backgroundColor: Color(0xff075E54),
            child: Icon(Icons.send_outlined, color: Colors.lightBlueAccent,),
            mini: true,
            onPressed: _enviarMensagem,
          )
        ],
      ),
    );

    var listView = Expanded(child: ListView.builder(itemCount: 2,
        itemBuilder: (context, indice){

      double larguraContainer = MediaQuery.of(context).size.width * 0.8;

        return Align(
          alignment: Alignment.centerRight,
          child: Padding(
            padding: EdgeInsets.all(6),
            child: Container(
              width: larguraContainer,
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.all(Radius.circular(8))
              ),
              child: Text(listaMensagens[indice] ),
            ),
          ),
        );
        }
        ),
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
          image: AssetImage("imagens/bg.png"),
          fit: BoxFit.cover
        )
        ),
        child: SafeArea(
          child: Container(
            padding: EdgeInsets.all(16),
            child: Column(
            children: [
              listView,
              caixaMensagem,
            ],
          ),
        )
      ),
    )
    );
  }
}
