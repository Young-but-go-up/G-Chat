import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../shared/notifier.dart';

class CoursesChoice extends StatefulWidget {
  const CoursesChoice(
      {super.key, required this.selectionOff, required this.courses});
  final bool selectionOff;
  final List courses;
  @override
  State<CoursesChoice> createState() => _CoursesChoiceState();
}

class _CoursesChoiceState extends State<CoursesChoice> {
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
            onTap: () => widget.selectionOff ? null : onSelectCourse(index),
            child: Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              decoration: BoxDecoration(
                color: courseIndex.value == index && !widget.selectionOff
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
                  if (courseIndex.value == index && !widget.selectionOff) ...{
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

  void onSelectCourse(index) {
    setState(() {
      courseIndex.value != index
          ? courseIndex.value = index
          : courseIndex.value = null;
    });
  }
}
