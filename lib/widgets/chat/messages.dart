import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import './message_bubble.dart';

class Messages extends StatelessWidget {
  const Messages({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('/Chat')
          .orderBy('createdAt', descending: true)
          .snapshots(),
      builder: (ctx, chatSnapshot) {
        if (chatSnapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (chatSnapshot.hasError) {
          return const Text('Something went wrong');
        }
        final chatData = chatSnapshot.data!.docs;

        return ListView.builder(
          reverse: true,
          itemCount: chatData.length,
          itemBuilder: (ctx, index) => MessageBubble(
            chatData[index]['text'],
            chatData[index]['userId'] == currentUser!.uid,
            chatData[index]['userName'],
            key: ValueKey(chatData[index].id), //this is doc Id
          ),
        );
      },
    );
  }
}
