import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:untitled/authModule/auth.dart';
import 'package:untitled/authModule/login.dart';
import '../contactpage.dart';
import '../istoricModule/istoricpage.dart';
import 'package:untitled/paginaProprietari.dart';
import 'package:untitled/profilulMeu.dart';

class DrawerCustom extends StatelessWidget {
  var auth = ClientAuth().getAuth();

  bool isAdmin() {
    return ClientAuth().isAdmin();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      elevation: 2,
      child: ListView(
        children: [
          DrawerHeader(
            curve: Curves.slowMiddle,
            decoration: const BoxDecoration(
                color: Colors.blue,
                gradient: LinearGradient(colors: [Colors.blueAccent, Colors.greenAccent])),
            padding: const EdgeInsets.all(11),
            child: Align(
                alignment: Alignment.center,
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          child: Image.asset("assets/images/logoapp.png",
                              width: 66, height: 66),
                        ),
                        Container(
                          padding: const EdgeInsets.only(top: 30),
                          child: const Text(
                            "EASociatia",
                            style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Arial',
                                letterSpacing: 14),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.only(top: 21),
                          child: const Text(
                            "Meniu",
                            style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Arial',
                                letterSpacing: 14),
                          ),
                        ),
                      ],
                    ),
                  ],
                )),
          ),
          Container(
            child: isAdmin() ? const ChoiceProprietari() : null,
          ),
          Container(
            padding: const EdgeInsets.all(10),
            child: ListTile(
              leading: const Icon(Icons.double_arrow_sharp),
              title: const Text("PROFILUL MEU"),
              trailing: const Icon(Icons.person),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ProfilulMeu()));
              },
            ),
          ),
          Container(
              padding: const EdgeInsets.all(10),
              child: ListTile(
                leading: const Icon(Icons.double_arrow_sharp),
                title: const Text("ISTORIC"),
                trailing: const Icon(Icons.history),
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => IstoricPage()));
                },
              )),
          Container(
            padding: const EdgeInsets.all(10),
            child: ListTile(
              leading: const Icon(Icons.double_arrow_sharp),
              title: const Text("CONTACT"),
              trailing: const Icon(Icons.contact_page),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ContactPage()));
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.all(10),
            child: ListTile(
              leading: const Icon(Icons.double_arrow_sharp),
              title: const Text("DECONECTARE"),
              trailing: const Icon(Icons.exit_to_app),
              onTap: () {
                auth.signOut().then((value) => Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const Login())));
              },
            ),
          ),
        ],
      ),
    );
  }
}

class ChoiceProprietari extends StatelessWidget {
  const ChoiceProprietari({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(10),
        child: ListTile(
          leading: const Icon(Icons.double_arrow_sharp),
          title: const Text("PROPRIETARI"),
          trailing: const Icon(Icons.people),
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => PaginProprietari()));
          },
        ));
  }
}
