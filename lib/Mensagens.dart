import 'package:flutter/material.dart';

import 'model/Usuario.dart';

class Mensagens extends StatefulWidget {

  late Usuario contato;

  Mensagens(this.contato);


  @override
  State<Mensagens> createState() => _MensagensState();
}

class _MensagensState extends State<Mensagens> {


  TextEditingController _controllerMensagem = TextEditingController();
  _enviarMensagem(){}

  _enviarFoto(){}

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
                    borderRadius: BorderRadius.circular(32)
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
            child: Icon(Icons.send_outlined, color: Colors.yellow,),
            mini: true,
            onPressed: _enviarMensagem,
          )
        ],
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
              caixaMensagem

            ],
          ),
        )
      ),
    )
    );
  }
}
