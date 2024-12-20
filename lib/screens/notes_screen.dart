import 'package:flutter/material.dart';
import '../database/database_helper.dart';

class NotesScreen extends StatefulWidget {
  @override
  _NotesScreenState createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  final dbHelper = DatabaseHelper.instance;
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();

  List<Map<String, dynamic>> notes = [];

  @override
  void initState() {
    super.initState();
    refreshNotes();
  }

  void refreshNotes() async {
    final data = await dbHelper.getData('notes');
    setState(() {
      notes = data;
    });
  }

  void addNote() async {
    final title = titleController.text;
    final description = descriptionController.text;

    if (title.isNotEmpty && description.isNotEmpty) {
      await dbHelper.insertData('notes',
          {'title': title, 'description': description, 'completed': 0});
      refreshNotes();
      titleController.clear();
      descriptionController.clear();
    }
  }

  void toggleComplete(int id, int currentStatus) async {
    await dbHelper.updateData(
        'notes', {'completed': currentStatus == 0 ? 1 : 0}, id);
    refreshNotes();
  }

  void deleteNote(int id) async {
    await dbHelper.deleteData('notes', id);
    refreshNotes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Заметки')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                TextField(
                  controller: titleController,
                  decoration: InputDecoration(labelText: 'Заголовок'),
                ),
                TextField(
                  controller: descriptionController,
                  decoration: InputDecoration(labelText: 'Описание'),
                ),
                ElevatedButton(
                  child: Text('Добавить'),
                  onPressed: addNote,
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: notes.length,
              itemBuilder: (context, index) {
                final note = notes[index];
                return ListTile(
                  title: Text(note['title']),
                  subtitle: Text(note['description']),
                  leading: IconButton(
                    icon: Icon(note['completed'] == 0
                        ? Icons.check_box_outline_blank
                        : Icons.check_box),
                    onPressed: () =>
                        toggleComplete(note['id'], note['completed']),
                  ),
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () => deleteNote(note['id']),
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
