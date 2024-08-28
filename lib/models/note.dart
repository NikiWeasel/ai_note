import 'package:uuid/uuid.dart';
import 'package:date_format/date_format.dart';

Uuid uuid = const Uuid();

class Note {
  Note(
      {required this.title,
      required this.content,
      String? id,
      bool? isPinned,
      String? dateTime})
      : id = id ?? uuid.v6(),
        isPinned = isPinned ?? false,
        dateTime = dateTime ??
            formatDate(
                DateTime.now(), [hh, ':', mm, ' ', dd, '/', mm, '/', yyyy]);

  final String id;
  final String title;
  final bool isPinned;
  final String content;
  final String dateTime;
}
