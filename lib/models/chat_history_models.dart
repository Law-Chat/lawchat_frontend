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
      chatId: json['chatId'] is int
          ? json['chatId'] as int
          : int.parse(json['chatId'].toString()),
      summary: json['summary']?.toString() ?? '',
      createdAt: DateTime.parse(json['createdAt'].toString()),
    );
  }
}
