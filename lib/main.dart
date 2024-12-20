import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'screens/contacts_screen.dart';
import 'screens/reminders_screen.dart';
import 'screens/notes_screen.dart';
import 'screens/goals_screen.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeNotifications();
  runApp(MyApp());
}


Future<void> initializeNotifications() async {
  const AndroidInitializationSettings androidInit =
      AndroidInitializationSettings('@mipmap/ic_launcher');
  const InitializationSettings initSettings =
      InitializationSettings(android: androidInit);

  await flutterLocalNotificationsPlugin.initialize(initSettings);
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Improved App',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
      ),
      home: MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    ContactsScreen(),
    RemindersScreen(
      onReminderSet: (String title, String body) {
        scheduleNotification(title, body);
      },
    ),
    NotesScreen(),
    GoalsScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: _onItemTapped,
        destinations: const [
         NavigationDestination(
            icon: Icon(Icons.alarm),
            label: 'Напоминания',
          ),
         NavigationDestination(
            icon: Icon(Icons.flag),
            label: 'Цели',
          ),
          NavigationDestination(
            icon: Icon(Icons.note),
            label: 'Заметки',
          ),
          NavigationDestination(
            icon: Icon(Icons.contact_phone),
            label: 'Контакты',
          ),
        ],
      ),
    );
  }
}

Future<void> scheduleNotification(String title, String body) async {
  const AndroidNotificationDetails androidDetails =
      AndroidNotificationDetails(
    'reminder_channel',
    'Напоминания',
    importance: Importance.max,
    priority: Priority.high,
  );

  const NotificationDetails details =
      NotificationDetails(android: androidDetails);

  await flutterLocalNotificationsPlugin.show(
    0,
    title,
    body,
    details,
  );
}