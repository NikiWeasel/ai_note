import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SpeechBubble extends StatelessWidget {
  SpeechBubble({
    super.key,
    required this.text,
    required this.isMe,
  });

  String text;
  bool isMe;

  // final bool isBlank;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isMe ? Alignment.topRight : Alignment.topLeft,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.8,
        ),
        child: Container(
          margin: EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
                bottomLeft: isMe ? Radius.circular(20) : Radius.zero,
                bottomRight: isMe ? Radius.zero : Radius.circular(20),
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20)),
            color: isMe ? Colors.blueAccent : Colors.blueGrey,
          ),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: SelectableText(
              text!,
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge!
                  .copyWith(color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }
}
