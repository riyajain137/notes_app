import 'package:flutter/material.dart';
import 'package:notes_app/screens/notes_screen.dart';

void main() {
  runApp(NotesApp());
}

class NotesApp extends StatelessWidget {
  const NotesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Notes App',
      theme: ThemeData(primarySwatch: Colors.blueGrey, scaffoldBackgroundColor: Color(0XFF1E1E1E)),
      debugShowCheckedModeBanner: false,

      home: NotesScreen(),
    );
  }
}
