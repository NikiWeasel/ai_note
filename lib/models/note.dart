import 'package:uuid/uuid.dart';
import 'package:date_format/date_format.dart';

Uuid uuid = const Uuid();

class Note {
  Note(
      {required this.title,
      required this.content,
      String? id,
      String? dateTime})
      : id = id ?? uuid.v6(),
        dateTime = dateTime ??
            formatDate(
                DateTime.now(), [hh, ':', mm, ' ', dd, '/', mm, '/', yyyy]);

  final String id;
  final String title;
  final String content;
  final String dateTime;
}
