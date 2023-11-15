import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../database_helper.dart';
import '../models/record.dart';

class ReadingListScreen extends StatefulWidget {
  const ReadingListScreen({super.key});

  @override
  State<ReadingListScreen> createState() => _ReadingListScreenState();
}

class _ReadingListScreenState extends State<ReadingListScreen> {
  @override
  Widget build(BuildContext context) {
    DatabaseHelper databaseHelper = Provider.of<DatabaseHelper>(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
      child: Stack(
        children: [
          FutureBuilder<List<Map<String, dynamic>>>(
            future: databaseHelper.getItemList(),
            builder: (context, snapshot) {
              if (snapshot.hasData && snapshot.data != null) {
                List<Map<String, dynamic>> itemList =
                    snapshot.data as List<Map<String, dynamic>>;
                return ListView.separated(
                  itemBuilder: (context, index) => _recordItem(itemList[index]),
                  itemCount: itemList.length,
                  separatorBuilder: (BuildContext context, int index) {
                    return const SizedBox(height: 20);
                  },
                );
              } else {
                return const CircularProgressIndicator();
              }
            },
          ),
          Positioned(
            right: 20,
            bottom: 20,
            child: FloatingActionButton(
              onPressed: () {
                Navigator.pushNamed(context, '/recordCreate');
              },
              child: const Icon(Icons.add),
            ),
          ),
        ],
      ),
    );
  }

  Record mapToRecord(Map<String, dynamic> data) {
    return Record(
      title: data['title'] ?? '',
      publisher: data['publisher'],
      author: data['author'],
      isbn: data['isbn'],
      image: data['image'],
      review: data['review'] ?? '',
      createdDate: DateTime.parse(data['createdDate'] ?? ''),
    );
  }

  Widget _recordItem(Map<String, dynamic> inputData) {
    Record record = mapToRecord(inputData);
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: const [
          BoxShadow(
            color: Colors.black,
            spreadRadius: 0,
            blurRadius: 0,
            offset: Offset(0, 0),
          ),
        ],
      ),
      child: Row(
        children: [
          Stack(
            children: [
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(10),
                    bottomLeft: Radius.circular(10),
                  ),
                  color: Colors.grey[300],
                ),
              ),
              if (record.image != null)
                Image.memory(
                  base64Decode(record.image!),
                  width: 120,
                  height: 120,
                  fit: BoxFit.cover,
                ),
            ],
          ),
          const SizedBox(width: 20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                record.title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                record.author ?? '',
              ),
              const SizedBox(height: 5),
              Text(
                '${record.createdDate.year}. ${record.createdDate.month}. ${record.createdDate.day}',
              ),
              const SizedBox(height: 5),
            ],
          ),
        ],
      ),
    );
  }
}
