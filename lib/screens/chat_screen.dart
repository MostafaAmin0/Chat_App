import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const Center(child: Text("loading")),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          FirebaseFirestore.instance
              .collection('/Chat/qeWt7Q0aw6JUc0s7OnTb/message')
              .snapshots()
              .listen((event) {
              event.docs.forEach((element) { 
                print(element['text']);
              });
          });
        },
      ),
    );
  }
}
