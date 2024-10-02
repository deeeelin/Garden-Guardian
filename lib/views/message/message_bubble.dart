import 'dart:convert';
import 'dart:html' as html;
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class MessageBubble extends StatefulWidget {
  const MessageBubble.withUser({
    super.key,
    required this.userName,
    required this.text,
    required this.isMine,
    required this.isLast,
    this.base64ImageUrl,
  });

  const MessageBubble({
    super.key,
    required this.text,
    required this.isMine,
    required this.isLast,
    this.base64ImageUrl,
  }) : userName = null;

  final bool isLast;
  final String? userName;
  final String? base64ImageUrl;
  final String text;
  final bool isMine;

  @override
  _MessageBubbleState createState() => _MessageBubbleState();
}

class _MessageBubbleState extends State<MessageBubble>
    with AutomaticKeepAliveClientMixin, SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<int> _characterCount;
  bool _isAnimated = false;
  String get _animationKey => 'animated_${widget.text.hashCode}';

  @override
  void initState() {
    super.initState();
    _loadAnimationState(); //! this method is for web to prevent animation on every page load
    // refer to this link if translation to android is needed: https://chatgpt.com/g/g-cZPwvslfA-flutter
  }

  void _loadAnimationState() {
    String? animatedState = html.window.localStorage[_animationKey];
    _isAnimated =
        !widget.isMine && (animatedState == null || animatedState != 'true');

    if (_isAnimated) {
      _controller = AnimationController(
        duration: Duration(milliseconds: widget.text.length * 50),
        vsync: this,
      );

      _characterCount =
          StepTween(begin: 0, end: widget.text.length).animate(_controller)
            ..addListener(() {
              setState(() {});
            })
            ..addStatusListener((status) {
              if (status == AnimationStatus.completed) {
                setState(() {
                  _isAnimated = false;
                  html.window.localStorage[_animationKey] = 'true';
                });
              }
            });

      _controller.forward();
    }
  }

  @override
  void dispose() {
    if (_isAnimated) {
      _controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final theme = Theme.of(context);

    String textToShow = widget.isMine || !_isAnimated
        ? widget.text
        : widget.text.substring(0, _characterCount.value);

    return Stack(
      children: [
        if (!widget.isMine)
          Positioned(
            top: 16,
            child: CircleAvatar(
              backgroundImage: AssetImage('assets/images/avatar.jpg'),
              radius: 12,
            ),
          ),
        Container(
          margin: EdgeInsets.symmetric(horizontal: widget.isMine ? 0 : 24),
          child: Row(
            mainAxisAlignment:
                widget.isMine ? MainAxisAlignment.end : MainAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: widget.isMine
                    ? CrossAxisAlignment.end
                    : CrossAxisAlignment.start,
                children: [
                  if (!widget.isMine && widget.userName != null)
                    const SizedBox(height: 18),
                  if (!widget.isMine && widget.userName != null)
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 8,
                        right: 8,
                        bottom: 4,
                      ),
                      child: Text(
                        widget.userName!,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                  Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: widget.isMine
                              ? theme.colorScheme.primary
                              : theme.colorScheme.primaryContainer,
                          borderRadius: BorderRadius.only(
                            topLeft: !widget.isMine
                                ? Radius.zero
                                : const Radius.circular(16),
                            topRight: widget.isMine
                                ? Radius.zero
                                : const Radius.circular(16),
                            bottomLeft: widget.isMine || widget.isLast
                                ? const Radius.circular(16)
                                : Radius.zero,
                            bottomRight: !widget.isMine || widget.isLast
                                ? const Radius.circular(16)
                                : Radius.zero,
                          ),
                        ),
                        constraints: const BoxConstraints(maxWidth: 200),
                        padding: const EdgeInsets.symmetric(
                          vertical: 12,
                          horizontal: 16,
                        ),
                        margin: const EdgeInsets.symmetric(
                          vertical: 2,
                          horizontal: 8,
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (widget.base64ImageUrl != null)
                              Padding(
                                padding: const EdgeInsets.only(bottom: 8),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(5.0),
                                  child: Image.memory(
                                    Uri.parse(widget.base64ImageUrl as String)
                                        .data!
                                        .contentAsBytes(),
                                  ),
                                ),
                              ),
                            MarkdownBody(
                              data: textToShow,
                              styleSheet: MarkdownStyleSheet(
                                p: TextStyle(
                                  height: 1.3,
                                  color: widget.isMine
                                      ? theme.colorScheme.onPrimary
                                      : theme.colorScheme.onPrimaryContainer,
                                ),
                              ),
                              softLineBreak: true,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;
}
