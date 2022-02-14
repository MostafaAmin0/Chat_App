import 'package:chat_app/widgets/chat/messages.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat'),
        actions: [
          DropdownButton(
            icon: Icon(
              Icons.more_vert,
              color: Theme.of(context).primaryIconTheme.color,
            ),
            items: [
              DropdownMenuItem(
                child: SizedBox(
                  child: Row(
                    children: const [
                      Icon(Icons.exit_to_app),
                      SizedBox(
                        width: 8,
                      ),
                      Text('LogOut!'),
                    ],
                  ),
                ),
                value: 'Logout',
              ),
            ],
            onChanged: (itemValue) {
              if (itemValue == 'Logout') {
                FirebaseAuth.instance.signOut();
              }
            },
          )
        ],
      ),
      body: SizedBox(
        child: Column(
          children: const [
            Expanded(
              child: Messages(),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          FirebaseFirestore.instance
              .collection('/Chat/qeWt7Q0aw6JUc0s7OnTb/message')
              .add({
            'text': 'Button pressed',
          });
        },
      ),
    );
  }
}
