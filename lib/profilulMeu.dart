import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:untitled/contactpage.dart';
import 'package:untitled/generic_objects.dart';
import 'authModule/login.dart';
import 'drawerModule/meniu.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'helpers.dart';
import 'authModule/auth.dart';
import 'package:url_launcher/url_launcher.dart';
import 'paginaadmin.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfilulMeu extends StatefulWidget {
  const ProfilulMeu({Key? key}) : super(key: key);

  @override
  State<ProfilulMeu> createState() => _ProfilulMeuState();
}

class _ProfilulMeuState extends State<ProfilulMeu> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profilul Meu"),
      ),
      body: PersonaProfileBody(),
    );
  }
}

class PersonaProfileBody extends StatelessWidget {
  const PersonaProfileBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Image(image: AssetImage("assets/images/blueb.jpeg")),
        Container(
          alignment: Alignment.topCenter,
            child: Image(
                image: AssetImage("assets/images/logoapp.png"), width: 110)),
        Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          padding: EdgeInsets.only(top: 230),
          child: Card(
            elevation: 7,
            child: InfoCard(),
          ),
        ),
        Container(
          padding: EdgeInsets.only(top: 80),
          alignment: Alignment.topCenter,
          child: Card(
            elevation: 7,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(100))),
            child: Icon(
              Icons.person_outline,
              size: 180,
            ),
          ),
        ),
      ],
    );
  }
}

class InfoCard extends StatefulWidget {
  @override
  State<InfoCard> createState() => _InfoCardState();
}

class _InfoCardState extends State<InfoCard> {
  ProprietarObj currentUser = ProprietarObj();
  var docId = null;

  Future<void> getCurrentUserData() async {
    await FirebaseFirestore.instance
        .collection("proprietari")
        .where("unique_generated_id",
            isEqualTo: ClientAuth().fauth.currentUser?.uid.toString())
        .get()
        .then((value) {
      setState(() {
        docId = value.docs.first.id;
        currentUser = ProprietarObj.fromSnapshot(value.docs.first);
      });
    });
  }

  Future<void> updatedUser(String newAp, String newTel) async {
    ProprietarObj currentUserObj = currentUser;
    int newApInt = int.parse(newAp);
    bool apChanged = false;
    bool telChanged = false;

    if (newApInt != currentUser.apartament) {
      currentUserObj.apartament = newApInt;
      apChanged = true;
    }
    if (newTel != currentUser.telefon) {
      currentUserObj.telefon = newTel;
      telChanged = true;
    }

    if (apChanged || telChanged) {
      await registerUserUpdates(currentUserObj, docId);
    } else {
      throw Exception("No info changed");
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    getCurrentUserData();
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController numeController = TextEditingController();
    TextEditingController emailController = TextEditingController();
    TextEditingController apController = TextEditingController();
    TextEditingController telController = TextEditingController();

    numeController.text = currentUser.nume;
    emailController.text = currentUser.email;
    apController.text = currentUser.apartament.toString();
    telController.text = currentUser.telefon.toString();

    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.only(top: 70),
        child: Column(
          children: [
            Card(
              elevation: 0,
              child: TextField(
                controller: numeController,
                textAlign: TextAlign.center,
                readOnly: true,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(22)),
                      borderSide: BorderSide(width: 5, color: Colors.blue)),
                  labelText: "Nume",
                  hintText: "Acest camp nu se poate edita.",
                  hintTextDirection: TextDirection.ltr,
                ),
              ),
            ),
            Card(
              elevation: 0,
              child: TextField(
                textAlign: TextAlign.center,
                readOnly: true,
                controller: emailController,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(22)),
                        borderSide: BorderSide(width: 5, color: Colors.blue)),
                    labelText: "Email",
                    hintText: "Acest camp nu se poate edita.",
                    hintTextDirection: TextDirection.ltr,
                    alignLabelWithHint: true),
              ),
            ),
            Card(
              elevation: 0,
              child: TextField(
                textAlign: TextAlign.center,
                keyboardType: TextInputType.number,
                controller: apController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(22)),
                      borderSide: BorderSide(width: 5, color: Colors.blue)),
                  labelText: "Apartament",
                ),
              ),
            ),
            Card(
              elevation: 0,
              child: TextField(
                textAlign: TextAlign.center,
                keyboardType: TextInputType.phone,
                controller: telController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(22)),
                      borderSide: BorderSide(width: 5, color: Colors.blue)),
                  labelText: "Telefon",
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.only(top: 46, bottom: 17),
              child: ElevatedButton(
                onPressed: () async {
                  updatedUser(apController.text, telController.text)
                      .then((value) => showDialog(
                          context: context,
                          builder: (context) => UpdateDialog()))
                      .onError((error, stackTrace) {
                    showDialog(
                        context: context,
                        builder: (context) => UpdateDialogFailed());
                  });
                },
                style: 
                ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.greenAccent),
                ),
                child: const Text(
                  "UPDATE",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 21,
                      color: Colors.white,
                      letterSpacing: 14),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class UpdateDialog extends StatelessWidget {
  const UpdateDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: AlertDialog(
        title: Text("SUCCESS"),
        content: Text("Noile informatii au salvate cu succes."),
        elevation: 4,
        icon: Icon(Icons.check_box),
        actions: [
          TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text("Am inteles"))
        ],
      ),
    );
  }
}

class UpdateDialogFailed extends StatelessWidget {
  const UpdateDialogFailed({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: AlertDialog(
        title: Text("FAIL"),
        content: Text("Nu au fost furnizate inforamtii noi."),
        elevation: 4,
        icon: Icon(Icons.error),
        actions: [
          TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text("Am inteles"))
        ],
      ),
    );
  }
}
