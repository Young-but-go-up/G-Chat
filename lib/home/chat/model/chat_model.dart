class ChatModel {
  String id;
  dynamic content;
  dynamic image;
  ChatModel({
    required this.id,
    required this.content,
    this.image,
  });
}
