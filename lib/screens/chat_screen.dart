import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../widgets/chat/messages.dart';
import '../widgets/chat/new_message.dart';

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
            NewMessage(),
          ],
        ),
      ),
    );
  }
}
