import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:zipzop/model/Usuario.dart';
import 'package:flutter/cupertino.dart';





class AbaContatos extends StatefulWidget {
  const AbaContatos({Key? key}) : super(key: key);

  @override
  _AbaContatosState createState() => _AbaContatosState();
}

class _AbaContatosState extends State<AbaContatos> {


  Future<List<Usuario>> _recuperarContatos() async {
    FirebaseFirestore db = FirebaseFirestore.instance;

    QuerySnapshot querySnapshot = await db.collection("usuarios").get();

    List<Usuario> listaUsuarios = [];

    for (DocumentSnapshot item in querySnapshot.docs) {

      Map dadosmap = {};
      var dados = item.data();
      dadosmap = dados as Map;


//ASK TO THALLISON
    String nome = "";
      String senha = "";
      String email = "";
      Usuario usuario = Usuario(nome, email, senha);

      usuario.email = dados["email"];
      usuario.nome = dados["nome"];

      listaUsuarios.add(usuario);
    }

    return listaUsuarios;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Usuario>>(
      future: _recuperarContatos(),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.waiting:
            return Center(
              child: Column(
                children: [
                  Text("Carregando contatos"),
                  CircularProgressIndicator()
                ],
              ),
            );

          case ConnectionState.active:
          case ConnectionState.done:
            return ListView.builder(
                itemCount: snapshot.data?.length,
                itemBuilder: (context, indice) {

                  List<Usuario>? listaItens = snapshot.data;
                  Usuario usuario = listaItens![indice];

                  return ListTile(
                    contentPadding: EdgeInsets.fromLTRB(16, 8, 16, 8),
                    leading: CircleAvatar(
                        maxRadius: 30, backgroundColor: Colors.grey),
                    title: Text(
                      usuario.nome,
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  );
                });

        }
      },
    );
  }
}
