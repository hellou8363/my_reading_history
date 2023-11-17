import 'dart:io';

import 'package:flutter/material.dart';
import 'package:my_reading_history/custom_bottom_navigation_bar.dart';
import 'package:my_reading_history/screens/record_create_screen.dart';
import 'package:provider/provider.dart';

import '../database_helper.dart';
import '../models/item.dart';

class RecordDetailScreen extends StatelessWidget {
  final Item item;

  const RecordDetailScreen({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => RecordCreateScreen(item: item),
                ),
              );
            },
            icon: const Icon(Icons.edit),
          ),
          const SizedBox(width: 10),
          IconButton(
              onPressed: () {
                confirmDelete(context, item.id!);
              },
              icon: const Icon(Icons.delete)),
          const SizedBox(width: 10),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
        child: ListView(
          children: [
            Center(
              child: Column(
                children: [
                  item.image != null
                      ? ClipRRect(
                          borderRadius: const BorderRadius.all(
                            Radius.circular(10),
                          ),
                          child: Image.file(
                            File(item.image!),
                            width: 300,
                            height: 300,
                            fit: BoxFit.cover,
                            scale: 0.1,
                          ),
                        )
                      : Container(
                          width: 300,
                          height: 300,
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.all(
                              Radius.circular(10),
                            ),
                            color: Colors.grey[300],
                          ),
                        ),
                  const SizedBox(height: 30),
                  Text(
                    item.title,
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    item.publisher ?? '',
                  ),
                  const SizedBox(height: 10),
                  Text(
                    item.author ?? '',
                  ),
                  const SizedBox(height: 10),
                  Text(
                    item.isbn.toString(),
                  ),
                  Text(
                    '${item.createdDate.year}. ${item.createdDate.month}. ${item.createdDate.day}',
                  ),
                  const SizedBox(height: 30),
                  SizedBox(
                    height: 300,
                    child: TextField(
                      readOnly: true,
                      controller: TextEditingController(text: item.review),
                      textAlignVertical: TextAlignVertical.top,
                      maxLines: null,
                      expands: true,
                      decoration: const InputDecoration(
                        labelStyle: TextStyle(color: Colors.black),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const CustomBottomNavigationBar(),
    );
  }

  Future<void> confirmDelete(BuildContext context, int itemId) async {
    DatabaseHelper databaseHelper =
        Provider.of<DatabaseHelper>(context, listen: false);

    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('삭제 확인'),
          content: const Text('삭제하시겠습니까?'),
          actions: [
            TextButton(
              child: const Text('취소'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('확인'),
              onPressed: () async {
                Navigator.of(context)
                    .popUntil(ModalRoute.withName('/readingList'));
                await databaseHelper.removeItem(itemId: itemId);
              },
            ),
          ],
        );
      },
    );
  }
}
