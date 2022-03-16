import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:zipzop/Login.dart';
import 'package:zipzop/telas/AbaContatos.dart';
import 'package:zipzop/telas/AbaConversas.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<String> itensMenu = ["Configurações", "Deslogar"];

  String _emailUsuario = "";

  Future _recuperarDadosUsuario() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User usuarioLogado = await auth.currentUser!;
    setState(() {
      _emailUsuario = usuarioLogado.email!;
    });
  }

  Future _verificarUsuarioLogado() async {

    var currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      await new Future.delayed(new Duration(milliseconds: 2500));
      {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => Login()));
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _verificarUsuarioLogado();
    _recuperarDadosUsuario();
    _tabController = TabController(length: 2, vsync: this);
  }

  _escolhaMenuItem(String itemEscolhido) {
    switch (itemEscolhido) {
      case "Configurações":
        print("Configurações");
        break;
      case "Deslogar":
        _deslogarUsuario();
        break;
    }

  }

  _deslogarUsuario() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    await auth.signOut();

    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => Login()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff075E54),
        title: Text("ZipZop"),
        bottom: TabBar(
          indicatorWeight: 4,
          labelStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          controller: _tabController,
          indicatorColor: Colors.white,
          tabs: [
            Tab(text: "Conversas"),
            Tab(text: "Contatos"),
          ],
        ),
        actions: [
          PopupMenuButton<String>(
            onSelected: _escolhaMenuItem,
            itemBuilder: (context) {
              return itensMenu.map((String item) {
                return PopupMenuItem<String>(
                  value: item,
                  child: Text(item),
                );
              }).toList();
            },
          )
        ],
      ),
      body: TabBarView(
        controller: _tabController,
        children: [AbaConversas(), AbaContatos()],
      ),
    );
  }
}
