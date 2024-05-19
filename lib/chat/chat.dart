import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'widgets/bottom_chat_view.dart';
import 'widgets/body_chat_view.dart';
import 'notifier.dart';

class ChatView extends StatefulWidget {
  const ChatView({super.key});

  @override
  State<ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> {
  final chatList = MyListNotifier();

  @override
  void initState() {
    super.initState();
    
    chatList.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 10,
        left: 20,
        right: 20,
      ),
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          BodyChatView(chatList: chatList),
          BottomChatView(chatList: chatList),
        ],
      ),
    );
  }
}
