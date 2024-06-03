import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../shared/notifier.dart';

class PromoChoice extends StatefulWidget {
  const PromoChoice({super.key, required this.courses});

  final List courses;
  @override
  State<PromoChoice> createState() => _PromoChoiceState();
}

class _PromoChoiceState extends State<PromoChoice> {
  bool isSelected = false;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(
          widget.courses.length,
          (index) => GestureDetector(
            onTap: () => onSelectPromo(index),
            child: Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              decoration: BoxDecoration(
                color: promoIndex.value == index
                    ? Colors.grey.shade300
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(50),
                border: Border.all(
                  color: Colors.black,
                  width: 1,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (promoIndex.value == index) ...{
                    const Icon(Icons.check_rounded, size: 18),
                    const SizedBox(width: 2),
                  },
                  Text(
                    widget.courses[index],
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.normal,
                      color: Colors.black,
                      fontSize: 12.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void onSelectPromo(index) {
    setState(() {
      promoIndex.value != index
          ? promoIndex.value = index
          : promoIndex.value = null;
    });
  }
}
