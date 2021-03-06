import 'dart:io';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../widgets/auth/auth_form.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _auth = FirebaseAuth.instance;
  bool _isLoading = false;

  void _submitFunction(
    String userEmail,
    String userName,
    String userPassword,
    File? imageFile,
    bool isLogin,
    BuildContext ctx,
  ) async {
    UserCredential userCredential;
    try {
      setState(() {
        _isLoading = true;
      });
      if (isLogin) {
        userCredential = await _auth.signInWithEmailAndPassword(
          email: userEmail,
          password: userPassword,
        );
      } else {
        userCredential = await _auth.createUserWithEmailAndPassword(
          email: userEmail,
          password: userPassword,
        );

        final ref = FirebaseStorage.instance
            .ref()
            .child('user_images')
            .child('${userCredential.user!.uid}.jpg');

        await ref.putFile(imageFile!);
        final url =await ref.getDownloadURL();

        await FirebaseFirestore.instance
            .collection('/users')
            .doc(userCredential.user!.uid)
            .set({
          'userName': userName,
          'userEmail': userEmail,
          'image_url': url,
        });
      }
    } on FirebaseAuthException catch (e) {
      String message = 'error happened!';
      if (e.code == 'weak-password') {
        message = 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        message = 'The account already exists for that email.';
      } else if (e.code == 'user-not-found') {
        message = 'No user found for that email.';
      } else if (e.code == 'wrong-password') {
        message = 'Wrong password provided for that user.';
      }

      ScaffoldMessenger.of(ctx).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Theme.of(context).errorColor,
        ),
      );
      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      ScaffoldMessenger.of(ctx).showSnackBar(
        SnackBar(
          content: const Text('Check info!!'),
          backgroundColor: Theme.of(context).errorColor,
        ),
      );
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.pink,
      body: AuthForm(_submitFunction, _isLoading),
    );
  }
}
