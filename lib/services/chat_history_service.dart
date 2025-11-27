import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

import '../models/chat_history_models.dart';
import 'auth_service.dart';
import 'api_error_handler.dart';

class ChatHistoryService {
  ChatHistoryService._internal();
  static final ChatHistoryService instance = ChatHistoryService._internal();

  String get _baseUrl => dotenv.env['BASE_URL'] ?? '';

  String _formatDate(DateTime d) {
    final y = d.year.toString().padLeft(4, '0');
    final m = d.month.toString().padLeft(2, '0');
    final day = d.day.toString().padLeft(2, '0');
    return '$y-$m-$day';
  }

  Future<List<HistoryEntry>> getHistories({
    DateTime? startDate,
    DateTime? endDate,
    String? keyword,
  }) async {
    final token = await AuthService.instance.getToken();

    if (token == null || token.isEmpty) {
      throw Exception('로그인 정보가 없습니다. 다시 로그인 해주세요.');
    }

    final query = <String, String>{};
    if (startDate != null) {
      query['startDate'] = _formatDate(startDate);
    }
    if (endDate != null) {
      query['endDate'] = _formatDate(endDate);
    }
    if (keyword != null && keyword.isNotEmpty) {
      query['keyword'] = keyword;
    }

    final uri = Uri.parse(
      '$_baseUrl/api/chat/histories',
    ).replace(queryParameters: query.isEmpty ? null : query);

    print(">>> GET: $uri");

    final res = await http.get(
      uri,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    print(">>> STATUS: ${res.statusCode}");
    print(">>> BODY: ${res.body}");

    await handleAuthError(res.statusCode);

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

    await handleAuthError(res.statusCode);

    if (res.statusCode != 200 && res.statusCode != 204) {
      throw Exception('채팅 삭제 실패 (${res.statusCode})');
    }
  }
}
