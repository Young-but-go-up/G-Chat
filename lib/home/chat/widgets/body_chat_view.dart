import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

import '../../../shared/notifier.dart';
import 'chat_view.dart';

class BodyChatView extends StatefulWidget {
  final MyListNotifier chatList;
  const BodyChatView({super.key, required this.chatList});

  @override
  State<BodyChatView> createState() => _BodyChatViewState();
}

ScrollController controller = ScrollController();

class _BodyChatViewState extends State<BodyChatView> {
  @override
  Widget build(BuildContext context) {
    bool isWeb = kIsWeb;
    return isWeb
        ? RawScrollbar(
            controller: controller,
            radius: const Radius.circular(25),
            thumbColor: Colors.black,
            trackColor: Colors.grey,
            thickness: 8,
            crossAxisMargin: 3,
            padding: const EdgeInsets.only(bottom: 60),
            child: ChatView(
              chatList: widget.chatList,
              controller: controller,
            ),
          )
        : ChatView(
            chatList: widget.chatList,
            controller: controller,
          );
  }
}
