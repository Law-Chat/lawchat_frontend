import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

import '../models/chat_models.dart';
import 'auth_service.dart';

class ChatService {
  ChatService._internal();
  static final ChatService instance = ChatService._internal();

  String get _baseUrl => dotenv.env['BASE_URL'] ?? '';

  Future<String> _getToken() async {
    final token = await AuthService.instance.getToken();
    if (token == null || token.isEmpty) {
      throw Exception('로그인 정보가 없습니다. 다시 로그인 해주세요.');
    }
    return token;
  }

  Future<ChatThread> _postChat({
    required Uri uri,
    required String message,
  }) async {
    final token = await _getToken();

    final res = await http.post(
      uri,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'message': message}),
    );

    if (res.statusCode != 200) {
      throw Exception('채팅 요청 실패 (${res.statusCode})');
    }

    final data = jsonDecode(res.body) as Map<String, dynamic>;
    return ChatThread.fromJson(data);
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
}
