import 'package:uuid/uuid.dart';

import 'package:ai_note/models/note.dart';

Uuid uuid = const Uuid();

class Category {
  Category({required this.name, this.notesList, String? id})
      : id = id ?? uuid.v6();

  final String id;
  final String name;
  final List<String>? notesList;
}
