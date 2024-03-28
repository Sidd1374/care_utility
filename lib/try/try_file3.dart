import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class BatchListPage extends StatefulWidget {
  @override
  _BatchListPageState createState() => _BatchListPageState();
}

class _BatchListPageState extends State<BatchListPage> {
  List<String> batchNumbers = [];

  @override
  void initState() {
    super.initState();
    _getLatestBatchNumbers();
  }

  Future<void> _getLatestBatchNumbers() async {
    try {
      // Get the directory where the file is stored
      Directory directory = await getApplicationDocumentsDirectory();
      File file = File('${directory.path}/batch_numbers.txt');

      if (await file.exists()) {
        // Read file contents
        List<String> lines = await file.readAsLines();

        // Extract batch numbers
        batchNumbers = lines.sublist(lines.length - 5).reversed.toList();

        setState(() {}); // Update UI
      } else {
        print('File not found!');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Latest 5 Batch Numbers'),
      ),
      body: ListView.builder(
        itemCount: batchNumbers.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(batchNumbers[index]),
          );
        },
      ),
    );
  }
}
