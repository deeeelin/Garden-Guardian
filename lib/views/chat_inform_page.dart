import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class ChatInformDialog extends StatefulWidget {
  const ChatInformDialog({Key? key}) : super(key: key);

  @override
  _ChatInformDialogState createState() => _ChatInformDialogState();
}

class _ChatInformDialogState extends State<ChatInformDialog> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: Scaffold(
        backgroundColor: Colors.black54,
        body: Center(
          child: Container(
            width: MediaQuery.of(context).size.width * 0.8,
            height: MediaQuery.of(context).size.height * 0.8,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: LinearGradient(
                colors: [Color.fromARGB(255, 195, 226, 196), Colors.white],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Column(
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: IconButton(
                    icon: const Icon(Icons.close, color: Colors.red),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: SingleChildScrollView(
                      child: MarkdownBody(
                        data: """
# 🌸 Hi , I'm Blossom !  🌸
##
## 🌼 About Me 🌼
Hello! I am **Blossom**, your AI assistant designed to help you nurture and grow your plants. With a deep-rooted interest in horticulture, I am here to make your gardening experience seamless and enjoyable. I am particularly enthusiastic about using technology to enhance plant care and ensuring that you have all the knowledge and tools you need to cultivate a thriving garden.

## 🌿 What am I capable of? 🌿
I have a range of features to assist you with your gardening needs:

#### 🌱 Answer Planting Questions 🌱
Whether you're a seasoned gardener or just starting, I can provide answers to your planting questions. From selecting the right soil to understanding watering needs, I'm here to guide you through every step of the planting process.

#### 📄 Forming Planting Documents 📄
I can help you create detailed planting documents, including care instructions, growth timelines, and maintenance schedules for various plants. These documents will ensure you have a comprehensive guide to refer to, helping your plants thrive.

#### ⏰ Schedule Routines for Planting ⏰
Managing your garden can be a breeze with my scheduling capabilities. I can assist you in setting up routines for planting, watering, fertilizing, and more. With tailored reminders and schedules, you can ensure that your plants receive consistent care.

#### 🧠 Long-Term Memory 🧠
I have the ability to remember all past messages by searching my database. This long-term memory feature ensures that I can recall previous conversations and provide continuity in our interactions, making your experience more personalized and efficient.

Let's grow something beautiful together!

Blossom 🌸
                        """,
                        styleSheet: MarkdownStyleSheet(
                          p: const TextStyle(
                            color: Colors.black,
                          ),
                          h1: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                          h2: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                          h3: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                          h4: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                          h5: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                          h6: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
