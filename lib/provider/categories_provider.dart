// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:ai_note/models/note.dart';
// import 'package:ai_note/models/category.dart';
// import 'package:path_provider/path_provider.dart' as syspath;
// import 'package:path/path.dart' as path;
// import 'package:sqflite/sqflite.dart' as sql;
// import 'package:sqflite/sqlite_api.dart';
//

part of 'package:ai_note/provider/note_provider.dart';

// Future<void> _createDb(Database db) async {
//   await db.execute('''
//           CREATE TABLE categories (
//             id TEXT PRIMARY KEY,
//             name TEXT NOT NULL
//           );
//         ''');
//   await db.execute('''
//           CREATE TABLE category_notes (
//             category_id TEXT,
//             note_id TEXT,
//             FOREIGN KEY (category_id) REFERENCES categories(id) ON DELETE CASCADE,
//             FOREIGN KEY (note_id) REFERENCES user_notes(id) ON DELETE CASCADE,
//             PRIMARY KEY (category_id, note_id)
//           );
//         ''');
// }

class CategoriesNotifier extends StateNotifier<List<Category>> {
  CategoriesNotifier() : super([]);

  Future<void> loadCategories() async {
    final db = await _getDatabase();
    final catsData = await db.query('categories');
    final catNotesData = await db.query('category_notes');
    // final categories = catsData
    //     .map((row) => Category(
    //           id: row['id'] as String,
    //           name: row['name'] as String,
    //         ))
    //     .toList();
    // final categories2 = catNotesData
    //     .map((row) => Category(
    //           id: row['id'] as String,
    //           name: row['name'] as String,
    //         ))
    //     .toList();

    // Создаем карту, где ключом будет category_id, а значением — список note_id
    final Map<String, List<String>> categoryNotesMap = {};

// Заполняем карту на основе данных из таблицы category_notes
    for (var row in catNotesData) {
      final String categoryId = row['category_id'] as String;
      final String noteId = row['note_id'] as String;

      if (categoryNotesMap.containsKey(categoryId)) {
        categoryNotesMap[categoryId]!.add(noteId);
      } else {
        categoryNotesMap[categoryId] = [noteId];
      }
    }

// Создаем список категорий с учетом заметок
    final List<Category> categories = catsData.map((row) {
      final String id = row['id'] as String;
      final String name = row['name'] as String;
      final List<String>? notesList = categoryNotesMap[id];

      return Category(
        id: id,
        name: name,
        notesList: notesList,
      );
    }).toList();

    state = categories;
  }

  Future<void> getCategoryWithNotes(Database db, String categoryId) async {
    // Получение имени категории
    final categoryResult = await db.query(
      'categories',
      where: 'id = $categoryId',
      limit: 1,
    );

    if (categoryResult.isEmpty) {
      // Если категория не найдена, возвращаем null
      return;
    }

    final categoryName = categoryResult.first['name'] as String;

    // Получение списка заметок по данной категории
    final notesResult = await db.rawQuery('''
    SELECT user_notes.content
    FROM user_notes
    INNER JOIN category_notes ON notes.id = category_notes.note_id
    WHERE category_notes.category_id = $categoryId
  ''');

    // Преобразование списка заметок в список строк (их содержимого)
    final List<String> notesList =
        notesResult.map((note) => note['content'] as String).toList();

    // Создание объекта Category
    final newCategory = Category(
      id: categoryId,
      name: categoryName,
      notesList: notesList,
    );

    state = [newCategory, ...state];
  }

  Future<bool> insertCategory(String name) async {
    final db = await _getDatabase();
    final matchingList =
        state.where((category) => category.name == name).toList();
    if (matchingList.isNotEmpty) {
      return false;
    }
    final newCategory = Category(name: name, notesList: null);

    await db.insert('categories', {
      'id': newCategory.id,
      'name': newCategory.name,
    });

    state = [newCategory, ...state];
    return true;
  }

  Future<void> deleteCategory(Category category) async {
    final db = await _getDatabase();
    db.delete('categories', where: 'id = \'${category.id}\'');
    db.delete('category_notes', where: 'category_id = \'${category.id}\'');
    // print(category.name);
    state = state.where((c) => c.id != category.id).toList();
  }

  Future<void> renameCategory(Category category, String newName) async {
    // final appDir = await syspath.getApplicationDocumentsDirectory();
    final db = await _getDatabase();

    final newCat = Category(name: newName);

    db.update(
        'categories',
        {
          'name': newCat.name,
        },
        where: 'id = \'${category.id}\'');

    state = state.where((m) => m.id != category.id).toList();

    state = [newCat, ...state];
  }

  Future<void> linkNoteToCategory(String categoryId, String noteId) async {
    final db = await _getDatabase();

    await db.insert('category_notes', {
      'category_id': categoryId,
      'note_id': noteId,
    });
  }
}

final categoriesProvider =
    StateNotifierProvider<CategoriesNotifier, List<Category>>((ref) {
  return CategoriesNotifier();
});

class CurrentCategoryNotifier extends StateNotifier<int> {
  CurrentCategoryNotifier() : super(0);

  void setCategory(int index) {
    state = index;
  }
}

final categoryIndexProvider =
    StateNotifierProvider<CurrentCategoryNotifier, int>((ref) {
  return CurrentCategoryNotifier();
});
