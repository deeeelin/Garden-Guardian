import 'package:flutter/material.dart';

class SearchAppBar extends StatefulWidget {
  const SearchAppBar({super.key, required this.hintLabel, required this.onSubmitted});

  final String hintLabel;
  final Function(String) onSubmitted;

  @override
  State<SearchAppBar> createState() => _SearchAppBarState();
}

class _SearchAppBarState extends State<SearchAppBar> {
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
    MediaQueryData queryData = MediaQuery.of(context);
    return Container(
      width: queryData.size.width * 0.8,
      height: 40,
      padding: const EdgeInsets.only(left: 20),
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
                border: InputBorder.none,
                prefixIcon: Icon(Icons.search),
                suffixIcon: searchVal.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () {
                          setState(() {
                            searchVal = '';
                            _controller.clear();
                          });
                          widget.onSubmitted(''); // 清空搜尋結果
                        },
                      )
                    : null,
              ),
            ),
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
      ),
    );
  }
}
