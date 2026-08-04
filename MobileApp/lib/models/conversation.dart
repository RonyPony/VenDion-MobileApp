import 'package:vendion/models/chat_message.dart';

class Conversation {
  Conversation({
    required this.id,
    required this.sellerName,
    required this.vehicleId,
    required this.vehicleName,
    required this.messages,
    this.avatarUrl,
    this.unreadCount = 0,
  });

  final String id;
  final String sellerName;
  final int? vehicleId;
  final String vehicleName;
  final String? avatarUrl;
  final List<ChatMessage> messages;
  int unreadCount;

  ChatMessage? get lastMessage => messages.isEmpty ? null : messages.last;
}
