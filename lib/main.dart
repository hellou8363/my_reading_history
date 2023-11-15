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
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "My Reading History",
      home: SafeArea(
        child: Scaffold(
          body: IndexedStack(
            index: _selectedIndex,
            children: const [
              ReadingListScreen(),
              RecordCreateScreen(),
            ],
          ),
          bottomNavigationBar: BottomNavigationBar(
            items: const [
              BottomNavigationBarItem(
                label: '독서록 조회',
                icon: Icon(Icons.list),
              ),
              BottomNavigationBarItem(
                label: '독서록 등록',
                icon: Icon(Icons.create),
              ),
            ],
            onTap: (index) {
              setState(
                () {
                  _selectedIndex = index;
                },
              );
            },
            currentIndex: _selectedIndex,
          ),
        ),
      ),
    );
  }
}
