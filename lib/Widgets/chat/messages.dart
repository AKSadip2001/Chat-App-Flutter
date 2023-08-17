import 'package:chat_app/Widgets/chat/message_bubble.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Messages extends StatelessWidget {
  const Messages({super.key});

  @override
  Widget build(BuildContext context) {
    User? currentUser = FirebaseAuth.instance.currentUser;
    return FutureBuilder(
      builder: (ctx, futreSnapshot) {
        if (futreSnapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        return StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('chat')
              .orderBy('createdAt', descending: true)
              .snapshots(),
          builder: (ctx, chatSnapshot) {
            if (chatSnapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            final chatDocs = chatSnapshot.data?.docs;
            return ListView.builder(
              reverse: true,
              itemCount: chatDocs?.length,
              itemBuilder: (ctx, index) => MessageBubble(
                userName: chatDocs?[index]['username'],
                message: chatDocs?[index]['text'],
                userImage: chatDocs?[index]['userImage'],
                isMe: chatDocs?[index]['userId'] == currentUser?.uid,
              ),
            );
          },
        );
      },
    );
  }
}
