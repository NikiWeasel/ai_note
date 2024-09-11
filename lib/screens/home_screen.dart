import 'package:ai_note/models/note.dart';
import 'package:ai_note/provider/note_function_provider.dart';
import 'package:ai_note/provider/note_provider.dart';
import 'package:ai_note/provider/selected_notes_provider.dart';
import 'package:ai_note/screens/chat_screen.dart';
import 'package:ai_note/screens/note_screen.dart';
import 'package:ai_note/screens/settings_screen.dart';
import 'package:ai_note/widgets/ai_chat.dart';
import 'package:ai_note/widgets/custom_scrollview.dart';
import 'package:ai_note/widgets/no_content.dart';
import 'package:ai_note/widgets/notes_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_adaptive_scaffold/flutter_adaptive_scaffold.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart';
import 'package:ai_note/provider/toggle_mode_provider.dart';
import 'package:ai_note/widgets/input_widget.dart';
import 'package:ai_note/models/sliver_appbar_delegate.dart';
import 'package:ai_note/widgets/choose_category.dart';

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
    super.initState();
    _notesFuture = ref.read(notesProvider.notifier).loadNotes();
  }

  void _onItemTapped(int index, NoteActionsProvider noteFunctions,
      List<Note> selectedNotesList) {
    switch (index) {
      case 0:
      case 1:
        noteFunctions.onTogglePin(ref, selectedNotesList);
      case 2:
        showDialog(
            context: context,
            builder: (ctx) => ChooseCategory(
                  selectedNotes: selectedNotesList,
                ));
      case 3:
        noteFunctions.onDelete(ref, context, selectedNotesList);
    }
  }

  @override
  Widget build(BuildContext context) {
    final noteFunctions = ref.watch(noteActionsProvider);
    final isSelectingMode = ref.watch(toggleModeProvider);
    final selectedNotesList = ref.watch(selectedNotesProvider);
    final isSelectingModeNotifier = ref.watch(toggleModeProvider.notifier);

    final notesList = ref.watch(notesProvider);

    bool isAllPinned() {
      final notPinnedNotes =
          selectedNotesList.where((note) => note.isPinned == false);
      if (notPinnedNotes.isNotEmpty) {
        return true;
      } else {
        return false;
      }
    }

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
                    : const CustomScrollview());

    bool onBackPressed() {
      if (isSelectingMode) {
        setState(() {
          isSelectingModeNotifier.toggleSelectingMode();
        });
        return false;
      }
      return true;
    }

    return PopScope(
      canPop: !isSelectingMode,
      onPopInvoked: (didPop) {
        if (didPop) {
          return;
        }
        final navigator = Navigator.of(context);
        final shouldPop = onBackPressed();
        if (shouldPop) {
          navigator.pop();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
          title: isSelectingMode
              ? Center(
                  child: Text('Selected: ${selectedNotesList.length}'),
                )
              : const Text('AI Note'),
          actions: isSelectingMode
              ? null
              : [
                  IconButton(
                      onPressed: () {
                        Navigator.of(context).push(
                            MaterialPageRoute(builder: (ctx) => ChatScreen()));
                      },
                      icon: const Icon(Icons.accessible_forward_sharp)),
                  IconButton(
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (ctx) => SettingsScreen()));
                      },
                      icon: const Icon(Icons.settings)),
                ],
        ),
        bottomNavigationBar: isSelectingMode
            ? BottomNavigationBar(
                type: BottomNavigationBarType.fixed,
                items: [
                  const BottomNavigationBarItem(
                    icon: Icon(
                      Icons.arrow_forward,
                    ),
                    label: 'Move',
                  ),
                  isAllPinned()
                      ? const BottomNavigationBarItem(
                          icon: Icon(Icons.push_pin_outlined), label: 'Pin')
                      : BottomNavigationBarItem(
                          icon: Transform.rotate(
                              angle: 30 * 3.14 / 180,
                              child: const Icon(Icons.push_pin_outlined)),
                          label: 'Unpin'),
                  const BottomNavigationBarItem(
                      icon: Icon(Icons.arrow_forward), label: 'Move'),
                  const BottomNavigationBarItem(
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
        body: content,
        floatingActionButton: FloatingActionButton(
          mini: true,
          onPressed: () {
            noteFunctions.onCreate(ref, context);
          },
          backgroundColor: Colors.black54,
          child: Icon(
            Icons.add,
            color: Theme.of(context).colorScheme.onSecondary,
          ),
        ),
      ),
    );
  }
}
