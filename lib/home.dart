import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'chat/chat.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              margin: const EdgeInsets.only(right: 10),
              child: Image.asset("images/logo.png"),
            ),
            Text(
              "Gemini ChatBot",
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.bold,
                color: Colors.black,
                letterSpacing: 1.5,
                fontSize: 20,
              ),
            ),
          ],
        ),
      ),
      body: const ChatView(),
    );
  }
}
