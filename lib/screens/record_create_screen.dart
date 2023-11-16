import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../database_helper.dart';
import '../models/item.dart';

class RecordCreateScreen extends StatefulWidget {
  final Item? item;

  const RecordCreateScreen({super.key, this.item});

  @override
  State<RecordCreateScreen> createState() => _RecordCreateScreenState();
}

class _RecordCreateScreenState extends State<RecordCreateScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _publisherController = TextEditingController();
  final TextEditingController _authorController = TextEditingController();
  final TextEditingController _isbnController = TextEditingController();
  final TextEditingController _imageController = TextEditingController();
  final TextEditingController _reviewController = TextEditingController();

  String? _image;
  final ImagePicker picker = ImagePicker();

  Future getImage(ImageSource imageSource) async {
    final XFile? pickedFile = await picker.pickImage(source: imageSource);
    print('>>>>>pickedFile1: ${pickedFile?.path}');
    setState(() {
      _image = pickedFile?.path;
    });
  }

  @override
  Widget build(BuildContext context) {
    DatabaseHelper databaseHelper = Provider.of<DatabaseHelper>(context);
    Item? item = widget.item;
    if (item != null) {
      _titleController.text = item.title;
      _publisherController.text = item.publisher ?? '';
      _authorController.text = item.author ?? '';
      _isbnController.text = item.isbn ?? '';
      _image = _image ?? item.image;
      _reviewController.text = item.review;
    }
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {
                if (item == null) {
                  databaseHelper.addItem(
                    title: _titleController.text,
                    publisher: _publisherController.text,
                    author: _authorController.text,
                    isbn: _isbnController.text,
                    image: _image,
                    review: _reviewController.text,
                  );
                } else {
                  databaseHelper.updateItem(
                    id: item.id!,
                    title: _titleController.text,
                    publisher: _publisherController.text,
                    author: _authorController.text,
                    isbn: _isbnController.text,
                    image: _image,
                    review: _reviewController.text,
                  );
                }

                _titleController.clear();
                _publisherController.clear();
                _authorController.clear();
                _isbnController.clear();
                _imageController.clear();
                _reviewController.clear();

                Navigator.pushNamed(context, '/readingList');
              },
              icon: const Icon(Icons.check)),
          const SizedBox(width: 10),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
        child: ListView(
          children: [
            Center(
              child: Stack(
                children: [
                  _photoArea(),
                  SizedBox(
                    width: 300,
                    height: 300,
                    child: InkWell(
                      onTap: () {
                        _showPopup(context);
                      },
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            _bookInfoField(labelName: '제목', controllerName: _titleController),
            const SizedBox(height: 10),
            _bookInfoField(labelName: '지은이', controllerName: _authorController),
            const SizedBox(height: 10),
            _bookInfoField(
                labelName: '출판사', controllerName: _publisherController),
            const SizedBox(height: 10),
            _bookInfoField(labelName: 'ISBN', controllerName: _isbnController),
            const SizedBox(height: 30),
            SizedBox(
              height: 300,
              child: TextField(
                controller: _reviewController,
                textAlignVertical: TextAlignVertical.top,
                maxLines: null,
                expands: true,
                decoration: const InputDecoration(
                  hintText: '독서 기록을 남겨보아요~(●\'◡\'●)',
                  labelText: '메모',
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
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _photoArea() {
    if (_image != null) {
      return Container(
        width: 300,
        height: 300,
        child: Image.file(File(_image!)),
      );
    }
    return Container(
      width: 300,
      height: 300,
      color: Colors.grey,
    );
  }

  Widget _bookInfoField({required String labelName, controllerName}) {
    return TextField(
      controller: controllerName,
      decoration: InputDecoration(
        labelText: labelName,
        labelStyle: const TextStyle(color: Colors.black),
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey),
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey),
        ),
      ),
    );
  }

  void _showPopup(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('이미지 업로드'),
            actionsAlignment: MainAxisAlignment.spaceAround,
            actions: [
              Column(
                children: [
                  IconButton(
                    onPressed: () {
                      getImage(ImageSource.camera);
                      Navigator.of(context).pop();
                    },
                    icon: const Icon(Icons.camera_alt),
                    iconSize: 50,
                  ),
                  const Text('카메라'),
                ],
              ),
              Column(
                children: [
                  IconButton(
                    onPressed: () {
                      getImage(ImageSource.gallery);
                      Navigator.of(context).pop();
                    },
                    icon: const Icon(Icons.photo),
                    iconSize: 50,
                  ),
                  const Text('갤러리'),
                ],
              ),
            ],
          );
        });
  }
}
