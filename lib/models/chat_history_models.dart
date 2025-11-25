class HistoryEntry {
  final int chatId;
  final String summary;
  final DateTime createdAt;

  HistoryEntry({
    required this.chatId,
    required this.summary,
    required this.createdAt,
  });

  factory HistoryEntry.fromJson(Map<String, dynamic> json) {
    return HistoryEntry(
      chatId: json['chatId'] as int,
      summary: json['summary'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }
}
