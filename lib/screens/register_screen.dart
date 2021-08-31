import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
    final TextEditingController _emailController = TextEditingController();
    final TextEditingController _passwordController = TextEditingController();

    final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
    @override
    Widget build(BuildContext context) {
        return Scaffold(
            appBar: AppBar(
            elevation: 2,
            backgroundColor: Colors.white,
            centerTitle: true,
            leading: IconButton(
                onPressed: () => Navigator.of(context).pop(),
                color: Colors.grey[800],
                icon: Icon(Icons.arrow_back_ios_new_rounded)),
            ),
            body: Container(
            padding: EdgeInsets.symmetric(horizontal: 10),
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            alignment: Alignment.center,
            child: Form(
                child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                    TextFormField(
                        controller: _emailController,
                        decoration: InputDecoration(
                            labelText: 'EMAIL',
                            labelStyle: TextStyle(
                                fontSize: 12.0, color: Colors.grey.withOpacity(0.8)),
                            focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.blue),
                            ))),
                    SizedBox(
                    height: 25,
                    ),
                    TextFormField(
                        controller: _passwordController,
                        obscureText: true,
                        decoration: InputDecoration(
                            labelText: 'PASSWORD',
                            labelStyle: TextStyle(
                                fontSize: 12.0, color: Colors.grey.withOpacity(0.8)),
                            focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.blue),
                            ))),
                    SizedBox(
                    height: 10,
                    ),
                    Row(
                    children: [
                        Expanded(
                            child: ElevatedButton(
                                onPressed: () async {
                                await _firebaseAuth.createUserWithEmailAndPassword(
                                    email: _emailController.text,
                                    password: _passwordController.text);
                                },
                                child: Text('Register'))),
                        SizedBox(
                        width: 10,
                        ),
                        Expanded(
                            child: ElevatedButton(
                                onPressed: () async {
                                await _firebaseAuth
                                    .signInWithEmailAndPassword(
                                        email: _emailController.text,
                                        password: _passwordController.text)
                                    .then((value) => print('Login Successful'));
                                },
                                child: Text('Login')
                            )
                        )
                    ])
                ])
            ))
        );
    }
}