import 'package:flutter/material.dart';
import 'package:notes_app/database/notes_database.dart';
import 'package:notes_app/screens/notes_dialog.dart';
import 'package:notes_app/screens/note_card.dart';

class NotesScreen extends StatefulWidget {
  const NotesScreen({super.key});

  @override
  State<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  List<Map<String, dynamic>> notes = [];

  @override
  void initState() {
    super.initState();
    fetchNotes();
  }

  Future<void> fetchNotes() async {
    final fetchedNotes = await NotesDatabase.instance.getNotes();

    setState(() {
      notes = fetchedNotes;
    });
  }

  final List<Color> noteColors = [
    const Color(0xFFF3E5F5), // Light Purple
    const Color(0xFFFFF3E0), // Light Orange
    const Color(0xFFE1F5FE), // Light Blue
    const Color(0xFFFCE4EC), // Light Pink
    const Color(0xFFB9F6CA), // Baby Blue
    const Color(0xFFFFABAB), // Light Red
    const Color(0xFFB2F9FC), // Light Cyan
    const Color(0xFFFFD59A), // Light Peach
    const Color(0xFFFFE4B5), // Moccasin
    const Color(0xFF9BF89B), // Pale Green
    const Color(0xFFFFD700), // Gold
    const Color(0xFFFAFEEE), // Pale Turquoise
    const Color(0xFFFFB6C1), // Light Pink
    const Color(0xFFFFFAD2), // Light Goldenrod Yellow
    const Color(0xFFD3D3D3), // Light Grey
  ];

  void showNoteDialog({
    int? id,
    String? title,
    String? content,
    int colorIndex = 0,
  }) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return NotesDialog(
          colorIndex: colorIndex,
          noteColors: noteColors,
          noteId: id,
          title: title,
          content: content,
          onNoteSaved: (
            newTitle,
            newDescription,
            currentDate,
            selectedColorIndex,
          ) async {
            if (id == null) {
              await NotesDatabase.instance.addNote(
                newTitle,
                newDescription,
                currentDate,
                selectedColorIndex,
              );
            } else {
              await NotesDatabase.instance.updateNote(
                newTitle,
                newDescription,
                currentDate,
                selectedColorIndex,
                id,
              );
            }
            await fetchNotes();
            // ignore: use_build_context_synchronously
            Navigator.of(dialogContext).pop();
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Notes',
          style: TextStyle(
            color: Colors.blue,
            fontSize: 28,
            fontWeight: FontWeight.w500,
          ),
        ),
        actions: [
        IconButton(
          icon: const Icon(Icons.delete_forever, color: Colors.redAccent),
          onPressed: () async {
            await NotesDatabase.instance.deleteAllNotes();
            fetchNotes();
          },
        ),
      ],
      ),
      
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showNoteDialog();
        },
        backgroundColor: Colors.white,
        child: const Icon(Icons.add, color: Colors.black87),
      ),
      body:
          notes.isEmpty
              ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.notes_outlined,
                      size: 80,
                      color: Colors.grey[600],
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'No Notes Found',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.grey[400],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              )
              : Padding(
                padding: const EdgeInsets.all(16),
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 0.85,
                  ),
                  itemCount: notes.length,
                  itemBuilder: (context, index) {
                    final note = notes[index];

                    return NoteCard(
                      note: note,
                      onDelete: () async {
                        await NotesDatabase.instance.deleteNote(note['id']);
                        fetchNotes();
                      },
                      onTap: () {
                        showNoteDialog(
                          id: note['id'],
                          title: note['title'],
                          content: note['description'],
                          colorIndex: note['color'],
                        );
                      },
                      noteColors: noteColors,
                    );
                  },
                ),
              ),
    );
  }
}
