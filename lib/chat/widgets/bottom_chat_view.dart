import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:file_picker/file_picker.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

import '../model/chat_model.dart';
import '../../notifier.dart';

class BottomChatView extends StatefulWidget {
  final MyListNotifier chatList;
  const BottomChatView({super.key, required this.chatList});

  @override
  State<BottomChatView> createState() => _BottomChatViewState();
}

TextEditingController controller = TextEditingController();

class _BottomChatViewState extends State<BottomChatView> {
  bool isStreaming = false;
  bool hasFile = false;
  bool isWeb = kIsWeb;
  dynamic chatFile, fileUrl;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    return Padding(
      padding: const EdgeInsets.only(
        top: 10,
        left: 20,
        right: 20,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (hasFile)
            Container(
              alignment: Alignment.centerLeft,
              color: Colors.white,
              width: double.infinity,
              padding: const EdgeInsets.only(top: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    color: Colors.grey.shade300,
                    height: width * 0.4,
                    child:
                        isWeb ? Image.network(fileUrl) : Image.file(chatFile),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        hasFile = false;
                      });
                      chatFile = null;
                      fileUrl = null;
                    },
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      child: const Icon(Icons.close_rounded, size: 30),
                    ),
                  ),
                ],
              ),
            ),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 10),
            color: Colors.white,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: pickImageFromGallery,
                  child: Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.black,
                        width: 1,
                      ),
                    ),
                    child: const Icon(CupertinoIcons.add),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: TextField(
                      autocorrect: true,
                      controller: controller,
                      cursorColor: Colors.black,
                      cursorRadius: const Radius.circular(25),
                      enableSuggestions: true,
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                        fontSize: 15,
                      ),
                      maxLines: null,
                      onTapOutside: (event) {
                        FocusScope.of(context).requestFocus(
                          FocusNode(),
                        );
                      },
                      clipBehavior: Clip.none,
                      decoration: InputDecoration(
                        hintText: 'Tapez votre question...',
                        hintStyle: GoogleFonts.poppins(
                          fontWeight: FontWeight.normal,
                          color: Colors.grey.shade700,
                          fontSize: 15,
                        ),
                        border: const UnderlineInputBorder(
                          borderSide: BorderSide(
                            style: BorderStyle.solid,
                            color: Colors.black,
                            width: 1,
                          ),
                        ),
                        enabledBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(
                            style: BorderStyle.solid,
                            color: Colors.black,
                            width: 1,
                          ),
                        ),
                        focusedBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(
                            style: BorderStyle.solid,
                            color: Colors.black,
                            width: 1,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    if (!isStreaming && controller.text.isNotEmpty) {
                      widget.chatList.addItem(ChatModel(
                        id: 'user',
                        content: controller.text,
                        image: isWeb ? fileUrl : chatFile,
                      ));
                      geminiChat(controller.text);
                      controller.clear();
                      chatFile = null;
                      fileUrl = null;
                      hasFile = false;
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
        ],
      ),
    );
  }

  void pickImageFromGallery() async {
    chatFile = null;
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
          chatFile = fileBytes;
          fileUrl = dataUrl;
        } else {
          final file = File(result.files.single.path!);
          chatFile = file;
        }
        setState(() {
          hasFile = true;
        });
      }
    } catch (e) {
      debugPrint('Erreur de picker : $e');
    }
  }

  final apiKey = 'AIzaSyASVWp96MAw_pUTrPBsqOz5bbwMh7IDqcU';

  void geminiChat(String content, {File? img, Uint8List? imgB}) async {
    setState(() {
      isStreaming = !isStreaming;
    });

    final model = GenerativeModel(
      model: 'gemini-1.5-pro',
      apiKey: apiKey,
      safetySettings: [
        SafetySetting(HarmCategory.harassment, HarmBlockThreshold.high),
        SafetySetting(HarmCategory.hateSpeech, HarmBlockThreshold.high),
        SafetySetting(HarmCategory.sexuallyExplicit, HarmBlockThreshold.high),
        SafetySetting(HarmCategory.dangerousContent, HarmBlockThreshold.medium),
      ],
    );
    GenerateContentResponse response;
    final prompt = '''
        Tu es GemiStud, un ChatBot entraîné pour aider les étudiants de la
        République Démocratique du Congo dans la résolution des anciens questionnaires d'examens,
        d'interrogations, des exercices, des travaux pratiques, ...
        
        Tu es conçu sur l'API de Gemini, quand ils te poseront la question de savoir :
        "Comment t'es créer ou conçu ou inventé" un truc de ce genre dis leur
        simplement que t'es un modèle entraîné sur l'API de Gemini.

        Tu discutes avec Georges Byona, un développeur Flutter.

        Voici ce qu'il t'envoie comme message : $content
        ''';
    if (img != null) {
      final imgBytes = isWeb ? imgB : await (img.readAsBytes());
      response = await model.generateContent(
        [
          Content.multi([TextPart(prompt), DataPart('image/jpeg', imgBytes!)])
        ],
      );
    } else {
      response = await model.generateContent(
        [
          Content.multi([TextPart(prompt)])
        ],
      );
    }
    widget.chatList.addItem(ChatModel(id: 'gemini', content: response.text));
    setState(() {
      isStreaming = !isStreaming;
    });
  }
}
