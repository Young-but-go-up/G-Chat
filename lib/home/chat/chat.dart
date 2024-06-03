import 'package:flutter/material.dart';

import 'widgets/bottom_chat_view.dart';
import 'widgets/body_chat_view.dart';
import '../../shared/notifier.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
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
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        BodyChatView(chatList: chatList),
        BottomChatView(chatList: chatList),
      ],
    );
  }
}
