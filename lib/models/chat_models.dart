enum ChatRole { user, assistant }

class ChatMessage {
  final ChatRole role;
  final String text;
  final String? relatedLaw;

  ChatMessage({required this.role, required this.text, this.relatedLaw});

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      role: json['type'] == 'USER' ? ChatRole.user : ChatRole.assistant,
      text: json['message'] ?? '',
      relatedLaw: json['relatedLaw'],
    );
  }
}

class ChatThread {
  final String id;
  final String title;
  final List<ChatMessage> messages;

  ChatThread({required this.id, required this.title, required this.messages});

  factory ChatThread.fromJson(Map<String, dynamic> json) {
    final list = json['messages'] as List<dynamic>? ?? [];

    return ChatThread(
      id: json['chatId'].toString(),
      title: '',
      messages: list
          .map((e) => ChatMessage.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}
