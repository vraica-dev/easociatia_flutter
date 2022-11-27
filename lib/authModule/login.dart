import 'package:flutter/material.dart';
import '../paginaPersonala.dart';
import 'auth.dart';
import '../helpers.dart';
import 'signup.dart';

String version = "v1.3.0";

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
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
  String usr = "";
  late String _mail, _pass;

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  var authHandler = ClientAuth();

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
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.only(top: 40),
                      child: Image.asset("assets/images/logoapp.png",
                          width: 150, height: 160),
                    ),
                    Container(
                      padding: EdgeInsets.only(bottom: 1),
                      child: const Text("EASociatia",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              child: Container(
                padding: EdgeInsets.only(top: 277, left: 5, right: 5),
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
                        child: const Text("A U T E N T I F I C A R E",
                            style: TextStyle(
                                color: Colors.blueAccent, fontSize: 24)),
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 22, right: 22, top: 20),
                          child: TextField(
                            controller: emailController,
                            decoration: const InputDecoration(
                                prefix: Icon(Icons.mail),
                                border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        width: 5, color: Colors.black),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20)))),
                            onChanged: (val) {
                              setState(() {
                                _mail = val.trim();
                              });
                            },
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 22, right: 22, bottom: 20, top: 10),
                          child: TextField(
                            controller: passwordController,
                            obscureText: true,
                            decoration: const InputDecoration(
                                prefix: Icon(Icons.password),
                                border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        width: 5, color: Colors.black),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20)))),
                            onChanged: (val) {
                              setState(() {
                                _pass = val.trim();
                              });
                            },
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.only(top: 20, bottom: 20),
                        child: ElevatedButton(
                          onPressed: () {
                            authHandler
                                .handleCreds(emailController.text,
                                    passwordController.text)
                                .then((value) => {
                                      Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  ViewIntretinere(_mail)))
                                    })
                                .catchError((e) {
                              showDialog(
                                  context: context,
                                  builder: (context) => InvalidCredDialog());
                              passwordController.clear();
                            });
                          },
                          style: ButtonStyle(
                            foregroundColor: MaterialStateProperty.all<Color>(
                                Colors.blueAccent),
                          ),
                          child: const Text(
                            "I N T R A",
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
              ),
            ),
            Positioned(
              child: Container(
                padding: const EdgeInsets.only(top: 617, left: 5, right: 5),
                child: Align(
                  child: TextButton(
                      child: const Text("Click aici daca nu aveti cont.",
                          style: TextStyle(color: Colors.blueAccent)),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const SignUpPage()));
                      }),
                ),
              ),
            )
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
            "$version",
            style: TextStyle(
                fontSize: 11, color: Colors.grey, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}
