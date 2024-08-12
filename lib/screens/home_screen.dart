import 'package:ai_note/models/note.dart';
import 'package:ai_note/provider/function_provider.dart';
import 'package:ai_note/provider/note_provider.dart';
import 'package:ai_note/provider/selected_notes_provider.dart';
import 'package:ai_note/screens/chat_screen.dart';
import 'package:ai_note/screens/note_screen.dart';
import 'package:ai_note/widgets/ai_chat.dart';
import 'package:ai_note/widgets/main_drawer.dart';
import 'package:ai_note/widgets/no_content.dart';
import 'package:ai_note/widgets/notes_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_adaptive_scaffold/flutter_adaptive_scaffold.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart';

import 'package:ai_note/provider/toggle_mode_provider.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  late Future<void> _notesFuture;

  // int _selectedIndex = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _notesFuture = ref.read(notesProvider.notifier).loadNotes();
  }

  void _onItemTapped(int index, NoteActionsProvider noteFunctions,
      List<Note> selectedNotesList) {
    switch (index) {
      case 0:
      case 3:
        noteFunctions.onDelete(ref, context, selectedNotesList);
    }

    // print("Tapped on index $index");
  }

  @override
  Widget build(BuildContext context) {
    final noteFunctions = ref.watch(noteActionsProvider);
    final isSelectingMode = ref.watch(toggleModeProvider);
    final selectedNotesList = ref.watch(selectedNotesProvider);

    final notesList = ref.watch(notesProvider);
    Widget content = notesList.isEmpty
        ? NoContent(
            onNewNote: () {
              noteFunctions.onCreate(ref, context);
            },
            onAiChat: () {},
          )
        : FutureBuilder(
            future: _notesFuture,
            builder: (ctx, snapshot) =>
                snapshot.connectionState == ConnectionState.waiting
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : NotesList(notes: notesList));

    // content = NotesList(notes: notesList);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        title: const Text('AI Note'),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (ctx) => ChatScreen()));
              },
              icon: const Icon(Icons.accessible_forward_sharp))
        ],
      ),
      bottomNavigationBar: isSelectingMode
          ? BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.arrow_forward,
                  ),
                  label: 'Move',
                ),
                BottomNavigationBarItem(
                    icon: Icon(Icons.arrow_upward_outlined), label: 'Pin'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.arrow_forward), label: 'Move'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.delete), label: 'Delete'),
              ],
              onTap: selectedNotesList.isNotEmpty
                  ? (index) {
                      _onItemTapped(index, noteFunctions, selectedNotesList);
                    }
                  : null,
              selectedItemColor: Theme.of(context).colorScheme.onSurface,
              unselectedItemColor: Theme.of(context).colorScheme.onSurface,
            )
          : null,
      //
      // ),
      // drawer: MainDrawer(),
      body: content,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          noteFunctions.onCreate(ref, context);
        },
        backgroundColor:
            Theme.of(context).colorScheme.primaryContainer.withRed(23),
        child: Icon(
          Icons.add,
          color: Theme.of(context).colorScheme.onSurface,
        ),
      ),
    );
  }
}
