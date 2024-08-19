import 'package:ai_note/screens/note_screen.dart';
import 'package:ai_note/widgets/input_widget.dart';
import 'package:ai_note/widgets/speech_bubble.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:ai_note/models/message.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/tap_bounce_container.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class AiChat extends StatefulWidget {
  @override
  State<AiChat> createState() => _AiChatState();
}

class _AiChatState extends State<AiChat> {
  final _controller = TextEditingController();
  var _response = '';
  List<Message> _msgList = [];

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  void _addMsg(Message message) {
    setState(() {
      _msgList.insert(0, message);
    });
  }

  get conversationHistory {
    List<String> msgListReversed = [];
    for (int i = _msgList.length - 1; i >= 0; i--) {
      if (_msgList[i].isMe) {
        msgListReversed.add('User: ${_msgList[i].text}');
      } else {
        msgListReversed.add('Bot: ${_msgList[i].text}');
      }
    }
    return msgListReversed;
  }

  Future<void> sendRequest(String input) async {
    if (input == '') {
      return;
    }
    _addMsg(Message(text: input, isMe: true));
    // setState(() {
    //   _msgList.insert(0, Message(text: input, isMe: true));
    // });

    final model = 'EleutherAI/gpt-neo-125m';
    final url = 'https://api-inference.huggingface.co/models/$model';
    final apiKey =
        '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'; // Замените на ваш API-ключ Hugging Face

    final headers = {
      'Authorization': 'Bearer $apiKey',
      'Content-Type': 'application/json; charset=UTF-8'
    };

    String prompt = conversationHistory.join('\n');

    final body = json.encode({
      'inputs': prompt,
      'parameters': {'max_length': 2000, 'temperature': 0.7, 'top_p': 0.9}
      // Замените на ваши данные
    });

    final response = await http.post(
      Uri.parse(url),
      headers: headers,
      body: utf8.encode(body),
    );
    // final responseData = json.decode(response.body);

    // print(responseData['generated_text']);

    if (response.statusCode == 200) {
      final responseData = json.decode(utf8.decode(response.bodyBytes));
      print('Response data: ${responseData}');

      setState(() {
        _response = responseData[0]['generated_text'];

        // _msgList.insert(0, Message(text: _response, isMe: false));
      });
      _addMsg(Message(text: _response, isMe: false));
    } else {
      showTopSnackBar(
        Overlay.of(context),
        CustomSnackBar.info(
          message: 'Request failed with status: ${response.statusCode}',
        ),
      );
      // print('Request failed with status: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget content = _msgList.isEmpty
        ? Center(
            child: Text(
              'Try asking something',
              style:
                  Theme.of(context).textTheme.bodyLarge!.copyWith(fontSize: 24),
            ),
          )
        : ListView.builder(
            reverse: true,
            itemCount: _msgList.length + 1,
            itemBuilder: (ctx, index) => index != 0
                ? SpeechBubble(
                    text: _msgList[index - 1].text,
                    isMe: _msgList[index - 1].isMe)
                : Container(
                    // color: Colors.red,
                    height: 80,
                  ));

    return Stack(
      children: [
        content,
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: InputWidget(
              onPressed: sendRequest,
              icon: const Icon(
                Icons.send,
                color: Colors.white,
              ),
            ),
          ),
        )
      ],
    );
  }
}
