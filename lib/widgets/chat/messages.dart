import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import './message_bubble.dart';

class Messages extends StatelessWidget {
  const Messages({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
          itemBuilder: (ctx, index) => MessageBubble(chatData[index]['text']),
        );
      },
    );
  }
}
