import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:file_picker/file_picker.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

import '../model/chat_model.dart';
import '../notifier.dart';

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
  dynamic chatFile;

  @override
  Widget build(BuildContext context) {
    return Column(
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
                  height: 200,
                  child: Image.file(chatFile),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      hasFile = false;
                    });
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
                  child: const Icon(CupertinoIcons.photo),
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
                  if (!isStreaming) {
                    setState(() {
                      isStreaming = !isStreaming;
                    });
                    widget.chatList.addItem(ChatModel(
                      id: 'user',
                      content: controller.text.isEmpty ? null : controller.text,
                      image: chatFile,
                    ));
                    geminiChat(controller.text);
                    controller.clear();
                    chatFile = null;
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
    );
  }

  void pickImageFromGallery() async {
    chatFile = null;
    hasFile = false;
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.image,
      );
      if (result != null) {
        final file = File(result.files.single.path!);
        chatFile = file;
        setState(() {
          hasFile = true;
        });
      }
    } catch (e) {
      debugPrint('Erreur de picker : $e');
    }
  }

  final apiKey = 'AIzaSyASVWp96MAw_pUTrPBsqOz5bbwMh7IDqcU';

  void geminiChat(String prompt, {File? img}) async {
    final model = GenerativeModel(
      model: 'gemini-pro',
      apiKey: apiKey,
      // safetySettings: [
      //   SafetySetting(HarmCategory.harassment, HarmBlockThreshold.high),
      //   SafetySetting(HarmCategory.hateSpeech, HarmBlockThreshold.high),
      //   SafetySetting(HarmCategory.sexuallyExplicit, HarmBlockThreshold.high),
      // ],
    );
    GenerateContentResponse response;
    if (img != null) {
      final imgBytes = await (img.readAsBytes());
      response = await model.generateContent(
        [
          Content.multi([TextPart(prompt), DataPart('image/jpeg', imgBytes)])
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
