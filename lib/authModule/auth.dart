import 'package:untitled/generic_objects.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';


class ClientAuth {
  final FirebaseAuth fauth = FirebaseAuth.instance;

  Future<User> handleCreds(String email, String pass) async {
    UserCredential rez =
        await fauth.signInWithEmailAndPassword(email: email, password: pass);
    final User usr = rez.user!;
    return usr;
  }

  Future<void> registerUser(NewUser userObj) async {
    await fauth
        .createUserWithEmailAndPassword(
            email: userObj.email.toString(),
            password: userObj.parola_f.toString())
        .then((value) => value.user?.uid);
  }

  FirebaseAuth getAuth() {
    return fauth;
  }

  String getCurrentUserEmail() {
    return fauth.currentUser!.email.toString();
  }

  bool isAdmin() {
    if (fauth.currentUser!.email.toString() == "admin@admin.com") {
      return true;
    }
    return false;
  }
}

class GetUserInfo {
  getProprietarData() {
    return FirebaseFirestore.instance
        .collection('proprietari')
        .where("unique_generated_id",
            isEqualTo: ClientAuth().fauth.currentUser?.uid.toString())
        .get();
  }
}

Future<void> registerUserUpdates(ProprietarObj userObj, var docId) async {
  Map<String, dynamic> newUserD = {
    "ap": userObj.apartament,
    "telefon": userObj.telefon.toString(),
  };

  await FirebaseFirestore.instance
      .collection("proprietari")
      .doc(docId)
      .update(newUserD);
}
