import 'package:flutter/material.dart';

import '../home/chat/model/chat_model.dart';

class MyListNotifier extends ValueNotifier<List<ChatModel>> {
  MyListNotifier() : super([]);

  void addItem(ChatModel item) {
    value = [...value, item]; // Add the item to the list
    notifyListeners(); // Notify listeners of the change
  }
}

ValueNotifier promoIndex = ValueNotifier(null);
ValueNotifier courseIndex = ValueNotifier(null);
ValueNotifier langueIndex = ValueNotifier(null);
