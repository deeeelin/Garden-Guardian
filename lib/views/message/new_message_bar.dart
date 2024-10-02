import 'package:flutter/material.dart';
import 'package:flutter_app/models/message.dart';
import 'package:flutter_app/view_models/all_messages_vm.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
// import 'package:flutter_app/services/chat_bot_service.dart' ;
import 'package:flutter_app/services/image_handler.dart';

class NewMessageBar extends StatefulWidget {
  const NewMessageBar({super.key});

  @override
  State<NewMessageBar> createState() {
    return _NewMessageBarState();
  }
}

class _NewMessageBarState extends State<NewMessageBar> {
  final _messageController = TextEditingController();
  bool _isSending = false; // State to manage the send button
  File? _pickedImage; // Store the picked image

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      setState(() {
        _pickedImage = File(pickedImage.path);
      });
    }
  }

  void _submitMessage() async {
    final enteredMessage = _messageController.text;

    if (enteredMessage.trim().isEmpty && _pickedImage == null) {
      return;
    }

    FocusScope.of(context).unfocus();
    _messageController.clear();

    final allMessagesViewModel =
        Provider.of<AllMessagesViewModel>(context, listen: false);

    setState(() {
      _isSending = true; // Disable the send button
    });

    await allMessagesViewModel.addMessage(Message(
      role: "user",
      text: enteredMessage,
      base64ImageUrl: await ImageHandler().convertImageToBase64(
          _pickedImage?.path), // Add the image path to the message
    ));

    setState(() {
      _isSending = false; // Re-enable the send button
      _pickedImage = null; // Clear the picked image
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 8, bottom: 16),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _messageController,
                  textCapitalization: TextCapitalization.sentences,
                  autocorrect: true,
                  enableSuggestions: true,
                  decoration: InputDecoration(
                    prefixIcon: Padding(
                      padding: const EdgeInsets.only(left: 5),
                      child: IconButton(
                        icon: _pickedImage == null
                            ? const Icon(Icons.add_a_photo)
                            : Icon(Icons.photo_camera_back_rounded,
                                color: Theme.of(context).colorScheme.primary),
                        onPressed: _pickImage, // Handle image pick
                      ),
                    ),
                    hintText: 'Enter something',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Colors.grey[200],
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 10.0,
                      horizontal: 20.0,
                    ),
                  ),
                ),
              ),
              IconButton(
                color: Theme.of(context).colorScheme.primary,
                icon: Icon(_isSending ? Icons.send_outlined : Icons.send),
                onPressed: _isSending
                    ? null
                    : _submitMessage, // Disable the button when sending
              ),
            ],
          ),
        ],
      ),
    );
  }
}
