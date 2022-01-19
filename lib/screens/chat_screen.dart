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
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('/Chat/qeWt7Q0aw6JUc0s7OnTb/message')
            .snapshots(),
        builder: (ctx, streamSnapshot) {
          if (streamSnapshot.hasError) {
            return const Text('Something went wrong');
          }

          if (streamSnapshot.connectionState == ConnectionState.waiting) {
            return const Text("Loading");
          }
          final chatData = streamSnapshot.data!.docs;
          return ListView.builder(
            itemCount: chatData.length,
            itemBuilder: (ctx, index) {
              return Container(
                padding: const EdgeInsets.all(8),
                child: Text(chatData[index]['text']),
              );
            },
          );
        },
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
