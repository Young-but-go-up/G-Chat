import 'package:flutter/material.dart';

import 'model/chat_model.dart';

class MyListNotifier extends ValueNotifier<List<ChatModel>> {
  MyListNotifier() : super([]);

  void addItem(ChatModel item) {
    value = [...value, item]; // Add the item to the list
    notifyListeners(); // Notify listeners of the change
  }
}
