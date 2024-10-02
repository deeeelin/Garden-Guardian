// import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Message {
  final String role;
  final String text;
  final String? base64ImageUrl;
  final String? imageDescription;
  final DateTime? timeStamp;
  final String? stringtoEmbed; 

  Message(
      {required this.role,
      required this.text,
      this.base64ImageUrl,
      this.imageDescription,
      this.timeStamp,
      this.stringtoEmbed});

  Map<String, dynamic> get contentMessage {
    List<Map<String, dynamic>> contentList = [];

    if (text.isNotEmpty) {
      contentList.add({"type": "text", "text": text});
    }
    if (base64ImageUrl != null) {
      contentList.add({
        "type": "image_url",
        "image_url": {"url": "$base64ImageUrl"}
      });
    }

    return {"role": role, "content": contentList}; // need modify
  }

  Map<String, dynamic> get content{
    if (text.isNotEmpty) {
      return {"type": "text", "text": text};
    }
    if (base64ImageUrl != null) {
     return {
        "type": "image_url",
        "image_url": {"url": "$base64ImageUrl"}
      };
    }
    return {"type": "text", "text": "<ignore this text>"} ; 

  }



  factory Message.fromMap(Map<String, dynamic> map) {
    // Map<String,String> numtoRole = { "0" : "system" , "1": "assistant",  "2" : "user" } ;
    try {
    return Message(
      role: map['role'],
      text: map['text'],
      base64ImageUrl:
          map['base64ImageUrl'] == '' ? null : map['base64ImageUrl'],
      imageDescription:
          map['imageDescription'] == '' ? null : map['imageDescription'],
      timeStamp: map['timeStamp'] == null
          ? null
          :DateTime.parse((map['timeStamp'] as Timestamp).toDate().toString()),
    );
    }catch(e){
      debugPrint("error in Message.fromMap $e") ; 
      return Message(
      role: map['role'],
      text: map['text'],
      base64ImageUrl:
          map['base64ImageUrl'] == '' ? null : map['base64ImageUrl'],
      imageDescription:
          map['imageDescription'] == '' ? null : map['imageDescription'],
      timeStamp: map['timeStamp'] == null
          ? null
          :DateTime.parse((map['timeStamp'] as Timestamp).toDate().toString()),
    );
    }
  }

  Map<String, dynamic> toMap() {
    // Map<String, String> roletoNum = {
    //   "system": "1",
    //   "assistant": "0",
    //   "user": "0"
    // };
    try{
    return {
      'role': role,
      'text': text,
      'base64ImageUrl': base64ImageUrl ?? '',
      'imageDescription': imageDescription ?? '',
      'timeStamp': FieldValue.serverTimestamp(),
      'stringtoEmbed': (stringtoEmbed ?? (text + (imageDescription ?? '')) )  + timeStamp.toString(),
      // 'issystem': roletoNum[role]
    };
    }catch(e){
      debugPrint("error in Message.toMap $e") ; 
      return {
      'role': role,
      'text': text,
      'base64ImageUrl': base64ImageUrl ?? '',
      'imageDescription': imageDescription ?? '',
      'timeStamp': FieldValue.serverTimestamp(),
      'stringtoEmbed': (stringtoEmbed ?? (text + (imageDescription ?? '')) )  + timeStamp.toString(),
      // 'issystem': roletoNum[role]
    }; 
    }
  }

  // @override
  // bool operator ==(Object other) =>
  //     identical(this, other) ||
  //     other is Message && runtimeType == other.runtimeType && userName == other.userName;

  // @override
  // int get hashCode => userName.hashCode;
}
