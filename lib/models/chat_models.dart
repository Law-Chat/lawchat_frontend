enum ChatRole { user, assistant }

class ChatMessage {
  final ChatRole role;
  final String text;
  final DateTime time;

  ChatMessage({required this.role, required this.text, required this.time});
}

class ChatThread {
  final String id;
  final String title;
  final List<ChatMessage> messages;

  ChatThread({required this.id, required this.title, required this.messages});

  factory ChatThread.mock(String title) {
    return ChatThread(
      id: title.hashCode.toString(),
      title: title,
      messages: [
        ChatMessage(
          role: ChatRole.user,
          text: title,
          time: DateTime.now().subtract(const Duration(minutes: 5)),
        ),
        ChatMessage(
          role: ChatRole.assistant,
          text:
              '현재 「금융소비자보호법 제19조」 및 「대부업법 시행령 제8조」에 따라 '
              '최고 이자율은 연 20%를 초과할 수 없습니다. 이는 금융위원회 고시로 정해진 법정 최고금리입니다.\n\n'
              '▪️ 법적 근거: 금융소비자보호법 제19조, 대부업법 시행령 제8조\n'
              '▪️ 최고 이자율: 연 20% 이하\n'
              '▪️ 초과 시: 초과 이자는 무효, 반환 청구 가능',
          time: DateTime.now().subtract(const Duration(minutes: 4)),
        ),
      ],
    );
  }
}
