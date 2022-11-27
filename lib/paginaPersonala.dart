import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:untitled/contactpage.dart';
import 'authModule/login.dart';
import 'drawerModule/meniu.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'helpers.dart';
import 'authModule/auth.dart';
import 'package:url_launcher/url_launcher.dart';
import 'paginaadmin.dart';

class ViewIntretinere extends StatefulWidget {
  final String _email;

  ViewIntretinere(this._email);

  @override
  State<ViewIntretinere> createState() => _ViewIntretinereState();
}

class _ViewIntretinereState extends State<ViewIntretinere> {
  bool isAdmin = ClientAuth().isAdmin();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(
            onPressed: () async {
              Uri apel = Uri.parse('tel:0888888');
              await launchUrl(apel);
            },
            child: Icon(Icons.call)),
        appBar: AppBar(
            title: const Align(
              child: Text('A C A S A ', style: TextStyle(color: Colors.white),),
              alignment: Alignment.bottomRight,
            ),
            actions: [
              HelpButton(isAdmin),
            ]),
        body: const BodyIntretinere(),
        drawer: DrawerCustom());
  }
}

class BodyIntretinere extends StatefulWidget {
  const BodyIntretinere({Key? key}) : super(key: key);

  @override
  State<BodyIntretinere> createState() => _BodyIntretinereState();
}

class _BodyIntretinereState extends State<BodyIntretinere> {
  TextEditingController controllerRepDate = TextEditingController();
  TextEditingController controllerNume = TextEditingController();
  TextEditingController controllerAp = TextEditingController();

  TextEditingController controllerApaRece = TextEditingController();
  TextEditingController controllerApaCalda = TextEditingController();

  String nrApartament = "";
  String numeProprietar = "";
  DateTime? repDate;
  bool isValidDate = false;

  void loadUserData() {
    GetUserInfo().getProprietarData().then((doc) {
      Map<String, dynamic> userdata = doc.docs.first.data()!;
      setState(() {
        nrApartament = userdata["ap"].toString();
        numeProprietar = userdata["nume"].toString();
      });
    });

    controllerNume.text = numeProprietar;
    controllerAp.text = nrApartament;
  }

  void cleanUp() {
    controllerApaRece.clear();
    controllerApaCalda.clear();
    controllerRepDate.clear();
  }

  void recordIntretinere() {
    if (isValidDate) {
      RecordIntretinere().postIntretinere(
          numeProprietar,
          int.parse(controllerApaRece.text),
          int.parse(controllerApaCalda.text),
          int.parse(controllerAp.text),
          repDate!);

      controllerRepDate.clear();
      cleanUp();
      showDialog(context: context, builder: (context) => const RecordDialog());
    }
  }

  @override
  Widget build(BuildContext context) {
    loadUserData();

    return SingleChildScrollView(
      child: Column(
        children: [
          Card(
            elevation: 3,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
              //set border radius more than 50% of height and width to make circle
            ),
            child: Container(
              width: double.infinity,
              child: Column(
                children: [
                  Container(
                      padding: const EdgeInsets.only(top: 44),
                      child: const Text(
                        "Informatii Proprietar",
                        style: TextStyle(color: Colors.blue, fontSize: 21),
                      )),
                  Container(
                    padding: const EdgeInsets.only(top: 30),
                    child: Align(
                      alignment: Alignment.center,
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 40, right: 40, bottom: 20, top: 1),
                        child: TextField(
                          textAlign: TextAlign.center,
                          readOnly: true,
                          controller: controllerNume,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(22)),
                                borderSide:
                                    BorderSide(width: 5, color: Colors.blue)),
                            labelText: "Proprietar",
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(bottom: 7),
                    child: Align(
                      alignment: Alignment.center,
                      child: Padding(
                        padding: EdgeInsets.only(
                            left: 40, right: 40, bottom: 20, top: 10),
                        child: TextField(
                          controller: controllerAp,
                          textAlign: TextAlign.center,
                          readOnly: true,
                          decoration: const InputDecoration(
                              border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(22)),
                                  borderSide: const BorderSide(
                                      width: 5, color: Colors.blue)),
                              labelText: "Apartament"),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.all(11),
            child: Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(22))),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: Padding(
                      padding: EdgeInsets.only(
                          left: 40, right: 40, bottom: 20, top: 40),
                      child: TextField(
                        controller: controllerApaRece,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                            prefix: Icon(Icons.numbers),
                            border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(22)),
                                borderSide:
                                    BorderSide(width: 5, color: Colors.black)),
                            labelText: "Index Apa Rece"),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Padding(
                      padding: EdgeInsets.only(
                          left: 40, right: 40, bottom: 20, top: 10),
                      child: TextField(
                        controller: controllerApaCalda,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                            prefix: Icon(Icons.numbers),
                            border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(22)),
                                borderSide:
                                    BorderSide(width: 5, color: Colors.black)),
                            labelText: "Index Apa Calda"),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Padding(
                      padding: EdgeInsets.only(
                          left: 40, right: 40, bottom: 20, top: 10),
                      child: TextField(
                        controller: controllerRepDate,
                        onTap: () async {
                          DateTime? selectedDate = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(2022),
                              lastDate: DateTime(2200));

                          if (selectedDate != null &&
                              !selectedDate.isAfter(DateTime.now())) {
                            String luna = selectedDate.month.toString();
                            String ziua = selectedDate.day.toString();
                            String anul = selectedDate.year.toString();
                            controllerRepDate.text = "$ziua-$luna-$anul";

                            setState(() {
                              repDate = selectedDate;
                              isValidDate = true;
                            });
                          } else {
                            isValidDate = false;
                            controllerRepDate.text =
                                "Introduceti o data din trecut.";
                          }
                        },
                        decoration: const InputDecoration(
                            prefix: Icon(Icons.date_range),
                            border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(22)),
                                borderSide:
                                    BorderSide(width: 5, color: Colors.black)),
                            labelText: "Data Raportare"),
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.only(top: 17, bottom: 17),
                    child: ElevatedButton(
                      onPressed: recordIntretinere,
                      style: ButtonStyle(
                          foregroundColor: MaterialStateProperty.all<Color>(
                              Colors.blueAccent)),
                      child: const Text(
                        "T R I M I T E",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 21,
                            color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

class HelpButton extends StatelessWidget {
  final bool isAdmin;

  HelpButton(this.isAdmin);

  @override
  Widget build(BuildContext context) {
    void contactPage() {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => ContactPage()));
    }

    void adminPage() {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => PaginaAdmin()));
    }

    if (!isAdmin) {
      return TextButton(
        onPressed: contactPage,
        child: const Icon(
          Icons.help,
          color: Colors.white,
        ),
      );
    } else {
       return Container(
         child: Row(
           children: [
             TextButton(
              onPressed: contactPage,
              child: const Icon(
                Icons.help,
                color: Colors.white,
              ),
      ),
             TextButton(
               onPressed: adminPage,
               child: const Icon(
                 Icons.admin_panel_settings,
                 color: Colors.black26,
               ),
             ),
           ],
         ),
       );
    }
  }
}
