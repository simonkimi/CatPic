import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);
  static var routeName = 'LoginPage';

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(color: Theme.of(context).primaryColor),
        child: Center(
          child: Container(
            width: 270,
            height: 320,
            child: Card(
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: const [],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
