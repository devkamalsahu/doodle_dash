import 'package:flutter/material.dart';
import '/Animation/FadeAnimation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final _firebaseAuth = FirebaseAuth.instance;
final _firestore = FirebaseFirestore.instance;

class LoginScreen extends StatefulWidget {
  LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _fromkey = GlobalKey<FormState>();

  String _enteredEmail = '';
  String _enteredUsername = '';
  String _enterdPassword = '';

  void _submit() async {
    final isValid = _fromkey.currentState!.validate();
    if (!isValid) {
      return;
    }
    _fromkey.currentState!.save();

    try {
      final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
          email: _enteredEmail, password: _enterdPassword);
      userCredential.user!.updateDisplayName(_enteredUsername);
      _firestore.collection('users').doc(userCredential.user!.uid).set({
        'userName': _enteredUsername,
        'email': _enteredEmail,
        'password': _enterdPassword,
      });
    } on FirebaseAuthException catch (_) {
      _firebaseAuth.signInWithEmailAndPassword(
          email: _enteredEmail, password: _enterdPassword);
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Welcome back')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Container(
            child: Column(
              children: <Widget>[
                Container(
                  height: 400,
                  decoration: const BoxDecoration(
                      image: DecorationImage(
                          image:
                              AssetImage('assets/loginImages/background.png'),
                          fit: BoxFit.fill)),
                  child: Stack(
                    children: <Widget>[
                      Positioned(
                        left: 30,
                        width: 80,
                        height: 200,
                        child: FadeAnimation(
                            1,
                            Container(
                              decoration: const BoxDecoration(
                                  image: DecorationImage(
                                      image: AssetImage(
                                          'assets/loginImages/light-1.png'))),
                            )),
                      ),
                      Positioned(
                        left: 140,
                        width: 80,
                        height: 150,
                        child: FadeAnimation(
                            1.3,
                            Container(
                              decoration: const BoxDecoration(
                                  image: DecorationImage(
                                      image: AssetImage(
                                          'assets/loginImages/light-2.png'))),
                            )),
                      ),
                      Positioned(
                        right: 40,
                        top: 40,
                        width: 80,
                        height: 150,
                        child: FadeAnimation(
                            1.5,
                            Container(
                              decoration: const BoxDecoration(
                                  image: DecorationImage(
                                      image: AssetImage(
                                          'assets/loginImages/clock.png'))),
                            )),
                      ),
                      Positioned(
                        child: FadeAnimation(
                            1.6,
                            Container(
                              margin: const EdgeInsets.only(top: 50),
                              child: const Center(
                                child: Text(
                                  "Login",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 40,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            )),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: Column(
                    children: <Widget>[
                      FadeAnimation(
                        1.8,
                        Container(
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: const [
                                BoxShadow(
                                    color: Color.fromRGBO(143, 148, 251, .2),
                                    blurRadius: 20.0,
                                    offset: Offset(0, 10))
                              ]),
                          child: Form(
                            key: _fromkey,
                            child: Column(
                              children: <Widget>[
                                Container(
                                  padding: const EdgeInsets.all(8.0),
                                  decoration: const BoxDecoration(
                                      border: Border(
                                          bottom: BorderSide(
                                              color:
                                                  Color.fromRGBO(4, 4, 4, 4)))),
                                  child: TextFormField(
                                    keyboardType: TextInputType.emailAddress,
                                    autocorrect: false,
                                    validator: (value) {
                                      if (value == null ||
                                          value.trim().isEmpty) {
                                        return 'Please enter your email address';
                                      }
                                      return null;
                                    },
                                    onSaved: (value) {
                                      _enteredEmail = value!;
                                    },
                                    style: const TextStyle(color: Colors.black),
                                    textCapitalization: TextCapitalization.none,
                                    decoration: InputDecoration(
                                        border: InputBorder.none,
                                        hintText: "Email address",
                                        hintStyle:
                                            TextStyle(color: Colors.grey[400])),
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.all(8.0),
                                  decoration: const BoxDecoration(
                                      border: Border(
                                          bottom: BorderSide(
                                              color:
                                                  Color.fromRGBO(4, 4, 4, 4)))),
                                  child: TextFormField(
                                    autocorrect: false,
                                    validator: (value) {
                                      if (value == null ||
                                          value.trim().isEmpty) {
                                        return 'Please enter your user name';
                                      }
                                      return null;
                                    },
                                    onSaved: (value) {
                                      _enteredUsername = value!;
                                    },
                                    style: const TextStyle(color: Colors.black),
                                    textCapitalization: TextCapitalization.none,
                                    decoration: InputDecoration(
                                        border: InputBorder.none,
                                        hintText: "User name",
                                        hintStyle:
                                            TextStyle(color: Colors.grey[400])),
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.all(8.0),
                                  decoration: const BoxDecoration(
                                      border: Border(
                                          bottom: BorderSide(
                                              color:
                                                  Color.fromRGBO(4, 4, 4, 4)))),
                                  child: TextFormField(
                                    onSaved: (value) {
                                      _enterdPassword = value!;
                                    },
                                    obscureText: true,
                                    style: const TextStyle(color: Colors.black),
                                    validator: (value) {
                                      if (value == null ||
                                          value.trim().isEmpty) {
                                        return 'Please enter a password';
                                      }
                                      return null;
                                    },
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: "Password",
                                      hintStyle: TextStyle(
                                        color: Colors.grey[400],
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Center(
                        child: ElevatedButton(
                          onPressed: _submit,
                          style: ButtonStyle(
                            minimumSize: MaterialStateProperty.all(
                              const Size(100, 50),
                            ),
                            textStyle: MaterialStateProperty.all(
                                Theme.of(context).textTheme.titleLarge),
                          ),
                          child: const Text('Login'),
                        ),
                      ),
                      const SizedBox(
                        height: 50,
                      ),
                      const FadeAnimation(
                          1.5,
                          Text(
                            "Login to your Instagram account",
                            style: TextStyle(
                                color: Color.fromRGBO(143, 148, 251, 1)),
                          )),
                    ],
                  ),
                )
              ],
            ),
          ),
        ));
  }
}
