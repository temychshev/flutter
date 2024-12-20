import 'package:flutter/material.dart';
import '../database/database_helper.dart';

class GoalsScreen extends StatefulWidget {
  @override
  _GoalsScreenState createState() => _GoalsScreenState();
}

class _GoalsScreenState extends State<GoalsScreen> {
  final dbHelper = DatabaseHelper.instance;
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final dueDateController = TextEditingController();

  List<Map<String, dynamic>> goals = [];

  @override
  void initState() {
    super.initState();
    refreshGoals();
  }

  void refreshGoals() async {
    final data = await dbHelper.getData('goals');
    setState(() {
      goals = data;
    });
  }

  void addGoal() async {
    final title = titleController.text;
    final description = descriptionController.text;
    final dueDate = dueDateController.text;

    if (title.isNotEmpty && description.isNotEmpty && dueDate.isNotEmpty) {
      await dbHelper.insertData('goals', {
        'title': title,
        'description': description,
        'dueDate': dueDate,
        'completed': 0
      });
      refreshGoals();
      titleController.clear();
      descriptionController.clear();
      dueDateController.clear();
    }
  }

  void toggleComplete(int id, int currentStatus) async {
    await dbHelper.updateData(
        'goals', {'completed': currentStatus == 0 ? 1 : 0}, id);
    refreshGoals();
  }

  void deleteGoal(int id) async {
    await dbHelper.deleteData('goals', id);
    refreshGoals();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Цели')),
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
                TextField(
                  controller: dueDateController,
                  decoration: InputDecoration(labelText: 'Дата (YYYY-MM-DD)'),
                ),
                ElevatedButton(
                  child: Text('Добавить'),
                  onPressed: addGoal,
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: goals.length,
              itemBuilder: (context, index) {
                final goal = goals[index];
                return ListTile(
                  title: Text(goal['title']),
                  subtitle:
                      Text('${goal['description']}\nДо: ${goal['dueDate']}'),
                  leading: IconButton(
                    icon: Icon(goal['completed'] == 0
                        ? Icons.check_box_outline_blank
                        : Icons.check_box),
                    onPressed: () =>
                        toggleComplete(goal['id'], goal['completed']),
                  ),
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () => deleteGoal(goal['id']),
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
