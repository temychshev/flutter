import 'package:flutter/material.dart';
import 'package:flutter_application_1/database/database_helper.dart';

class ContactsScreen extends StatefulWidget {
  @override
  _ContactsScreenState createState() => _ContactsScreenState();
}

class _ContactsScreenState extends State<ContactsScreen> {
  final dbHelper = DatabaseHelper.instance;
  final nameController = TextEditingController();
  final phoneController = TextEditingController();

  List<Map<String, dynamic>> contacts = [];

  @override
  void initState() {
    super.initState();
    refreshContacts();
  }

  void refreshContacts() async {
    final data = await dbHelper.getData('contacts');
    setState(() {
      contacts = data;
    });
  }

  void addContact() async {
    final name = nameController.text;
    final phone = phoneController.text;

    if (name.isNotEmpty && RegExp(r'^\d+\$').hasMatch(phone)) {
      await dbHelper.insertData('contacts', {'name': name, 'phone': phone});
      refreshContacts();
      nameController.clear();
      phoneController.clear();
    }
  }

  void deleteContact(int id) async {
    await dbHelper.deleteData('contacts', id);
    refreshContacts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Контакты')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: nameController,
                    decoration: InputDecoration(labelText: 'Имя'),
                  ),
                ),
                SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: phoneController,
                    decoration: InputDecoration(labelText: 'Телефон'),
                    keyboardType: TextInputType.phone,
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: addContact,
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: contacts.length,
              itemBuilder: (context, index) {
                final contact = contacts[index];
                return ListTile(
                  title: Text(contact['name']),
                  subtitle: Text(contact['phone']),
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () => deleteContact(contact['id']),
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
