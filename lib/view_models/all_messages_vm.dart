import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/models/message.dart';
import 'package:flutter_app/repositories/message_repo.dart';
import 'package:flutter_app/services/chat_bot_service.dart';

class AllMessagesViewModel with ChangeNotifier {
  final ChatBot chatService;
  final MessageRepository _messageRepository;
  StreamSubscription<List<Message>>? _messagesSubscription;

  List<Message> _messages = [];
  List<Message> get messages => _messages;
  bool _isInitializing = true;
  bool get isInitializing => _isInitializing;

  AllMessagesViewModel(
      {required this.chatService, MessageRepository? messageRepository})
      : _messageRepository = messageRepository ?? MessageRepository() {
    try {
      debugPrint('AM initializing');
      _messagesSubscription = _messageRepository.streamViewMessages().listen(
        (messages) {
          _isInitializing = false;
          _messages = messages;
          notifyListeners();
        },
        onError: (error) {
          debugPrint("Stream error: $error");
          // Handle stream error appropriately
        },
      );
      debugPrint('AM initialize complete');
    } catch (e, stackTrace) {
      debugPrint("Initialization error: $e");
      debugPrint("Stack trace: $stackTrace");
    }
  }

  @override
  void dispose() {
    _messagesSubscription?.cancel();
    super.dispose();
  }

  Future<String> addMessage(Message newMessage) async {
    if (_messages.isNotEmpty) {
      // _messsage empty then welcome user
      _messages.add(newMessage);
      notifyListeners();
    }
    final response = await chatService.doResponse(newMessage);
    return response;
  }

  // String _handleResponse(Message message, String? response) {
  //   return response ?? '';
  // }

  // Future<void> deleteMessage(String messageId) async {
  //   await _messageRepository.deleteMessage(messageId);
  // }
}
