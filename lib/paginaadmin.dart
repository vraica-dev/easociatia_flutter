import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:untitled/generic_objects.dart';


class PaginaAdmin extends StatefulWidget {
  const PaginaAdmin({Key? key}) : super(key: key);

  @override
  State<PaginaAdmin> createState() => _PaginaAdminState();
}

class _PaginaAdminState extends State<PaginaAdmin> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: const Align(
          child: Text('A D M I N '),
          alignment: Alignment.bottomRight,
        )),
        body: PageBody());
  }
}

class PageBody extends StatefulWidget {
  @override
  State<PageBody> createState() => _PageBodyState();
}

class _PageBodyState extends State<PageBody> {
  bool currentMonth = false;

  bool getCM() {
    return this.currentMonth;
  }

  final GlobalKey<_IstoricDataState> _k = GlobalKey<_IstoricDataState>();

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Container(
            child: Stack(
              children: [
                Image(
                  image: AssetImage("assets/images/blueb.jpeg"),
                ),
                Container(
                  padding: EdgeInsets.only(top: 32, left: 5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text("Bun venit!",
                          style: TextStyle(color: Colors.white, fontSize: 22)),
                      Text("Dle/Dna Administrator",
                          style: TextStyle(
                              color: Colors.white60,
                              fontSize: 30,
                              fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
                Container(
                  child: lastEntry(),
                ),
                Container(
                  padding: EdgeInsets.all(2),
                  child: dueEntries(),
                )
              ],
            ),
          ),
          Container(child: IstoricData()),
        ],
      ),
    );
  }
}

class lastEntry extends StatefulWidget {
  const lastEntry({Key? key}) : super(key: key);

  @override
  State<lastEntry> createState() => _lastEntryState();
}

class _lastEntryState extends State<lastEntry> {
  IntretinereObj? lastOne;

  Future getLastEntry() async {
    await FirebaseFirestore.instance
        .collection("intretinere")
        .orderBy("data", descending: true)
        .get()
        .then((value) {
      setState(() {
        lastOne = IntretinereObj.fromSnapshot(value.docs.last);
      });
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    getLastEntry();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.only(top: 110),
      child: Card(
        elevation: 8,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(18))),
        child: Column(
          children: [
            Container(
              padding:
                  EdgeInsets.only(bottom: 19, top: 11, left: 90, right: 90),
              child: Text(
                "ULTIMA INREGISTRARE",
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueAccent),
              ),
            ),
            Container(
              padding: EdgeInsets.only(bottom: 5),
              child: Column(
                children: [
                  Text(
                    "Nume proprietar: ${lastOne?.proprietar}",
                    style: TextStyle(fontSize: 16),
                  ),
                  Text("Data inregistrare: ${lastOne?.getFormatedDate()}",
                      style: TextStyle(fontSize: 16)),
                  Text("Indice apa rece: ${lastOne?.idx_apa_rece}",
                      style: TextStyle(fontSize: 16)),
                  Text("Indice apa calda: ${lastOne?.idx_apa_calda}",
                      style: TextStyle(fontSize: 16))
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class dueEntries extends StatefulWidget {
  const dueEntries({Key? key}) : super(key: key);

  @override
  State<dueEntries> createState() => _dueEntriesState();
}

class _dueEntriesState extends State<dueEntries> {
  List<dynamic> pending = [];

  Future<void> listPending() async {
    await FirebaseFirestore.instance
        .collection("intretinere")
        .get()
        .then((value) {
      setState(() {
        pending = List.from(value.docs
            .map((e) => IntretinereObj.fromSnapshot(e)));
            // .where(
            //     (element) => element.data_rep.month != DateTime.now().month));
      });
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    listPending();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      height: 440,
      padding: EdgeInsets.only(top: 270),
      child: Column(
        children: [
          Text(
            "IN ASTEPTARE",
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 17,
                color: Colors.blueAccent),
          ),
          Expanded(
            child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: pending.length,
                itemBuilder: (context, index) {
                  return CardPending(pending[index] as IntretinereObj);
                }),
          ),
        ],
      ),
    );
  }
}

class CardPending extends StatefulWidget {
  final IntretinereObj intretinere;

  CardPending(this.intretinere);

  @override
  State<CardPending> createState() => _CardPendingState();
}

class _CardPendingState extends State<CardPending> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 7,
      width: 100,
      child: Card(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(16))),
        elevation: 2,
        color: Color.fromRGBO(128, 183, 204, 1),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(top: 7),
              child: Text("Nume:"),
            ),
            Padding(
              padding: EdgeInsets.only(top: 2),
              child: Text(
                widget.intretinere.proprietar,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 16),
              child: Text("Ultima inregistrare:", textAlign: TextAlign.center),
            ),
            Padding(
              padding: EdgeInsets.only(top: 10),
              child: Text(widget.intretinere.getFormatedDate().toString(),
                  textAlign: TextAlign.center,
                  style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }
}

class IstoricData extends StatefulWidget {
  const IstoricData({Key? key}) : super(key: key);

  @override
  State<IstoricData> createState() => _IstoricDataState();
}

class _IstoricDataState extends State<IstoricData> {
  List<Object> istoricList = [];
  bool isCurrentM = false;

  void getHistoricalData(bool isCurrentM) async {
    await FirebaseFirestore.instance
        .collection("intretinere")
        .orderBy("data", descending: true)
        .get()
        .then((value) {
      print(isCurrentM);
      setState(() {
        if (!isCurrentM) {
          istoricList =
              List.from(value.docs.map((e) => IntretinereObj.fromSnapshot(e)));
        } else {
          istoricList = List.from(value.docs
              .map((e) => IntretinereObj.fromSnapshot(e))
              .where(
                  (element) => element.data_rep.month == DateTime.now().month));
        }
      });
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    getHistoricalData(this.isCurrentM);
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Container(
            alignment: Alignment.center,
            padding: EdgeInsets.only(bottom: 0, top: 11),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "ISTORIC",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 17,
                      color: Colors.blueAccent),
                )
              ],
            ),
          ),
          Row(
            children: [
              Checkbox(
                  value: isCurrentM,
                  onChanged: (value) {
                    setState(() {
                      isCurrentM = value!;
                    });
                    getHistoricalData(isCurrentM);
                  }),
              Text(
                "Luna curenta?",
                style: TextStyle(color: Colors.grey),
              ),
            ],
          ),
          Expanded(
            child: ListView.builder(
                scrollDirection: Axis.vertical,
                itemCount: istoricList.length,
                itemBuilder: (context, index) {
                  return CardIstoricRecord(
                      this.istoricList[index] as IntretinereObj);
                }),
          ),
        ],
      ),
    );
  }
}

class CardIstoricRecord extends StatefulWidget {
  final IntretinereObj istoricRecord;

  CardIstoricRecord(this.istoricRecord);

  @override
  State<CardIstoricRecord> createState() => _CardIstoricRecordState();
}

class _CardIstoricRecordState extends State<CardIstoricRecord> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 1, left: 20, right: 20),
      child: Card(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(16))),
        elevation: 2,
        child: Container(
          padding: EdgeInsets.all(14),
          child: Column(
            children: [
              Text(
                "Proprietar: ${widget.istoricRecord.proprietar}",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text("Data: ${widget.istoricRecord.getFormatedDate()}"),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Apa calda: ${widget.istoricRecord.idx_apa_calda}"),
                  Text("Apa rece: ${widget.istoricRecord.idx_apa_rece}")
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
