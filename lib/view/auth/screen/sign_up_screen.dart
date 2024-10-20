import 'dart:developer';

import 'package:appxfirebase/view/auth/screen/login_screen.dart';
import 'package:flutter/material.dart';

import '../firebase/firebase_auth_controller.dart';

class SignUpScrren extends StatefulWidget {
  const SignUpScrren({super.key});

  @override
  State<SignUpScrren> createState() => _SignUpScrrenState();
}

class _SignUpScrrenState extends State<SignUpScrren> {
  final emailController = TextEditingController();
  final passWordController = TextEditingController();
  final cpassWordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              controller: emailController,
              decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.email),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)),
                  hintText: 'E-mail'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              // obscureText: true,
              controller: passWordController,
              decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.lock),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)),
                  hintText: 'password'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              // obscureText: true,
              controller: cpassWordController,
              decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.lock),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)),
                  hintText: 'confirm password'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              onTap: () async {
                //TODO : Register User Account
                if (emailController.text.isNotEmpty ||
                    passWordController.text.isNotEmpty ||
                    cpassWordController.text.isNotEmpty) {
                  if (passWordController.text == cpassWordController.text) {
                    await FirebaseAuthController()
                        .createUser(
                            email: emailController.text.trim(),
                            password: passWordController.text.trim())
                        .then((value) {
                      if (value != null) {
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const LoginScreen(),
                            ),
                            (route) => false);
                      }
                    });
                  } else {
                    log('password');
                  }
                } else {
                  log('Field is Blind');
                }
              },
              child: Container(
                height: 50,
                width: double.infinity,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.blue),
                child: const Center(
                  child: Text(
                    'Create',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
