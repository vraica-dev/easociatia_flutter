import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../helpers.dart';
import '../authModule/auth.dart';
import 'package:intl/intl.dart';
import 'package:untitled/generic_objects.dart';

class IstoricPage extends StatefulWidget {
  @override
  State<IstoricPage> createState() => _IstoricPageState();
}

class _IstoricPageState extends State<IstoricPage> {
  List<Object> istoricList = [];

  void _deleteIntretinere(int indxIntretinere) {
    showDialog(
        context: context,
        builder: (context) => ConfirmareStergere(delete)).then((value) {
      if (value) {
        delete(indxIntretinere);
      }
    });
  }

  Future delete(int indxIntretinere) async {
    IntretinereObj objToBeDeleted =
        istoricList.elementAt(indxIntretinere) as IntretinereObj;
    await FirebaseFirestore.instance
        .collection("intretinere")
        .where("record_number", isEqualTo: objToBeDeleted.record_number)
        .get()
        .then((value) {
      value.docs.first.reference.delete();
      setState(() {
        istoricList.removeAt(indxIntretinere);
      });
    });
  }

  Future getHistoricalData(bool isAdmin) async {
    await FirebaseFirestore.instance
        .collection("intretinere")
        .orderBy("data", descending: true)
        .get()
        .then((value) {
      setState(() {
        if (isAdmin) {
          istoricList =
              List.from(value.docs.map((e) => IntretinereObj.fromSnapshot(e)));
        } else {
          istoricList = List.from(value.docs
              .map((e) => IntretinereObj.fromSnapshot(e))
              .where((element) =>
                  element.unique_generated_key ==
                  ClientAuth().fauth.currentUser?.uid.toString()));
        }
      });
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    getHistoricalData(ClientAuth().isAdmin());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("ISTORIC"),
        backgroundColor: Colors.blueAccent,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(26),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(22))),
              child: Text("Inregistrari Anterioare",
                  style: TextStyle(fontSize: 22)),
            ),
            Expanded(
              child: ListView.builder(
                  itemCount: istoricList.length,
                  itemBuilder: (context, index) {
                    return DataIstorica(istoricList[index] as IntretinereObj,
                        index, _deleteIntretinere);
                  }),
            ),
          ],
        ),
      ),
    );
  }
}

class DataIstorica extends StatelessWidget {
  final IntretinereObj intretinereObj;
  final int indxRecord;
  final Function callback;

  DataIstorica(this.intretinereObj, this.indxRecord, this.callback);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(7),
      child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            //set border radius more than 50% of height and width to make circle
          ),
          elevation: 7,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    child: Text("${indxRecord + 1} |",
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.bold)),
                    padding: EdgeInsets.all(5),
                  ),
                  const Icon(Icons.history_sharp),
                  Container(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Text('Proprietar: ${intretinereObj.proprietar}'),
                        Text('Apartament nr: ${intretinereObj.apartament}'),
                        Text(
                            'Index apa calda: ${intretinereObj.idx_apa_calda}'),
                        Text('Index apa rece: ${intretinereObj.idx_apa_rece}'),
                        Text(
                            'Data Raportare: ${DateFormat('yyyy-MM-dd').format(intretinereObj.data_rep)}')
                        // Text('Data raportare: ${intretinereObj.data_rep}')
                      ], /**/
                    ),
                  )
                ],
              ),
              const Text(
                "|",
                style: TextStyle(fontSize: 22, color: Colors.grey),
              ),
              Row(
                children: [
                  TextButton(
                      child: const Icon(Icons.edit, color: Colors.greenAccent),
                      onPressed: () => {}),
                  TextButton(
                      child: const Icon(Icons.delete, color: Colors.redAccent),
                      onPressed: () {
                        callback(indxRecord);
                      }),
                ],
              )
            ],
          )),
    );
  }
}
