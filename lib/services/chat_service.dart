import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

import '../models/chat_models.dart';
import 'auth_service.dart';
import 'api_error_handler.dart';

class ChatService {
  ChatService._internal();
  static final ChatService instance = ChatService._internal();

  String get _baseUrl => dotenv.env['BASE_URL'] ?? '';

  Future<String> _getToken() async {
    final token = await AuthService.instance.getToken();
    if (token == null || token.isEmpty) {
      throw Exception('로그인이 필요합니다.');
    }
    return token;
  }

  Future<ChatThread> _postChat({
    required Uri uri,
    required String message,
  }) async {
    final token = await _getToken();

    print('>>> POST → $uri');
    print('>>> message: $message');

    final res = await http.post(
      uri,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'message': message}),
    );

    print('>>> STATUS: ${res.statusCode}');
    print('>>> BODY: ${res.body}');

    await handleAuthError(res.statusCode);

    if (res.statusCode != 200) {
      throw Exception('채팅 요청 실패 (${res.statusCode})');
    }

    final decoded = jsonDecode(res.body);
    if (decoded is! Map<String, dynamic>) {
      print('>>> 예기치 않은 응답 형식(POST): ${res.body}');
      throw Exception('예상치 못한 응답 형식입니다.');
    }

    return ChatThread.fromJson(decoded);
  }

  Future<ChatThread> startChat(String message) async {
    final uri = Uri.parse('$_baseUrl/api/chat');
    return _postChat(uri: uri, message: message);
  }

  Future<ChatThread> sendMessage({
    required int chatId,
    required String message,
  }) async {
    final uri = Uri.parse('$_baseUrl/api/chat/$chatId');
    return _postChat(uri: uri, message: message);
  }

  Future<ChatThread> getChatDetail(int chatId) async {
    final token = await _getToken();
    final uri = Uri.parse('$_baseUrl/api/chat/$chatId');

    print('>>> GET 상세조회 → $uri');

    final res = await http.get(
      uri,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    print('>>> STATUS: ${res.statusCode}');
    print('>>> BODY: ${res.body}');

    await handleAuthError(res.statusCode);

    if (res.statusCode != 200) {
      throw Exception('채팅 상세 조회 실패 (${res.statusCode})');
    }

    final decoded = jsonDecode(res.body);
    if (decoded is! Map<String, dynamic>) {
      print('>>> 예기치 않은 응답 형식(GET): ${res.body}');
      throw Exception('예상치 못한 응답 형식입니다.');
    }

    return ChatThread.fromJson(decoded);
  }
}
