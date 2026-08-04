import 'package:flutter/material.dart';
import 'package:vendion/models/conversation.dart';
import 'package:vendion/models/vehicles.dart';
import 'package:vendion/services/mock_messages_service.dart';

class MessagesProvider extends ChangeNotifier {
  MessagesProvider(this._service);

  final MockMessagesService _service;

  List<Conversation> _conversations = [];
  bool _loading = false;
  String? _error;

  List<Conversation> get conversations => _conversations;
  bool get loading => _loading;
  String? get error => _error;
  int get unreadConversationCount => _conversations
      .where((conversation) => conversation.unreadCount > 0)
      .length;

  Future<void> loadConversations() async {
    _loading = true;
    _error = null;
    notifyListeners();

    try {
      _conversations = await _service.getConversations();
    } catch (e) {
      _error = e.toString();
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<Conversation> openForVehicle(Vehicle vehicle) async {
    final conversation =
        await _service.getOrCreateConversationForVehicle(vehicle);
    await loadConversations();
    return conversation;
  }

  Conversation? getConversation(String id) {
    return _service.getById(id);
  }

  void markAsRead(String id) {
    _service.markAsRead(id);
    _refreshFromService();
  }

  void sendMessage(String id, String text) {
    final trimmed = text.trim();
    if (trimmed.isEmpty) {
      return;
    }

    _service.addMessage(id, trimmed);
    _refreshFromService();
  }

  void _refreshFromService() {
    _conversations = List<Conversation>.from(_conversations)
      ..sort((a, b) {
        final aDate =
            a.lastMessage?.sentAt ?? DateTime.fromMillisecondsSinceEpoch(0);
        final bDate =
            b.lastMessage?.sentAt ?? DateTime.fromMillisecondsSinceEpoch(0);
        return bDate.compareTo(aDate);
      });
    notifyListeners();
  }
}
