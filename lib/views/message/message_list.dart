import 'package:flutter/material.dart';
import 'package:flutter_app/view_models/all_messages_vm.dart';
import 'package:flutter_app/models/msgUser.dart';
import 'package:flutter_app/views/message/message_bubble.dart';
import 'package:provider/provider.dart';

class MessageList extends StatefulWidget {
  const MessageList({super.key});
  @override
  State<MessageList> createState() => _MessageListState();
}

class _MessageListState extends State<MessageList> {
  final ScrollController _scrollController = ScrollController();
  @override
  void initState() {
    super.initState();
    // Scroll to bottom whenever a new message is added
    _scrollController.addListener(() {
      if (_scrollController.position.atEdge) {
        if (_scrollController.position.pixels != 0) {
          // At the bottom
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _scrollController
                .jumpTo(_scrollController.position.maxScrollExtent);
          });
        }
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  String? meORnotme(String? role) {
    if (role == null) return null;
    if (role == "assistant" || role == "system")
      return "Blossom";
    else {
      return "ME";
    }
  }

  @override
  Widget build(BuildContext context) {
    final allMessagesViewModel = Provider.of<AllMessagesViewModel>(context);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (allMessagesViewModel.messages.isNotEmpty) {
        _scrollToBottom();
      }
    });

    final me = msgUser("ME");
    final messages = allMessagesViewModel.messages;

    if (messages.isEmpty) {
      return const Center(
        child: Text('No messages.'),
      );
    }

    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.only(
        top: 16,
        bottom: 16,
        left: 8,
        right: 8,
      ),
      reverse: false,
      itemCount: messages.length,
      itemBuilder: (ctx, index) {
        final message = messages[index];
        final nextMessage =
            index + 1 < messages.length ? messages[index + 1] : null;
        final prevMessage = index - 1 >= 0 ? messages[index - 1] : null;

        final messageUsername = meORnotme(message.role);
        final nextMessageUsername = meORnotme(nextMessage?.role);
        final isNextUserSame = nextMessageUsername == messageUsername;
        final preMessageUserId = meORnotme(prevMessage?.role);
        final isPreUserSame = preMessageUserId == messageUsername;
        final base64ImageUrl = message.base64ImageUrl;

        if (isNextUserSame) {
          return MessageBubble(
            key: ValueKey(message.timeStamp),
            text: message.text,
            isMine: me.userName == messageUsername,
            isLast: !isPreUserSame,
            base64ImageUrl: base64ImageUrl,
          );
        } else {
          return MessageBubble.withUser(
            key: ValueKey(message.timeStamp),
            userName: meORnotme(message.role),
            text: message.text,
            isMine: me.userName == messageUsername,
            isLast: !isPreUserSame,
            base64ImageUrl: base64ImageUrl,
          );
        }
      },
      addAutomaticKeepAlives: true,
    );
  }
}
