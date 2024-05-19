class ChatModel {
  String id;
  String? content;
  dynamic image;
  ChatModel({
    required this.id,
    required this.content,
    this.image,
  });
}
