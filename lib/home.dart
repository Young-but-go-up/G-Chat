import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'chat/chat.dart';
import 'question/question.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool questionSelected = true;
  bool chatSelected = false;
  @override
  Widget build(BuildContext context) {
    final selectedFont = GoogleFonts.poppins(
      fontWeight: FontWeight.bold,
      color: Colors.black,
      letterSpacing: 1.5,
      fontSize: 15,
      height: 2,
    );
    final unSelectedFont = GoogleFonts.poppins(
      fontWeight: FontWeight.w500,
      color: Colors.grey.shade700,
      letterSpacing: 1.5,
      fontSize: 12,
    );

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
              "G-Chat",
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.bold,
                color: Colors.black,
                letterSpacing: 1.5,
                fontSize: 20,
              ),
            ),
          ],
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(questionSelected ? 0 : 25),
            bottomRight: Radius.circular(questionSelected ? 0 : 25),
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size(double.infinity, 50),
          child: SizedBox(
            height: 50,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    GestureDetector(
                      onTap: selectModel,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: questionSelected ? 15 : 25,
                          vertical: questionSelected ? 3 : 10,
                        ),
                        child: Column(
                          children: [
                            Text(
                              "Question",
                              style: questionSelected
                                  ? selectedFont
                                  : unSelectedFont,
                              textAlign: TextAlign.center,
                            ),
                            if (questionSelected)
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.black,
                                  borderRadius: BorderRadius.circular(25),
                                ),
                                height: 5,
                                width: 50,
                              ),
                          ],
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: selectModel,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: chatSelected ? 15 : 25,
                          vertical: chatSelected ? 3 : 10,
                        ),
                        child: Column(
                          children: [
                            Text(
                              "Chat",
                              style:
                                  chatSelected ? selectedFont : unSelectedFont,
                              textAlign: TextAlign.center,
                            ),
                            if (chatSelected)
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.black,
                                  borderRadius: BorderRadius.circular(25),
                                ),
                                height: 5,
                                width: 25,
                              ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      body: chatSelected ? const ChatPage() : const QuestionPage(),
    );
  }

  void selectModel() {
    setState(() {
      questionSelected = !questionSelected;
      chatSelected = !chatSelected;
    });
  }
}
