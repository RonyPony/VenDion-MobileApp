class ChatMessage {
  ChatMessage({
    required this.id,
    required this.text,
    required this.sentAt,
    required this.isMine,
  });

  final String id;
  final String text;
  final DateTime sentAt;
  final bool isMine;
}
