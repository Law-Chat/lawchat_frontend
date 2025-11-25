import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

import '../models/chat_history_models.dart';
import 'auth_service.dart';

class ChatHistoryService {
  ChatHistoryService._internal();
  static final ChatHistoryService instance = ChatHistoryService._internal();

  String get _baseUrl => dotenv.env['BASE_URL'] ?? '';

  Future<List<HistoryEntry>> getHistories() async {
    final token = await AuthService.instance.getToken();

    if (token == null || token.isEmpty) {
      throw Exception('로그인 정보가 없습니다. 다시 로그인 해주세요.');
    }

    // TODO: 검색어 + 기간 필터 파라미터 수정
    final uri = Uri.parse('$_baseUrl/api/chat/histories');

    final res = await http.get(
      uri,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (res.statusCode != 200) {
      throw Exception('히스토리 조회 실패 (${res.statusCode})');
    }

    final body = jsonDecode(res.body) as Map<String, dynamic>;
    final list = body['chatHistories'] as List<dynamic>? ?? [];

    return list
        .map((e) => HistoryEntry.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<void> deleteHistory(int chatId) async {
    final token = await AuthService.instance.getToken();

    if (token == null || token.isEmpty) {
      throw Exception('로그인 정보가 없습니다. 다시 로그인 해주세요.');
    }

    final uri = Uri.parse('$_baseUrl/api/chat/$chatId');

    final res = await http.delete(
      uri,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (res.statusCode != 200) {
      throw Exception('채팅 삭제 실패 (${res.statusCode})');
    }
  }
}
