enum ChatRole { user, assistant }

class RelatedLaw {
  final String name;
  final String content;
  final List<String> keywords;

  RelatedLaw({
    required this.name,
    required this.content,
    required this.keywords,
  });

  factory RelatedLaw.fromJson(Map<String, dynamic> json) {
    return RelatedLaw(
      name: json['name'] as String? ?? '',
      content: json['content'] as String? ?? '',
      keywords:
          (json['keywords'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          const [],
    );
  }
}

class ChatMessage {
  final int messageId;
  final ChatRole role;
  final String text;
  final RelatedLaw? relatedLaw;

  ChatMessage({
    required this.messageId,
    required this.role,
    required this.text,
    this.relatedLaw,
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    final rawId = json['messageId'];
    final intId = rawId is int ? rawId : int.parse(rawId.toString());

    return ChatMessage(
      messageId: intId,
      role: json['type'] == 'USER' ? ChatRole.user : ChatRole.assistant,
      text: json['message'] as String? ?? '',
      relatedLaw: json['relatedLaw'] != null
          ? RelatedLaw.fromJson(json['relatedLaw'] as Map<String, dynamic>)
          : null,
    );
  }
}

class ChatThread {
  final int id;
  final String title;
  final List<ChatMessage> messages;

  ChatThread({required this.id, required this.title, required this.messages});

  factory ChatThread.fromJson(Map<String, dynamic> json) {
    final rawId = json['chatId'];
    final intId = rawId is int ? rawId : int.parse(rawId.toString());

    final messagesJson = json['messages'] as List<dynamic>? ?? const [];

    return ChatThread(
      id: intId,
      title: (json['summary'] ?? '').toString(),
      messages: messagesJson
          .map((e) => ChatMessage.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}
