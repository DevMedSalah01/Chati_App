import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../chats/message_bubble.dart';

class Messages extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
        final user = FirebaseAuth.instance.currentUser;
        return StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('chat')
                .orderBy(
                  'createdAt',
                  descending: true,
                )
                .snapshots(),
            builder: (ctx, AsyncSnapshot<QuerySnapshot> chatSnapshot) {
              if (chatSnapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              final chatDocs = chatSnapshot.data.docs;
              return ListView.builder(
                reverse: true,
                itemCount: chatDocs.length,
                itemBuilder: (ctx, index) => MessageBubble(
                  chatDocs[index].data()['text'],
                  chatDocs[index].data()['username'],
                  chatDocs[index].data()['userImage'],
                  chatDocs[index].data()['userId'] == user.uid,
                  key: ValueKey(chatDocs[index].id),
                ),
              );
      },
    );
  }
}
