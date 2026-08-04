import 'package:vendion/models/chat_message.dart';
import 'package:vendion/models/conversation.dart';
import 'package:vendion/models/vehicles.dart';

class MockMessagesService {
  final List<Conversation> _conversations = [
    Conversation(
      id: 'conv-1',
      sellerName: 'Carlos Mendez',
      vehicleId: 101,
      vehicleName: 'Honda Civic 2007',
      unreadCount: 2,
      messages: [
        ChatMessage(
          id: 'm1',
          text: 'Hola, el Honda sigue disponible.',
          sentAt: DateTime.now().subtract(const Duration(hours: 3)),
          isMine: false,
        ),
        ChatMessage(
          id: 'm2',
          text: 'Perfecto, quiero verlo esta tarde.',
          sentAt:
              DateTime.now().subtract(const Duration(hours: 2, minutes: 45)),
          isMine: true,
        ),
        ChatMessage(
          id: 'm3',
          text: 'Claro, puedo mostrarlo a las 6:00.',
          sentAt: DateTime.now().subtract(const Duration(minutes: 35)),
          isMine: false,
        ),
      ],
    ),
    Conversation(
      id: 'conv-2',
      sellerName: 'Ana Rodriguez',
      vehicleId: 202,
      vehicleName: 'Toyota Corolla 2018',
      unreadCount: 0,
      messages: [
        ChatMessage(
          id: 'm4',
          text: 'Gracias por la informacion.',
          sentAt: DateTime.now().subtract(const Duration(days: 1, hours: 1)),
          isMine: true,
        ),
        ChatMessage(
          id: 'm5',
          text: 'A la orden.',
          sentAt: DateTime.now().subtract(const Duration(days: 1)),
          isMine: false,
        ),
      ],
    ),
    Conversation(
      id: 'conv-3',
      sellerName: 'Luis Perez',
      vehicleId: 303,
      vehicleName: 'Audi Q7 Sport',
      unreadCount: 1,
      messages: [
        ChatMessage(
          id: 'm6',
          text: 'Puedo negociar un poco el precio.',
          sentAt: DateTime.now().subtract(const Duration(minutes: 12)),
          isMine: false,
        ),
      ],
    ),
  ];

  Future<List<Conversation>> getConversations() async {
    await Future<void>.delayed(const Duration(milliseconds: 350));
    return _sorted();
  }

  Future<Conversation> getOrCreateConversationForVehicle(
      Vehicle vehicle) async {
    await Future<void>.delayed(const Duration(milliseconds: 180));
    Conversation? existing;
    for (final conversation in _conversations) {
      if (conversation.vehicleId == vehicle.id) {
        existing = conversation;
        break;
      }
    }

    if (existing != null) {
      return existing;
    }

    final conversation = Conversation(
      id: 'conv-${DateTime.now().microsecondsSinceEpoch}',
      sellerName: 'Vendedor VenDion',
      vehicleId: vehicle.id,
      vehicleName: vehicle.name ?? 'Vehiculo',
      messages: [
        ChatMessage(
          id: 'msg-${DateTime.now().microsecondsSinceEpoch}',
          text: 'Hola, me interesa este vehiculo.',
          sentAt: DateTime.now(),
          isMine: true,
        ),
      ],
    );
    _conversations.add(conversation);
    return conversation;
  }

  void markAsRead(String conversationId) {
    final conversation = getById(conversationId);
    if (conversation != null) {
      conversation.unreadCount = 0;
    }
  }

  ChatMessage addMessage(String conversationId, String text) {
    final conversation = getById(conversationId);
    if (conversation == null) {
      throw StateError('Conversation not found');
    }

    final message = ChatMessage(
      id: 'msg-${DateTime.now().microsecondsSinceEpoch}',
      text: text,
      sentAt: DateTime.now(),
      isMine: true,
    );
    conversation.messages.add(message);
    return message;
  }

  Conversation? getById(String id) {
    for (final conversation in _conversations) {
      if (conversation.id == id) {
        return conversation;
      }
    }
    return null;
  }

  List<Conversation> _sorted() {
    final list = List<Conversation>.from(_conversations);
    list.sort((a, b) {
      final aDate =
          a.lastMessage?.sentAt ?? DateTime.fromMillisecondsSinceEpoch(0);
      final bDate =
          b.lastMessage?.sentAt ?? DateTime.fromMillisecondsSinceEpoch(0);
      return bDate.compareTo(aDate);
    });
    return list;
  }
}
