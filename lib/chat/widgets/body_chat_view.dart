import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../notifier.dart';

class BodyChatView extends StatefulWidget {
  final MyListNotifier chatList;
  const BodyChatView({super.key, required this.chatList});

  @override
  State<BodyChatView> createState() => _BodyChatViewState();
}

class _BodyChatViewState extends State<BodyChatView> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      primary: true,
      scrollDirection: Axis.vertical,
      itemCount: widget.chatList.value.length,
      itemBuilder: (context, index) {
        final chatlist = widget.chatList.value;
        return Column(
          crossAxisAlignment: chatlist[index].id == 'user'
              ? CrossAxisAlignment.end
              : CrossAxisAlignment.start,
          children: [
            if (chatlist[index].id == 'user') ...{
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  if (chatlist[index].image != null)
                    Container(
                      height: 200,
                      color: Colors.grey.shade300,
                      margin: const EdgeInsets.only(bottom: 5),
                      child: Image.file(chatlist[index].image),
                    ),
                  if (chatlist[index].content != null)
                    Container(
                      padding: const EdgeInsets.all(20),
                      margin: const EdgeInsets.only(left: 40, bottom: 15),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade400,
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(25),
                          bottomRight: Radius.circular(25),
                          topLeft: Radius.circular(25),
                        ),
                      ),
                      child: Text(
                        '${chatlist[index].content}',
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                          fontSize: 15,
                        ),
                      ),
                    ),
                ],
              ),
            } else ...{
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 25,
                    height: 25,
                    margin: const EdgeInsets.only(right: 10),
                    child: Image.asset("images/logo.png"),
                  ),
                  if (chatlist[index].content != null)
                    Expanded(
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 15),
                        child: Text(
                          '${chatlist[index].content}',
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                            fontSize: 15,
                          ),
                          textAlign: TextAlign.justify,
                        ),
                      ),
                    ),
                ],
              ),
            },
            chatlist.length == index + 1
                ? const SizedBox(height: 60)
                : Container()
          ],
        );
      },
    );
  }
}
