import 'dart:io';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:file_picker/file_picker.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

import '../../shared/notifier.dart';
import 'widgets/choises.dart';
import 'widgets/head_view.dart';
import 'widgets/photo_view.dart';

class QuestionPage extends StatefulWidget {
  const QuestionPage({super.key});

  @override
  State<QuestionPage> createState() => _QuestionPageState();
}

class _QuestionPageState extends State<QuestionPage> {
  bool isWeb = kIsWeb;
  bool hasFile = false;
  bool isStreaming = false;
  dynamic photoFile, photoUrl, photoFileB, geminiResponse;
  ScrollController controller = ScrollController();

  @override
  Widget build(BuildContext context) {
    final List courses1 = ['Maths', 'InfoGen', 'Algo', 'Java'];
    final List courses2 = ['Circuit Log', 'Electronique', 'Python'];
    final List courses3 = ['Dart', 'JavaScript', 'IRS', 'Réseau'];
    final List promo = ['Bac1', 'Bac2', 'Bac3', 'Bac4'];
    final List langues = ['Français', 'Anglais', 'Swahili'];
    return ListView(
      controller: controller,
      children: [
        const HeadView(),
        GestureDetector(
          onTap: pickImageFromGallery,
          child: PhotoView(
            hasFile: hasFile,
            photoFile: photoFile,
            photoUrl: photoUrl,
          ),
        ),
        // if (hasFile)
        //   GestureDetector(
        //     onTap: () {
        //       setState(() {
        //         hasFile = false;
        //       });
        //     },
        //     child: Container(
        //       alignment: Alignment.center,
        //       padding: const EdgeInsets.all(8),
        //       decoration: BoxDecoration(
        //         color: Colors.transparent,
        //         shape: BoxShape.circle,
        //         border: Border.all(
        //           color: Colors.red.shade900,
        //           width: 1,
        //         ),
        //       ),
        //       child: Icon(
        //         Icons.delete_outline_rounded,
        //         color: Colors.red.shade900,
        //       ),
        //     ),
        //   )
        const Divider(),
        subTitleText("Choisissez votre promotion :"),
        PromoChoice(courses: promo),
        const Divider(),
        subTitleText("Choisissez le nom du cours :"),
        CoursesChoice(courses: courses1, selectionOff: false),
        CoursesChoice(courses: courses2, selectionOff: true),
        CoursesChoice(courses: courses3, selectionOff: true),
        const Divider(),
        subTitleText("Choisissez la langue dans laquelle vous répondre :"),
        LanguageChoice(courses: langues),
        const Divider(),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              GestureDetector(
                onTap: () async {
                  if (!isStreaming &&
                      promoIndex.value != null &&
                      courseIndex.value != null &&
                      langueIndex.value != null &&
                      (photoFile != null || photoFileB != null)) {
                    try {
                      await geminiChat(
                        nomUtilisateur: "Georges Byona",
                        promo: promo[promoIndex.value],
                        cours: courses1[courseIndex.value],
                        langue: langues[langueIndex.value],
                        img: photoFile,
                        imgB: photoFileB,
                      );
                      photoFile = null;
                      photoUrl = null;
                      hasFile = false;
                      setState(() {
                        controller.animateTo(
                          controller.position.extentTotal,
                          duration: const Duration(milliseconds: 1500),
                          curve: Curves.easeInOut,
                        );
                      });
                    } catch (e) {
                      debugPrint('GenAIError : $e');
                    }
                  }
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 30,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(25),
                    border: Border.all(
                      color: Colors.black,
                      width: 1,
                    ),
                  ),
                  child: isStreaming
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            color: Colors.black,
                            strokeWidth: 2,
                          ),
                        )
                      : const Icon(CupertinoIcons.paperplane),
                ),
              ),
            ],
          ),
        ),
        if (geminiResponse != null) ...{
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 50),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 25,
                      height: 25,
                      margin: const EdgeInsets.only(right: 10),
                      child: Image.asset("images/logo.png"),
                    ),
                    Text(
                      "Gemini :",
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Text(
                  "$geminiResponse",
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.normal,
                    color: Colors.black,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 50),
              ],
            ),
          ),
        },
      ],
    );
  }

  Padding subTitleText(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 50),
      child: Text(
        title,
        style: GoogleFonts.poppins(
          fontWeight: FontWeight.w500,
          color: Colors.black,
          fontSize: 15,
        ),
      ),
    );
  }

  void pickImageFromGallery() async {
    photoFile = null;
    photoUrl = null;
    hasFile = false;

    try {
      final filePicker = FilePicker.platform;
      FilePickerResult? result = await filePicker.pickFiles(
        type: FileType.image,
      );
      if (result != null && result.files.isNotEmpty) {
        if (isWeb) {
          final fileBytes = result.files.first.bytes;
          String base64EncodedData = base64Encode(fileBytes!);
          String dataUrl = 'data:image/png;base64,$base64EncodedData';
          photoFileB = fileBytes;
          photoUrl = dataUrl;
        } else {
          final file = File(result.files.single.path!);
          photoFile = file;
        }
        setState(() {
          hasFile = true;
        });
      }
    } catch (e) {
      debugPrint('Erreur de picker : $e');
    }
  }

  final apiKey = '';

  Future<void> geminiChat({
    String? nomUtilisateur,
    promo,
    cours,
    langue,
    File? img,
    Uint8List? imgB,
  }) async {
    setState(() {
      geminiResponse = null;
      isStreaming = !isStreaming;
    });
    final model = GenerativeModel(
      model: 'gemini-1.5-pro',
      apiKey: apiKey,
      safetySettings: [
        SafetySetting(HarmCategory.harassment, HarmBlockThreshold.low),
        SafetySetting(HarmCategory.hateSpeech, HarmBlockThreshold.low),
        SafetySetting(HarmCategory.sexuallyExplicit, HarmBlockThreshold.high),
        SafetySetting(HarmCategory.dangerousContent, HarmBlockThreshold.medium),
      ],
    );

    final imgBytes = imgB ?? await (img!.readAsBytes());
    final response = await model.generateContent(
      [
        Content.multi([
          TextPart(
            '''
              Résout ce questionnaire de $cours envoyé en image.
              La résolution doit être une suivant les numérotations sur l'image
              et dans la langue $langue et non la langue du questionnaire.
              Pour les questions de programmations (Java, Python, JavaScript, C, C++,...)
              n'implémente pas la réponse dans ces langages, tu ne donnes que des indications
              pour l'aider à démarrer ou à débloquer une partie de la question et une explication
              sur des concepts du langage utilisé dans le questionnaire
              (par exemple, comment fonctionnent les boucles en Java).

              Je suis $nomUtilisateur de $promo.

              Envoyez quelques liens de documentations d'où t'as tiré ta résolution.
              ''',
          ),
          DataPart('image/jpeg', imgBytes)
        ])
      ],
    );
    setState(() {
      geminiResponse = response.text;
      isStreaming = !isStreaming;
    });
  }
}
