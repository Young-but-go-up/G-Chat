import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../notifier.dart';

class ChatView extends StatelessWidget {
  const ChatView({
    super.key,
    required this.chatList,
    required this.controller,
  });

  final MyListNotifier chatList;
  final ScrollController controller;

  @override
  Widget build(BuildContext context) {
    bool isWeb = kIsWeb;
    return ListView.builder(
      controller: controller,
      padding: const EdgeInsets.only(
        top: 10,
        left: 20,
        right: 20,
      ),
      scrollDirection: Axis.vertical,
      itemCount: chatList.value.length,
      physics: const AlwaysScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        final chatlist = chatList.value;
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
                      child: isWeb
                          ? Image.network(chatlist[index].image)
                          : Image.file(chatlist[index].image),
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

  // Fonction pour formater le texte
  String formatText(text) {
    // Utiliser des expressions régulières (regex) pour trouver les éléments à styliser
    // Remplace les éléments trouvés avec des widgets stylisés.

    // Exemple : Trouver et styliser les liens
    text = text.replaceAllMapped(RegExp(r'https?:\/\/[^\s]+'), (match) {
      return TextSpan(
        text: match.group(0),
        style: const TextStyle(
          color: Colors.blue,
          decoration: TextDecoration.underline,
        ),
        recognizer: match()
          ..onTap = () {
            // Action à effectuer lors du clic sur le lien
            // Par exemple, ouvrir le lien dans le navigateur
          },
      );
    });

    // Exemple : Trouver et styliser les numéros de téléphone
    text = text.replaceAllMapped(RegExp(r'\+?[0-9]{10,15}'), (match) {
      return TextSpan(
        text: match.group(0),
        style: const TextStyle(
          color: Colors.green,
          fontWeight: FontWeight.bold,
        ),
      );
    });

    // Ajouter d'autres regex et stylisations pour d'autres éléments.
    return text;
  }
}

// Code: (?<=\)(.*?)(?=`)(cherche du texte entre des backticks)
// Date: ([0-9]{1,2}/[0-9]{1,2}/[0-9]{4})
// Heure: ([0-9]{1,2}:[0-9]{2}(:[0-9]{2})?)
// Numéro de téléphone: \+?[0-9]{10,15}
// Lien: https?:\/\/[^\s]+
