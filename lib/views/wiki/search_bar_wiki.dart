import 'package:flutter/material.dart';

class SearchAppBarWiki extends StatefulWidget {
  const SearchAppBarWiki(
      {super.key, required this.hintLabel, required this.onSubmitted});

  final String hintLabel;
  final Function(String) onSubmitted;

  @override
  State<SearchAppBarWiki> createState() => _SearchAppBarWikiState();
}

class _SearchAppBarWikiState extends State<SearchAppBarWiki> {
  FocusNode _focusNode = FocusNode();
  String searchVal = '';
  TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _focusNode.requestFocus();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      alignment: Alignment.centerLeft,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white,
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              focusNode: _focusNode,
              controller: _controller,
              textInputAction: TextInputAction.search,
              onChanged: (value) {
                setState(() {
                  searchVal = value;
                });
              },
              onSubmitted: (value) {
                widget.onSubmitted(value);
                _focusNode.unfocus();
              },
              decoration: InputDecoration(
                hintText: widget.hintLabel,
                border: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(25.0)),
                ),
                prefixIcon: Icon(Icons.search),
                suffixIcon: searchVal.isNotEmpty
                    ? Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.close),
                            onPressed: () {
                              setState(() {
                                searchVal = '';
                                _controller.clear();
                              });
                              widget.onSubmitted(''); // 清空搜尋結果
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.send),
                            onPressed: searchVal.isNotEmpty
                                ? () {
                                    widget.onSubmitted(searchVal);
                                    _focusNode.unfocus();
                                  }
                                : null,
                          ),
                        ],
                      )
                    : IconButton(
                        icon: Icon(Icons.send),
                        onPressed: searchVal.isNotEmpty
                            ? () {
                                widget.onSubmitted(searchVal);
                                _focusNode.unfocus();
                              }
                            : null,
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
