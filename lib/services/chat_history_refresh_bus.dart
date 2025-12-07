import 'package:flutter/foundation.dart';

class ChatHistoryRefreshBus {
  ChatHistoryRefreshBus._();
  static final ChatHistoryRefreshBus instance = ChatHistoryRefreshBus._();

  final ValueNotifier<int> _version = ValueNotifier<int>(0);

  ValueNotifier<int> get notifier => _version;

  void refresh() {
    _version.value++;
  }
}
