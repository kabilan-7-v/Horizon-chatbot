import 'package:flutter/material.dart';
import 'package:horizon/service/gradienttext.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HorizonNotes extends StatefulWidget {
  const HorizonNotes({super.key});

  @override
  State<HorizonNotes> createState() => _HorizonNotesState();
}

class _HorizonNotesState extends State<HorizonNotes> {
  List<String> _notes = [];
  final GlobalKey<ScaffoldState> key = GlobalKey();

  final TextEditingController _noteController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadNotes();
  }

  // Load notes from shared_preferences
  Future<void> _loadNotes() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _notes = prefs.getStringList('notes') ?? [];
    });
  }

  // Save notes to shared_preferences
  Future<void> _saveNotes() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setStringList('notes', _notes);
  }

  // Add a new note
  void addNote() {
    if (_noteController.text.isNotEmpty) {
      setState(() {
        _notes.add(_noteController.text);
      });
      _saveNotes();
      _noteController.clear();
    }
  }

  // Delete a note
  void deleteNote(int index) {
    setState(() {
      _notes.removeAt(index);
    });
    _saveNotes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          color: Colors.white,
        ),
        backgroundColor: Colors.black,
        title: const GradientText(
          "Horizon Notes",
          style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
          gradient: LinearGradient(
              colors: [Color.fromRGBO(228, 212, 156, 1), Color(0xffad9c00)]),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _noteController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Enter a new note',
                hintStyle: const TextStyle(color: Colors.grey),
                filled: true,
                fillColor: Colors.black54,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
            ),
          ),
          ElevatedButton(
            onPressed: addNote,
            child: const Text('Add Note'),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _notes.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListTile(
                    tileColor: Colors.grey,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 50,
                    ),
                    title: Text(
                      _notes[index],
                      style: const TextStyle(
                          color: Color.fromARGB(255, 19, 16, 16)),
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => deleteNote(index),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
