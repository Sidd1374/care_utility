import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BatchWeightPage extends StatefulWidget {
  @override
  _BatchWeightPageState createState() => _BatchWeightPageState();
}

class _BatchWeightPageState extends State<BatchWeightPage> {
  String? selectedBatchNumber;
  TextEditingController netWeightController = TextEditingController();
  TextEditingController grossWeightController = TextEditingController();
  List<Map<String, dynamic>> weightList = [];

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Batch Weight Page'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.w),
        child: ListView(
          children: [
            _buildBatchNumberDropdown(),
            SizedBox(height: 10.h),
            _buildTextInput('Net Weight:', netWeightController, TextInputType.number),
            SizedBox(height: 10.h),
            _buildTextInput('Gross Weight:', grossWeightController, TextInputType.number),
            SizedBox(height: 10.h),
            ElevatedButton(
              onPressed: () {
                _submitData();
              },
              child: Text('Submit'),
            ),
            SizedBox(height: 20.h),
            _buildWeightTable(),
          ],
        ),
      ),
    );
  }

  Widget _buildBatchNumberDropdown() {
    return FutureBuilder<QuerySnapshot>(
      future: fetchLatestBatches(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Text('No batches available.');
        } else {
          List<String> batchNumbers = snapshot.data!.docs.map((doc) => doc['batchNumber'] as String).toList();
          return DropdownButtonFormField<String>(
            value: selectedBatchNumber,
            items: batchNumbers.map((batch) {
              return DropdownMenuItem<String>(
                value: batch,
                child: Text(batch),
              );
            }).toList(),
            onChanged: (String? newValue) {
              setState(() {
                selectedBatchNumber = newValue;
              });
            },
            decoration: const InputDecoration(
              labelText: 'Select Batch Number',
              border: OutlineInputBorder(),
            ),
          );
        }
      },
    );
  }

  Future<QuerySnapshot> fetchLatestBatches() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('Care_utility_db')
          .doc('dual_air_dev')
          .collection('mgmt_record')
          .doc('batch_info')
          .collection('batch_list')
          .orderBy(FieldPath.documentId, descending: true)
          .limit(5)
          .get();
      return querySnapshot;
    } catch (e) {
      throw Exception('Failed to fetch latest batches: $e');
    }
  }



  Widget _buildTextInput(String labelText, TextEditingController controller, TextInputType keyboardType) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: labelText,
        border: OutlineInputBorder(),
      ),
    );
  }

  void _submitData() {
    if (selectedBatchNumber != null &&
        netWeightController.text.isNotEmpty &&
        grossWeightController.text.isNotEmpty) {
      setState(() {
        String netWeight = netWeightController.text;
        String grossWeight = grossWeightController.text;

        weightList ??= [];

        weightList.add({
          'batch': selectedBatchNumber!,
          'netWeight': netWeight,
          'grossWeight': grossWeight,
        });

        netWeightController.clear();
        grossWeightController.clear();
      });
    }
  }
  Widget _buildWeightTable() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(height: 10.h), // Add spacing between the button and the label
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(height: 10.h),
            Text(
              'Weights',
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            IconButton(
              onPressed: () {
                // Add refresh logic here
              },
              icon: const Icon(Icons.refresh),
              tooltip: 'Refresh',
            ),
          ],
        ),
        SizedBox(height: 10.h), // Add spacing between the label and the table
        SizedBox(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: SingleChildScrollView(
              child: DataTable(
                columns: const [
                  DataColumn(label: Text('Sr Number')),
                  DataColumn(label: Text('Net Weight')),
                  DataColumn(label: Text('Gross Weight')),
                ],
                rows: List<DataRow>.generate(
                  weightList.length,
                      (index) => DataRow(
                    cells: [
                      DataCell(Text('${index + 1}')),
                      DataCell(Text(weightList[index]['netWeight'].toString())),
                      DataCell(Text(weightList[index]['grossWeight'].toString())),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }


}
