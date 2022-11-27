import 'package:flutter/material.dart';
import 'dart:ffi';
import 'dart:ui';
import 'dart:async';
import 'package:flutter/material.dart';
import 'drawerModule/meniu.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:math';
import 'authModule/auth.dart';

class NewUser {
  String? email;
  String? nume;
  int? apartament;
  String? telefon;
  String? parola_f;
  String? parola_s;

  NewUser(this.email, this.nume, this.apartament, this.telefon, this.parola_f,
      this.parola_s);

  bool validateEmail() {
    if (email == null) {
      return false;
    }
    return true;
  }

  bool validatePass() {
    if (parola_f == parola_s) {
      return true;
    }
    return false;
  }

  bool isValid() {
    if (validateEmail() && validatePass() && apartament != null) {
      return true;
    }
    return false;
  }
}

class ProprietarObj {
  String email = "";
  String? telefon;
  String nume = "";
  int apartament = 0;
  String unique_id = "";

  ProprietarObj();

  Map<String, dynamic> toJson() =>
      {'nume': nume, 'apartament': apartament, 'telefon': telefon};

  ProprietarObj.fromSnapshot(snap) {
    email = snap.data()['email'];
    nume = snap.data()['nume'];
    apartament = snap.data()['ap'];
    telefon = snap.data()['telefon'];
    unique_id = snap.data()['unique_generated_id'];
  }
}

class IntretinereObj {
  String proprietar = "";
  int apartament = 0;
  int idx_apa_calda = 0;
  int idx_apa_rece = 0;
  DateTime data_rep = DateTime.now();
  String usr_email = "";
  String record_number = "";
  String? unique_generated_key;

  IntretinereObj();

  Map<String, dynamic> toJson() => {
        'proprietar': proprietar.toString(),
        'apartament': apartament,
        'idx_apa_rece': idx_apa_rece,
        'idx_apa_calda': idx_apa_calda,
        'email': usr_email,
        'data': data_rep
      };

  IntretinereObj.fromSnapshot(snap) {
    proprietar = snap.data()['proprietar'];
    apartament = snap.data()['ap'];
    idx_apa_calda = snap.data()['idx_apa_calda'];
    idx_apa_rece = snap.data()['idx_apa_rece'];
    data_rep = (snap.data()['data'] as Timestamp).toDate();
    usr_email = snap.data()['email'].toString();
    record_number = snap.data()['record_number'].toString();
    unique_generated_key = snap.data()['unique_generated_key'].toString();
  }

  getFormatedDate() {
    return "${this.data_rep.day}/${this.data_rep.month}/${this.data_rep.year}";
  }
}
