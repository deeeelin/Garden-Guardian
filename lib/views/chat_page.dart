import 'package:flutter/material.dart';
import 'package:flutter_app/views/message/message_list.dart';
import 'package:flutter_app/views/message/new_message_bar.dart';
import 'package:flutter_app/views/user/user_info.dart';
import 'package:provider/provider.dart';
import 'package:flutter_app/services/navigation.dart';
import 'package:flutter_app/views/chat_inform_page.dart';

class ChatPage extends StatelessWidget {
  const ChatPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.background,
        actions: [
          IconButton(
            onPressed: () {
              // Information button logic
              showDialog(context: context, builder: (BuildContext context){
                  return const ChatInformDialog();
                },); 
            },
            icon: Icon(
              Icons.info_outline_rounded,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          UserInfo(),
          Expanded(
            child: MessageList(),
          ),
          // LeftIcons
          NewMessageBar(),
        ],
      ),
    );
  }
}
