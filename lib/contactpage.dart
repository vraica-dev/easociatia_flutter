import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg_provider/flutter_svg_provider.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactPage extends StatefulWidget {
  @override
  State<ContactPage> createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  Map<String, String> details = {
    "Email": "rvg.vali@gmail.com",
    "LinkedIn": "linkedin.com/vraica",
    "Telefon": "0888888888"
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Contact"),
      ),
      floatingActionButton: (FloatingActionButton(
        onPressed: () async {
          Uri sms = Uri.parse('sms:0888888?body=VRAICA_THE_BEST');
          await launchUrl(sms);
        },
        backgroundColor: Colors.blueAccent,
        child: Icon(Icons.message),
      )),
      body: CardContact(),
    );
  }
}

class CardContact extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SingleChildScrollView(
          child: Column(
            children: [
              Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.all(30),
                  child: Container(
                    child: Card(
                      elevation: 8,
                      child: Container(
                          padding: const EdgeInsets.all(11),
                          child: const Text(
                            "CONTACT",
                            style: TextStyle(fontSize: 21, letterSpacing: 21),
                          )),
                    ),
                  )),
              Container(
                  padding: EdgeInsets.all(77),
                  child: Column(
                    children: [
                      Container(
                        child: Card(
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(6))),
                          elevation: 8,
                          child: Column(
                            children: [
                              Container(
                                  padding: const EdgeInsets.all(11),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.mail),
                                      Text(
                                        "EMAIL",
                                        style: TextStyle(
                                            fontSize: 18,
                                            letterSpacing: 3,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  )),
                              Container(
                                  padding: const EdgeInsets.all(11),
                                  child: const Text(
                                    "rvg.vali@gmail.com",
                                    style: TextStyle(
                                        fontSize: 18,
                                        letterSpacing: 3,
                                        color: Colors.blueAccent),
                                  )),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(top: 40),
                        child: Card(
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(6))),
                          elevation: 8,
                          child: Column(
                            children: [
                              Container(
                                  padding: const EdgeInsets.all(11),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.web),
                                      Text(
                                        "LinkedIN",
                                        style: TextStyle(
                                            fontSize: 18,
                                            letterSpacing: 3,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  )),
                              Container(
                                  padding: const EdgeInsets.all(11),
                                  child: const Text(
                                    "linekdin.com/vraica",
                                    style: TextStyle(
                                        fontSize: 18,
                                        letterSpacing: 3,
                                        color: Colors.blueAccent),
                                  )),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        height: 140,
                        width: 256,
                        padding: EdgeInsets.only(top: 40),
                        child: Card(
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(6))),
                          elevation: 8,
                          child: Column(
                            children: [
                              Container(
                                  padding: const EdgeInsets.all(11),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.phone),
                                      Text(
                                        "Phone Number",
                                        style: TextStyle(
                                            fontSize: 18,
                                            letterSpacing: 3,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  )),
                              Container(
                                  padding: const EdgeInsets.all(11),
                                  child: const Text(
                                    "076037888888",
                                    style: TextStyle(
                                        fontSize: 18,
                                        letterSpacing: 3,
                                        color: Colors.blueAccent),
                                  )),
                            ],
                          ),
                        ),
                      ),
                    ],
                  )),
              Container(
                padding: EdgeInsets.only(top: 48),
                child: Container(
                    child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Sau trimite mesaj aici",
                      style: TextStyle(color: Colors.blueAccent, fontSize: 18),
                    ),
                    Container(
                      padding: EdgeInsets.only(left: 12),
                    ),
                    Icon(
                      Icons.arrow_circle_right,
                      color: Colors.blueAccent,
                    )
                  ],
                )),
              )
            ],
          ),
        )
      ],
    );
  }
}
