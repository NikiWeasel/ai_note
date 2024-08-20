import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ai_note/models/note.dart';
import 'package:path_provider/path_provider.dart' as syspath;
import 'package:path/path.dart' as path;
import 'package:sqflite/sqflite.dart' as sql;
import 'package:sqflite/sqlite_api.dart';
import 'package:ai_note/models/category.dart';

part 'package:ai_note/provider/categories_provider.dart';

Future<Database> _getDatabase() async {
  final dbPath = await sql.getDatabasesPath();
  final db = await sql.openDatabase(path.join(dbPath, 'notes.db'),
      onCreate: (db, version) async {
    // return db.execute(
    //     'CREATE TABLE user_notes (id TEXT PRIMARY KEY, title TEXT, content TEXT, datetime TEXT)');
    await _createDb(db);
  }, version: 1);
  return db;
}

Future<void> _createDb(Database db) async {
  await db.execute('''
  CREATE TABLE user_notes (id TEXT PRIMARY KEY, title TEXT, content TEXT, datetime TEXT)''');
  await db.execute('''
          CREATE TABLE categories (
            id TEXT PRIMARY KEY,
            name TEXT NOT NULL
          );
        ''');
  await db.execute('''
          CREATE TABLE category_notes (
            category_id TEXT,
            note_id TEXT,
            FOREIGN KEY (category_id) REFERENCES categories(id) ON DELETE CASCADE,
            FOREIGN KEY (note_id) REFERENCES user_notes(id) ON DELETE CASCADE,
            PRIMARY KEY (category_id, note_id)
          );
        ''');
}

class NotesNotifier extends StateNotifier<List<Note>> {
  NotesNotifier() : super([]);

  Future<void> loadNotes() async {
    final db = await _getDatabase();
    final data = await db.query('user_notes');
    final notes = data
        .map((row) => Note(
              id: row['id'] as String,
              title: row['title'] as String,
              content: row['content'] as String,
              dateTime: row['datetime'] as String, //TODO убрать '?'
            ))
        .toList();
    state = notes;
  }

  void addNote(String title, String content) async {
    // final appDir = await syspath.getApplicationDocumentsDirectory();
    // final filename = path.basename(image.path);
    // final copiedImage = await image.copy('${appDir.path}/$filename');

    final newNote = Note(
      title: title,
      content: content,
    );

    final db = await _getDatabase();

    db.insert('user_notes', {
      'id': newNote.id,
      'title': newNote.title,
      'content': newNote.content,
      'datetime': newNote.dateTime,
    });

    state = [newNote, ...state];
  }

  void editNote(Note oldNote, String newTitle, String newContent) async {
    // final appDir = await syspath.getApplicationDocumentsDirectory();
    final db = await _getDatabase();

    final newNote = Note(title: newTitle, content: newContent, id: oldNote.id);

    db.update(
        'user_notes',
        {
          // 'id': editedNote.id,
          'title': newNote.title,
          'content': newNote.content,
          'datetime': newNote.dateTime
        },
        where: 'id = \'${oldNote.id}\'');

    state = state.where((m) => m.id != oldNote.id).toList();

    state = [newNote, ...state];
  }

  void deleteNote(Note noteToDelete) async {
    // final appDir = await syspath.getApplicationDocumentsDirectory();
    final db = await _getDatabase();

    db.delete('user_notes', where: 'id = \'${noteToDelete.id}\'');

    state = state.where((m) => m.id != noteToDelete.id).toList();
  }
}

final notesProvider = StateNotifierProvider<NotesNotifier, List<Note>>((ref) {
  return NotesNotifier();
});
