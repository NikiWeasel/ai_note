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
          CREATE TABLE user_notes (
          id TEXT PRIMARY KEY, 
          ispinned INTEGER,
          title TEXT, 
          content TEXT, 
          datetime TEXT)
         ''');
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

  void sortNotesByDateAndPin(List<Note> notes) {
    notes.sort((a, b) {
      // Сначала проверяем, закреплены ли заметки
      if (a.isPinned && !b.isPinned)
        return -1; // Если 'a' закреплена, а 'b' нет, 'a' должна быть впереди
      if (!a.isPinned && b.isPinned)
        return 1; // Если 'b' закреплена, а 'a' нет, 'b' должна быть впереди

      // Если обе заметки либо закреплены, либо не закреплены, сортируем по дате
      DateTime dateA = _parseDateTime(a.dateTime);
      DateTime dateB = _parseDateTime(b.dateTime);
      return dateB.compareTo(dateA); // Сортировка от самых новых к самым старым
    });
  }

  DateTime _parseDateTime(String dateTime) {
    final parts = dateTime.split(' ');
    final timePart = parts[0];
    final datePart = parts[1];

    final timeParts = timePart.split(':');
    final dateParts = datePart.split('/');

    return DateTime(
      int.parse(dateParts[2]), // Год
      int.parse(dateParts[1]), // Месяц
      int.parse(dateParts[0]), // День
      int.parse(timeParts[0]), // Часы
      int.parse(timeParts[1]), // Минуты
    );
  }

  Future<void> loadNotes() async {
    final db = await _getDatabase();
    final data = await db.query('user_notes', orderBy: 'ispinned DESC');
    final notes = data
        .map((row) => Note(
              id: row['id'] as String,
              isPinned: row['ispinned'] as int == 1 ? true : false,
              title: row['title'] as String,
              content: row['content'] as String,
              dateTime: row['datetime'] as String,
            ))
        .toList();
    state = notes;

    sortNotesByDateAndPin(state);
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
      'ispinned': newNote.isPinned == true ? 1 : 0,
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
          'title': newNote.title,
          'content': newNote.content,
          'datetime': newNote.dateTime
        },
        where: 'id = \'${oldNote.id}\'');

    state = state.where((m) => m.id != oldNote.id).toList();

    state = [newNote, ...state];

    // sortNotesByDate(state);
  }

  void deleteNote(Note noteToDelete) async {
    // final appDir = await syspath.getApplicationDocumentsDirectory();
    final db = await _getDatabase();

    db.delete('user_notes', where: 'id = \'${noteToDelete.id}\'');

    state = state.where((m) => m.id != noteToDelete.id).toList();
  }

  void pinNote(Note noteToPin) async {
    // final appDir = await syspath.getApplicationDocumentsDirectory();
    final db = await _getDatabase();

    if (noteToPin.isPinned == true) {
      return;
    }
    db.update(
        'user_notes',
        {
          'ispinned': 1,
        },
        where: 'id = \'${noteToPin.id}\'');

    final newNote = Note(
        title: noteToPin.title,
        content: noteToPin.content,
        id: noteToPin.id,
        dateTime: noteToPin.dateTime,
        isPinned: true);

    state = state.where((m) => m.id != noteToPin.id).toList();

    state = [newNote, ...state];
  }

  void unpinNote(Note noteToUnpin) async {
    // final appDir = await syspath.getApplicationDocumentsDirectory();
    final db = await _getDatabase();

    if (noteToUnpin.isPinned == false) {
      return;
    }
    db.update(
        'user_notes',
        {
          'ispinned': 0,
        },
        where: 'id = \'${noteToUnpin.id}\'');

    final newNote = Note(
        title: noteToUnpin.title,
        content: noteToUnpin.content,
        id: noteToUnpin.id,
        dateTime: noteToUnpin.dateTime,
        isPinned: false);

    state = state.where((m) => m.id != noteToUnpin.id).toList();

    // print(noteToUnpin.isPinned);
    state = [newNote, ...state];
  }
}

final notesProvider = StateNotifierProvider<NotesNotifier, List<Note>>((ref) {
  return NotesNotifier();
});
