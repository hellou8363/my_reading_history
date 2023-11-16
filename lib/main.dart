import 'package:flutter/material.dart';
import 'package:my_reading_history/database_helper.dart';
import 'package:my_reading_history/screens/record_create_screen.dart';
import 'package:my_reading_history/screens/reding_list_screen.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => DatabaseHelper(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/readingList',
      routes: {
        '/readingList': (context) => ReadingListScreen(),
        '/recordCreate': (context) => RecordCreateScreen(),
      },
    );
  }
}
