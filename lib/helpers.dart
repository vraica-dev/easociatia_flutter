import 'dart:ffi';
import 'dart:ui';
import 'dart:async';
import 'package:flutter/material.dart';
import 'drawerModule/meniu.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:math';
import 'authModule/auth.dart';

class RecordIntretinere {
  final auth = FirebaseAuth.instance;

  postIntretinere(String proprietar, int idx_apa_rece, int idx_apa_calda,
      int ap, DateTime data) {
    Map<String, dynamic> new_record = {
      'proprietar': proprietar.toString(),
      'idx_apa_rece': idx_apa_rece,
      'idx_apa_calda': idx_apa_calda,
      'ap': ap,
      'data': data.toLocal(),
      'email': auth.currentUser!.email.toString(),
      'unique_generated_key': ClientAuth().fauth.currentUser?.uid.toString(),
      'record_number': "EASO${Random().nextInt(999)}"
    };
    return FirebaseFirestore.instance.collection('intretinere').add(new_record);
  }
}

class RecordDialog extends StatelessWidget {
  const RecordDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Text("Inregistrarea indicilor a fost facut cu succes."),
      title: Text("Succes"),
      actions: [
        TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Container(
              child: Text("OK"),
            ))
      ],
    );
  }
}

class InvalidCredDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Text("Credentiale incorecte. Va rugam reincercati."),
      title: Text("Credentiale Incorecte"),
      actions: [
        TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Container(
              child: Text("Am inteles!"),
            ))
      ],
    );
  }
}

class ConfirmareStergere extends StatefulWidget {
  @override
  State<ConfirmareStergere> createState() => _ConfirmareStergereState();
  final Function deleteRecord;

  ConfirmareStergere(this.deleteRecord);
}

class _ConfirmareStergereState extends State<ConfirmareStergere> {
  bool resp = false;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Text("Esti sigur ca vrei sa stergi inregistrarea?"),
      title: Text("ATENTIE!"),
      actions: [
        TextButton(
            onPressed: () {
              Navigator.of(context).pop(true);
            },
            child: Container(
              child: Text("DA"),
            )),
        TextButton(
            onPressed: () {
              Navigator.of(context).pop(false);
            },
            child: Container(
              child: Text("NU"),
            ))
      ],
    );
  }
}

class GetAllEntries {
  getAllRecords(String email) {
    return FirebaseFirestore.instance.collection('intretinere').get();
  }
}

