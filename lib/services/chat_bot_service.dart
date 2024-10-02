import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_app/models/message.dart';
import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';
import 'package:flutter_app/repositories/message_repo.dart';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:mime/mime.dart';

import 'package:intl/intl.dart'; // For date formatting
import 'package:flutter_app/services/tool.dart';
import 'package:flutter_app/services/image_handler.dart';
import 'package:flutter_app/services/prompt.dart';
// import 'package:flutter_app/view_models/all_messages_vm.dart';
import 'package:flutter_app/repositories/plant_repo.dart';
import 'package:flutter_app/repositories/appUser_repo.dart';
import 'package:flutter_app/repositories/growth_log_repo.dart';

class ChatBot extends ChangeNotifier {
  final MessageRepository _messageRepository;
  final PlantRepository _plantRepository = PlantRepository();
  final GrowthLogRepository _growthLogRepository = GrowthLogRepository();
  final ImageHandler imageHandler = ImageHandler();
  StreamSubscription<List<Message>>? _messagesSubscription;
  List<Message> windowMessages = [];
  bool _isInitializing = true;
  bool get isInitializing => _isInitializing;

  late OpenAI openAI;
  late ThreadRequest threadRequest;
  late ThreadResponse threadCreate;

  String kToken = ChatBotPrompts().kToken;
  String systemPrompt = ChatBotPrompts().systemPrompt;
  String imagesystemPrompt = ChatBotPrompts().imagesystemPrompt;
  String keywordsystemPrompt = ChatBotPrompts().keywordsystemPrompt;
  String imageDescriptionPrompt = ChatBotPrompts().imageDescriptionPrompt;
  final tools = ChatBotPrompts().tools;

  // int _calculateTokenCount(String? content) {
  //   if (content == null) return 0;
  //   return content.length ~/ 4;
  // }

  // final _maxToken = 100;

  ChatBot({MessageRepository? messageRepository})
      : _messageRepository = messageRepository ?? MessageRepository() {
    try {
      debugPrint('CB initializing');
      _messagesSubscription = _messageRepository.streamContentMessages().listen(
        (messages) {
          _isInitializing = false;
          windowMessages = messages;
          notifyListeners();
        },
        onError: (error) {
          debugPrint("Stream error: $error");
        },
      );
      debugPrint('CB initialize complete');
    } catch (e, stackTrace) {
      debugPrint("Initialization error: $e");
      debugPrint("Stack trace: $stackTrace");
    }

    openAI = OpenAI.instance.build(
      token: kToken,
      baseOption: HttpSetup(
        receiveTimeout: const Duration(seconds: 20),
        connectTimeout: const Duration(seconds: 20),
      ),
      enableLog: true,
    );
    threadRequest = ThreadRequest();
  }

  @override
  void dispose() {
    _messagesSubscription?.cancel();
    super.dispose();
  }

  Future<String> doResponse(Message userInp) async {
    try {
      debugPrint('Generating response for user input');
      final responseText = await _chatCompletion(userInp);
      return responseText ?? 'Error';
    } catch (e) {
      debugPrint('Error in doResponse: $e');
      return 'Error';
    }
  }

