import 'package:appxfirebase/view/auth/screen/login_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../auth/firebase/firebase_auth_controller.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Screen'),
      ),
      body: Center(
        child: CupertinoButton(
          color: Colors.blue,
          child: const Text('Log Out'),
          onPressed: () async {
            // TODO : Log Out
            await FirebaseAuthController().logOut().then((value) {
              if (value) {
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LoginScreen(),
                    ),
                    (route) => false);
              }
            });
          },
        ),
      ),
    );
  }
}
