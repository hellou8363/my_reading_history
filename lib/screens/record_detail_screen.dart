import 'dart:io';

import 'package:flutter/material.dart';

import '../models/item.dart';

class RecordDetailScreen extends StatelessWidget {
  final Item item;

  const RecordDetailScreen({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: const [
          Icon(Icons.edit),
          SizedBox(width: 20),
          Icon(Icons.delete),
          SizedBox(width: 20),
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
    );
  }
}
