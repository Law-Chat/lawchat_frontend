import 'auth_service.dart';

Future<void> handleAuthError(int statusCode) async {
  if (statusCode == 401) {
    await AuthService.instance.clearToken();

    throw Exception('세션이 만료되었습니다. 다시 로그인해주세요.');
  }
}
