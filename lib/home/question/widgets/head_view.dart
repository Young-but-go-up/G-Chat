import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HeadView extends StatelessWidget {
  const HeadView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 125,
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(25),
          bottomRight: Radius.circular(25),
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Salut ",
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.normal,
                  color: Colors.black.withOpacity(0.7),
                  fontSize: 15,
                ),
              ),
              Text(
                "Georges !",
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                  fontSize: 18,
                ),
              ),
            ],
          ),
          Text(
            "Tu as encore des questionnaires\nà résoudre aujourd'hui ? Allez balance\nqu'on traite ensemble !",
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.normal,
              color: Colors.black,
              fontSize: 13,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
