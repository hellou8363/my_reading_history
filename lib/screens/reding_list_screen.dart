import 'dart:io';

import 'package:flutter/material.dart';
import 'package:my_reading_history/screens/record_detail_screen.dart';
import 'package:provider/provider.dart';

import '../database_helper.dart';
import '../models/item.dart';

class ReadingListScreen extends StatefulWidget {
  const ReadingListScreen({super.key});

  @override
  State<ReadingListScreen> createState() => _ReadingListScreenState();
}

class _ReadingListScreenState extends State<ReadingListScreen> {
  @override
  Widget build(BuildContext context) {
    DatabaseHelper databaseHelper = Provider.of<DatabaseHelper>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Reading History'),
        automaticallyImplyLeading: false,
      ),
      body: RefreshIndicator(
        onRefresh: _refreshData,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          child: Stack(
            children: [
              FutureBuilder<List<Map<String, dynamic>>>(
                future: databaseHelper.getItemList(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text('Error: ${snapshot.error}'),
                    );
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(
                      child: Text('아직 저장한 기록이 없어요~(┬┬﹏┬┬)'),
                    );
                  } else {
                    List<Map<String, dynamic>> itemList =
                        snapshot.data as List<Map<String, dynamic>>;
                    return ListView.separated(
                      itemBuilder: (context, index) =>
                          _recordItem(itemList[index]),
                      itemCount: itemList.length,
                      separatorBuilder: (BuildContext context, int index) {
                        return const SizedBox(height: 20);
                      },
                    );
                  }
                },
              ),
              Positioned(
                right: 20,
                bottom: 20,
                child: FloatingActionButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/recordCreate');
                    // Navigator.pop(context);
                  },
                  child: const Icon(Icons.add),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _refreshData() async {
    try {
      setState(() {});

      // 새로고침 완료를 알리기 위해 SnackBar 표시
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('새로고침 완료')),
      );
    } catch (error) {
      print('데이터 새로고침 중 에러 발생: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('새로고침 중 에러가 발생했습니다.')),
      );
    }
  }

  Item mapToItem(Map<String, dynamic> data) {
    return Item(
      id: data['id'],
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
    print('_recordItem called');

    Item item = mapToItem(inputData);
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => RecordDetailScreen(item: item),
          ),
        );
      },
      child: Container(
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
            item.image != null
                ? ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(10),
                      bottomLeft: Radius.circular(10),
                    ),
                    child: Image.file(
                      File(item.image!),
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                      scale: 0.1,
                    ),
                  )
                : Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(10),
                        bottomLeft: Radius.circular(10),
                      ),
                      color: Colors.grey[300],
                    ),
                  ),
            const SizedBox(width: 20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  item.author ?? '',
                ),
                const SizedBox(height: 5),
                Text(
                  '${item.createdDate.year}. ${item.createdDate.month}. ${item.createdDate.day}',
                ),
                const SizedBox(height: 5),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
