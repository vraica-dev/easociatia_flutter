import 'package:flutter/material.dart';
import 'auth.dart';
import '../helpers.dart';
import 'package:untitled/generic_objects.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:untitled/authModule/login.dart';


class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: CustomBody(),
      bottomSheet: CustomFooter(),
    );
  }
}

class CustomBody extends StatefulWidget {
  const CustomBody({Key? key}) : super(key: key);

  @override
  State<CustomBody> createState() => _CustomBodyState();
}

class _CustomBodyState extends State<CustomBody> {
  var authHandler = ClientAuth();

  Future<void> registerUserDatabase(NewUser userObj) async {
    Map<String, dynamic> newUserD = {
      "nume": userObj.nume.toString(),
      "email": userObj.email.toString(),
      "ap": userObj.apartament,
      "telefon": userObj.telefon.toString(),
      "unique_generated_id": ClientAuth().fauth.currentUser?.uid.toString()
    };

    await FirebaseFirestore.instance.collection("proprietari").add(newUserD);
  }

  Future<void> fullRegister(NewUser userObj) async {
    await ClientAuth()
        .registerUser(userObj)
        .then((value) async => await registerUserDatabase(userObj));
  }

  TextEditingController emailController = TextEditingController();
  TextEditingController numeController = TextEditingController();
  TextEditingController passwordController_first = TextEditingController();
  TextEditingController passwordController_second = TextEditingController();
  TextEditingController apartamentController = TextEditingController();
  TextEditingController telefonController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Column(
      children: [
        Stack(
          fit: StackFit.loose,
          children: [
            Positioned(
              child: Container(
                width: double.infinity,
                height: 350,
                decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(42),
                        bottomRight: Radius.circular(42)),
                    color: Colors.blueAccent),
              ),
            ),
            Positioned(
              child: Container(
                padding: EdgeInsets.only(top: 80, left: 5, right: 5),
                child: Card(
                  elevation: 15,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                    //set border radius more than 50% of height and width to make circle
                  ),
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.only(top: 22),
                        child: const Text("INREGISTRARE",
                            style: TextStyle(
                                letterSpacing: 11,
                                color: Colors.blueAccent,
                                fontSize: 24)),
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 22, right: 22, top: 20),
                          child: TextField(
                            controller: emailController,
                            decoration: const InputDecoration(
                                labelText: "Email",
                                prefix: Icon(Icons.mail),
                                border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        width: 5, color: Colors.black),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20)))),
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 22, right: 22, bottom: 20, top: 10),
                          child: TextField(
                            controller: numeController,
                            decoration: const InputDecoration(
                                labelText: "Nume",
                                prefix: Icon(Icons.people),
                                border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        width: 5, color: Colors.black),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20)))),
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 22, right: 22, bottom: 20, top: 10),
                          child: TextField(
                            controller: apartamentController,
                            decoration: const InputDecoration(
                                labelText: "Apartament",
                                prefix: Icon(Icons.house),
                                border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        width: 5, color: Colors.black),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20)))),
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 22, right: 22, bottom: 20, top: 10),
                          child: TextField(
                            controller: telefonController,
                            decoration: const InputDecoration(
                                labelText: "Telefon",
                                prefix: Icon(Icons.phone),
                                border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        width: 5, color: Colors.black),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20)))),
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 22, right: 22, bottom: 20, top: 10),
                          child: TextField(
                            controller: passwordController_first,
                            obscureText: true,
                            decoration: const InputDecoration(
                                labelText: "Parola",
                                prefix: Icon(Icons.password),
                                border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        width: 5, color: Colors.black),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20)))),
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 22, right: 22, bottom: 20),
                          child: TextField(
                            controller: passwordController_second,
                            obscureText: true,
                            decoration: const InputDecoration(
                                labelText: "Introduceti inca o data parola",
                                prefix: Icon(Icons.password),
                                border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        width: 5, color: Colors.black),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20)))),
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.only(top: 20, bottom: 20),
                        child: ElevatedButton(
                          onPressed: () async {
                            NewUser user = NewUser(
                                emailController.text,
                                numeController.text,
                                int.parse(apartamentController.text),
                                telefonController.text,
                                passwordController_first.text,
                                passwordController_second.text);

                            await fullRegister(user)
                                .then((value) => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => const Login())))
                                .catchError((e) {
                              showDialog(
                                  context: context,
                                  builder: (context) => InvalidCredDialog());
                            });
                          },
                          style: ButtonStyle(
                            foregroundColor: MaterialStateProperty.all<Color>(
                                Colors.blueAccent),
                          ),
                          child: const Text(
                            "CONFIRMA",
                            style: TextStyle(
                                letterSpacing: 7,
                                fontWeight: FontWeight.bold,
                                fontSize: 21,
                                color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    ));
  }
}

class CustomFooter extends StatelessWidget {
  const CustomFooter({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          "Developed by vraica_.",
          style: TextStyle(
              fontSize: 11, color: Colors.grey, fontWeight: FontWeight.bold),
        ),
        Container(
          padding: const EdgeInsets.only(right: 5),
          child: Text(
            "T",
            style: TextStyle(
                fontSize: 11, color: Colors.grey, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}
