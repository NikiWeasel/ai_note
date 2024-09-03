import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';

Uuid uuid = const Uuid();

class RequestSender {
  // const RequestSender({
  //   // required this.messeges,
  // });
  // final List<Message> messeges;

  // void _addMsg(Message message) {
  //   setState(() {
  //     _msgList.insert(0, message);
  //   });
  // }
  String? _accessToken;

  Future<void> setAccessToken() async {
    var rquid = uuid.v6();

    const url = 'https://ngw.devices.sberbank.ru:9443/api/v2/oauth';
    var payload = 'scope=GIGACHAT_API_PERS';
    var authBase64 = base64Encode(utf8.encode(
        'MGY5Njc0M2QtNmU3OC00YmZlLWEzYzAtNDIwYTkzYjg0MmFlOmUwYTY0MzljLTU1MDktNDY2Zi1hZjkyLWU2ZmI5NjdiM2U0Nw=='));
    //
    // HttpClient httpClient = HttpClient()
    //   ..badCertificateCallback =
    //       (X509Certificate cert, String host, int port) => true;

    final headers = {
      'Content-Type': 'application/x-www-form-urlencoded',
      'Accept': 'application/json',
      'RqUID': rquid,
      'Authorization': 'Basic $authBase64'
    };

    // final body = json.encode({
    //   'inputs': input,
    //   'parameters': {'max_length': 2000, 'temperature': 0.7, 'top_p': 0.9}
    //   // Замените на ваши данные
    // });

    final response = await http.post(
      Uri.parse(url),
      headers: headers,
      body: payload,
    );
    _accessToken = json.decode(utf8.decode(response.bodyBytes));
    print(_accessToken);
  }

  Future<String?> sendRequest(String input) async {
    if (input == '' || _accessToken == null) {
      return null;
    }

    // _addMsg(Message(text: input, isMe: true));

    // final model = 'EleutherAI/gpt-neo-125m';
    const url = 'https://gigachat.devices.sberbank.ru/api/v1/chat/completions';
    // final apiKey =
    //     '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'; // Замените на ваш API-ключ Hugging Face

    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $_accessToken'
    };

    // String prompt = conversationHistory.join('\n');

    final body = json.encode({
      'model': 'GigaChat',
      'messages': [
        {
          'role': 'user',
          'content': input,
        }
      ],
      'stream': false,
      'repetition_penalty': 1,

      // 'inputs': input,
      // 'parameters': {'max_length': 2000, 'temperature': 0.7, 'top_p': 0.9}
    });

    final response = await http.post(
      Uri.parse(url),
      headers: headers,
      body: utf8.encode(body),
    );

    if (response.statusCode == 200) {
      final responseData = json.decode(utf8.decode(response.bodyBytes));
      String content = responseData['choices'][0]['message']['content'];
      print('Response data: ${responseData}');
      print('Response content: $content');
      return content;

      // setState(() {
      //   _response = responseData[0]['generated_text'];
      //
      //   // _msgList.insert(0, Message(text: _response, isMe: false));
      // });
      // _addMsg(Message(text: _response, isMe: false));
    } else {
      //error
      print(response.statusCode);
      return null;
    }
  }
}
