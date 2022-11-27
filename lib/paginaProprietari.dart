import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:untitled/generic_objects.dart';


class PaginProprietari extends StatefulWidget {
  const PaginProprietari({Key? key}) : super(key: key);

  @override
  State<PaginProprietari> createState() => _PaginProprietariState();
}

class _PaginProprietariState extends State<PaginProprietari> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Proprietari"),
      ),
      body: ListViewProprietari(),
    );
  }
}

class ListViewProprietari extends StatefulWidget {
  const ListViewProprietari({Key? key}) : super(key: key);

  @override
  State<ListViewProprietari> createState() => _ListViewProprietariState();
}

class _ListViewProprietariState extends State<ListViewProprietari> {
  List<Object> listProprietari = [];
  TextEditingController txtSearchController = TextEditingController();

  Future getListProprietari(String searchTxt) async {
    await FirebaseFirestore.instance
        .collection("proprietari")
        .get()
        .then((value) {
      setState(() {
        if (searchTxt.isEmpty) {
          listProprietari =
              List.from(value.docs.map((e) => ProprietarObj.fromSnapshot(e)));
        } else {
          listProprietari = List.from(value.docs
              .map((e) => ProprietarObj.fromSnapshot(e))
              .where((element) => element.nume == searchTxt));
        }
      });
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    getListProprietari(txtSearchController.text);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
              padding: EdgeInsets.all(1),
              margin: EdgeInsets.all(20),
              child: Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)),
                child: TextField(
                  onSubmitted: (value) {
                    setState(() {
                      txtSearchController.text = value;
                    });
                    getListProprietari(value);
                  },
                  controller: txtSearchController,
                  style: TextStyle(fontSize: 16),
                  decoration: InputDecoration(
                      labelText: "Cauta dupa nume",
                      border: InputBorder.none,
                      prefix: Icon(Icons.search)),
                ),
              )),
          SizedBox(
            height: 600,
            child: ListView.builder(
                itemCount: listProprietari.length,
                itemBuilder: (context, index) {
                  return CardProprietar(
                      listProprietari[index] as ProprietarObj);
                }),
          ),
        ],
      ),
    );
  }
}

class CardProprietar extends StatelessWidget {
  final ProprietarObj proprietar;

  CardProprietar(this.proprietar);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Container(
            height: 140,
            width: MediaQuery.of(context).size.width - 26,
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(55),
                      bottomLeft: Radius.circular(55))),
              child: Column(
                children: [
                  Container(
                    child: Text(
                      "Informatii",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    alignment: Alignment.center,
                    padding: EdgeInsets.all(14),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        child: Text("Nume proprietar: ${proprietar.nume}"),
                      ),
                      Container(
                        child: Text("Apartament: ${proprietar.apartament}"),
                      ),
                      Container(
                        padding: EdgeInsets.only(left: 60, right: 60),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            TextButton(
                              child: Icon(Icons.call),
                              onPressed: () async {
                                Uri apel =
                                    Uri.parse("tel:${proprietar.telefon}");
                                await launchUrl(apel);
                              },
                            ),
                            TextButton(
                              child: Icon(Icons.notifications),
                              onPressed: () async {
                                Uri apel =
                                    Uri.parse("tel:${proprietar.telefon}");
                                await launchUrl(apel);
                              },
                            ),
                          ],
                        ),
                        // child: Icon(Icons.call),
                        // padding: EdgeInsets.only(top: 15),
                      ),
                    ],
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