  Future<String?> _chatCompletion(Message message) async {
    try {
      dynamic contentMessage;
      //   bool isImage = false;
      var CCrequestImage;
      var CCrequestMessageKeyword;
      var CCrequestDescribeImage;
      String? base64Image;

//################Process user input message###########################
      if (message.base64ImageUrl != null) {
        base64Image =
            await imageHandler.convertImageToBase64(message.base64ImageUrl!);
        //  isImage = true;

        contentMessage = [
          {"type": "text", "text": message.text},
          {
            "type": "image_url",
            "image_url": {"url": base64Image}
          }
        ];

        // handle the another model of image description

        final imageMessage = [
          {
            "role": "user",
            "content": [contentMessage[1]]
          }
        ];
        List<Map<String, dynamic>> sysMessages = [
          {"role": "system", "content": imagesystemPrompt}
        ];
        List<Map<String, dynamic>> sysMessages4describe = [
          {"role": "system", "content": imageDescriptionPrompt}
        ];
        // debugPrint('Image Message: ${sysMessages + imageMessage}');

        CCrequestImage = ChatCompleteText(
            messages: sysMessages + imageMessage,
            maxToken: 200,
            model: ChatModelFromValue(model: 'gpt-4o'),
            temperature: 0
            //     tools: tools,
            //     toolChoice: "auto"
            );
        CCrequestDescribeImage = ChatCompleteText(
            messages: sysMessages4describe + imageMessage,
            maxToken: 200,
            model: ChatModelFromValue(model: 'gpt-4o'),
            temperature: 0
            //     tools: tools,
            //     toolChoice: "auto"
            );
      } else {
        contentMessage = [
          {"type": "text", "text": message.text}
        ];
      }

      // handle the another model of image description

      final keywordMessage = [
        {"role": "user", "content": contentMessage}
      ];
      List<Map<String, dynamic>> sysMessages = [
        {"role": "system", "content": keywordsystemPrompt}
      ];
      // debugPrint('Image Message: ${sysMessages + imageMessage}');

      CCrequestMessageKeyword = ChatCompleteText(
          messages: sysMessages + keywordMessage,
          maxToken: 50,
          model: ChatModelFromValue(model: 'gpt-4o'),
          temperature: 0
          //     tools: tools,
          //     toolChoice: "auto"
          );

//################Run chat model  ###########################

      final currentMessage = [
        {"role": "user", "content": contentMessage}
      ];

      List<Map<String, dynamic>> previousMessages = windowMessages
          .map((windowMessage) => windowMessage.contentMessage)
          .toList();
      previousMessages.insert(0, {"role": "system", "content": systemPrompt});

      final iptMsg = previousMessages + currentMessage;

      // debugPrint('Message: $iptMsg');

      final CCrequest = ChatCompleteText(
          messages: iptMsg,
          maxToken: 200,
          model: ChatModelFromValue(model: 'gpt-4o'),
          temperature: 0,
          tools: tools,
          toolChoice: "auto");

      final response = await openAI.onChatCompletion(request: CCrequest);

      final responseMsg = response?.choices[0].message;

      if (responseMsg != null) {
        // debugPrint('responseMsg: ${responseMsg.toJson()}');
        iptMsg.add(responseMsg.toJson());
      }

//################   Handle Tool Call  ###########################

      String finalContent = 'placeholder';
      final toolCalls = responseMsg?.toolCalls;
      debugPrint('toolCalls_2: $toolCalls');

      if (toolCalls != null && toolCalls.isNotEmpty) {
        String toolCall_id = toolCalls[0]['id'];
        debugPrint('toolCall_id: $toolCall_id');

        String toolFunctionName = toolCalls[0]['function']['name'];
        debugPrint('toolFunctionName: $toolFunctionName');

        Map<String, dynamic> toolArguments =
            jsonDecode(toolCalls[0]['function']['arguments']);

        if (toolFunctionName == 'add_new_plant') {
          debugPrint('add_new_plant called with arguments: $toolArguments');

          try {
            String species = toolArguments['species'];
            int wateringCycle = toolArguments['wateringCycle'];
            int fertilizationCycle = toolArguments['fertilizationCycle'];
            int pruningCycle = toolArguments['pruningCycle'];

            // if (CCrequestImage != null) {
            final imageResponse =
                await openAI.onChatCompletion(request: CCrequestDescribeImage);
            final imageDesMsg =
                imageResponse?.choices[0].message?.content ?? '';
            debugPrint('Image Des inside add_new_plant: \n$imageDesMsg');
            // }

            final results = await addNewPlant(
                species,
                base64Image ?? '',
                imageDesMsg,
                wateringCycle,
                fertilizationCycle,
                pruningCycle,
                _plantRepository);

            debugPrint('results: $results');

            iptMsg.add({
              "role": "tool",
              "tool_call_id": toolCall_id,
              "name": toolFunctionName,
              "content": results
            });
          } catch (e) {
            debugPrint('Error in addNewPlant: $e');
          }

          final CCrequestWithFunctionResponse = ChatCompleteText(
            messages: iptMsg,
            model: ChatModelFromValue(model: 'gpt-4o'),
            maxToken: 200,
            temperature: 0,
          );

          try {
            String? message;
            List<Message> msgList = windowMessages;
            msgList.add(Message(text: message ?? '', role: "assistant"));
            notifyListeners();

            final finalResponse = await openAI.onChatCompletion(
                request: CCrequestWithFunctionResponse);
            finalContent = finalResponse?.choices[0].message?.content ?? '';
          } catch (e) {
            debugPrint('Error in finalResponse: $e');
          }
        } else if (toolFunctionName == 'store_nickname') {
          debugPrint('store_nickname called with arguments: $toolArguments');

          try {
            String nickname = toolArguments['nickname'];

            final results = await storeNickname(nickname);

            debugPrint('results: $results');

            iptMsg.add({
              "role": "tool",
              "tool_call_id": toolCall_id,
              "name": toolFunctionName,
              "content": results
            });
          } catch (e) {
            debugPrint('Error in storeNickname: $e');
          }

          final CCrequestWithFunctionResponse = ChatCompleteText(
            messages: iptMsg,
            model: ChatModelFromValue(model: 'gpt-4o'),
            maxToken: 200,
            temperature: 0,
          );

          try {
            String? message;
            List<Message> msgList = windowMessages;
            msgList.add(Message(text: message ?? '', role: "assistant"));
            notifyListeners();

            final finalResponse = await openAI.onChatCompletion(
                request: CCrequestWithFunctionResponse);
            finalContent = finalResponse?.choices[0].message?.content ?? '';
          } catch (e) {
            debugPrint('Error in finalResponse: $e');
          }
        } else if (toolFunctionName == 'counting_goal') {
          debugPrint('countingGoal called with arguments: $toolArguments');

          try {
            //! goal test
            String behavior = toolArguments['behavior'];

            String lastCareDate = toolArguments['lastCareDate'];
            int wateringCycle = toolArguments['wateringCycle'];
            int fertilizationCycle = toolArguments['fertilizationCycle'];
            int pruningCycle = toolArguments['pruningCycle'];

            //! [TODO] START DEBUG HERE
            final results = await counting_goal(behavior, lastCareDate,
                wateringCycle, fertilizationCycle, pruningCycle);
            debugPrint('results: $results');

            iptMsg.add({
              "role": "tool",
              "tool_call_id": toolCall_id,
              "name": toolFunctionName,
              "content": results
            });
          } catch (e) {
            debugPrint('Error in calculateNextCareDates: $e');
          }

          final CCrequestWithFunctionResponse = ChatCompleteText(
            messages: iptMsg,
            model: ChatModelFromValue(model: 'gpt-4o'),
            maxToken: 200,
            temperature: 0,
          );

          try {
            String? message;
            List<Message> msgList = windowMessages;
            msgList.add(Message(text: message ?? '', role: "assistant"));
            notifyListeners();

            final finalResponse = await openAI.onChatCompletion(
                request: CCrequestWithFunctionResponse);
            finalContent = finalResponse?.choices[0].message?.content ?? '';
          } catch (e) {
            debugPrint('Error in finalResponse: $e');
          }
        } else if (toolFunctionName == 'add_growth_log') {
          debugPrint('addGrowthLog called with arguments: $toolArguments');

          try {
            String plantNickname = toolArguments['nickname'];
            String text = toolArguments['text'];

            final results = await addGrowthLog(plantNickname, text,
                base64Image ?? '', _plantRepository, _growthLogRepository);

            debugPrint('results: $results');

            iptMsg.add({
              "role": "tool",
              "tool_call_id": toolCall_id,
              "name": toolFunctionName,
              "content": results
            });
          } catch (e) {
            debugPrint('Error in addGrowthLog: $e');
          }

          final CCrequestWithFunctionResponse = ChatCompleteText(
            messages: iptMsg,
            model: ChatModelFromValue(model: 'gpt-4o'),
            maxToken: 200,
            temperature: 0,
          );

          try {
            String? message;
            List<Message> msgList = windowMessages;
            msgList.add(Message(text: message ?? '', role: "assistant"));
            notifyListeners();

            final finalResponse = await openAI.onChatCompletion(
                request: CCrequestWithFunctionResponse);
            finalContent = finalResponse?.choices[0].message?.content ?? '';
          } catch (e) {
            debugPrint('Error in finalResponse: $e');
          }
        } else if (toolFunctionName == 'find_similar_message') {
          debugPrint(
              'find_and_append_similar_message called with arguments: $toolArguments');

          try {
            String query = toolArguments['query'];

            debugPrint('query: $query');
            final results = await findSimilarMessage(query, 5);

            // Iterate through the list of results and add each message to iptMsg

            iptMsg.add({
              "role": "tool",
              "tool_call_id": toolCall_id,
              "name": toolFunctionName,
              "content": results
            });

            final CCrequestWithFunctionResponse = ChatCompleteText(
              messages: iptMsg,
              model: ChatModelFromValue(model: 'gpt-4o'),
              maxToken: 200,
              temperature: 0,
            );
            final finalResponse = await openAI.onChatCompletion(
                request: CCrequestWithFunctionResponse);
            finalContent = finalResponse?.choices[0].message?.content ?? '';
            //   _messageRepository.addMessage(results) ;
          } catch (e) {
            debugPrint('Error in find_and_append_similar_message: $e');
          }
        } else {
          debugPrint("Error: function $toolFunctionName does not exist");
        }
      } else {
        debugPrint("toolCalls is null or empty: ${responseMsg?.content}");
        finalContent = responseMsg?.content as String;
      }

//################  Update Database  ###########################

      final keywordResponse =
          await openAI.onChatCompletion(request: CCrequestMessageKeyword);
      final keywordDesMsg = keywordResponse?.choices[0].message?.content ?? '';
      debugPrint('Keyword Des : $keywordDesMsg');

      if (CCrequestImage != null) {
        final imageResponse =
            await openAI.onChatCompletion(request: CCrequestImage);
        final imageDesMsg = imageResponse?.choices[0].message?.content ?? '';
        debugPrint('Image Des : \n$imageDesMsg');

        await _messageRepository.addMessage(Message(
            role: message.role,
            text: message.text,
            base64ImageUrl: message.base64ImageUrl,
            imageDescription: imageDesMsg,
            stringtoEmbed: keywordDesMsg));
      } else {
        await _messageRepository.addMessage(Message(
            role: message.role,
            text: message.text,
            base64ImageUrl: message.base64ImageUrl,
            stringtoEmbed: keywordDesMsg));
      }
      _messageRepository
          .addMessage(Message(text: finalContent, role: "assistant"));

// Return ChatBot response to user , but we read message content directly from database, so this do nothing
      return finalContent;
    } catch (e) {
      debugPrint('Error in _chatCompletion: $e');
      return null;
    }
  }
}
