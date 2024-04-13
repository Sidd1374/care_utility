import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BatchWeightPage extends StatefulWidget {
  @override
  _BatchWeightPageState createState() => _BatchWeightPageState();
}

class _BatchWeightPageState extends State<BatchWeightPage> {
  String? selectedBatchNumber;
  TextEditingController netWeightController = TextEditingController();
  TextEditingController grossWeightController = TextEditingController();
  List<Map<String, dynamic>> batchNumbers = [];
  List<Map<String, dynamic>> tableData = [];

  @override
  void initState() {
    super.initState();
    fetchBatches();
  }

  Future<void> fetchBatches() async {
    try {
      CollectionReference batches = FirebaseFirestore.instance.collection('Care_utility_db/dual_air_dev/mgmt_record/batch_info/batches');
      // QuerySnapshot querySnapshot = await batches.orderBy('timestamp', descending: true).limit(5).get();
      QuerySnapshot querySnapshot = await batches.get();

      List<Map<String, dynamic>> numbers = [];
      for (var doc in querySnapshot.docs) {
        numbers.add({
          'batchNumber': doc.id,
        });
      }

      setState(() {
        // print(numbers);
        batchNumbers = numbers;
      });
    } catch (e) {
      print(e.toString());
    }
  }


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
            _buildTextInput(
                'Net Weight:', netWeightController, TextInputType.number),
            SizedBox(height: 10.h),
            _buildTextInput(
                'Gross Weight:', grossWeightController, TextInputType.number),
            SizedBox(height: 10.h),
            ElevatedButton(
              onPressed: () {
                submitData(selectedBatchNumber!, {
                  'netWeight': netWeightController.text,
                  'grossWeight': grossWeightController.text,
                });
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
    return DropdownButtonFormField<String>(
      value: selectedBatchNumber,
      items: batchNumbers.map((item) {
        return DropdownMenuItem<String>(
          value: item['batchNumber'],
          child: Text(item['batchNumber']),
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


  Widget _buildTextInput(String labelText, TextEditingController controller,
      TextInputType keyboardType) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: labelText,
        border: const OutlineInputBorder(),
      ),
    );
  }

  Widget _buildWeightTable() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(width: 80.h),
              const Flexible(
                fit: FlexFit.loose,
                child: Text(
                  'Weight Table',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(width: 70.h),
              IconButton(
                icon: Icon(Icons.refresh),
                onPressed: () {
                  refreshTableData();
                },
              ),
            ],
          ),
          DataTable(
            columns: const [
              DataColumn(label: Text('Index')), // Added DataColumn for Index
              DataColumn(label: Text('Net Weight')),
              DataColumn(label: Text('Gross Weight')),
            ],
            rows: tableData.map((row) => DataRow(
              cells: [
                DataCell(Text(row['index'])), // Display index here
                DataCell(Text(row['netWeight'])),
                DataCell(Text(row['grossWeight'])),
              ],
            )).toList(),
          ),
        ],
      ),
    );
  }


  Future<void> submitData(String batchNumber, Map<String, dynamic> data) async {
    try {
      // Get a reference to the weight sheet collection for the specified batch number
      CollectionReference weightSheetCollection = FirebaseFirestore.instance.collection('Care_utility_db/dual_air_dev/mgmt_record/records_data/batches/$batchNumber/weight_sheet');

      // Get the current count of entries in the weight sheet
      QuerySnapshot weightSheetSnapshot = await weightSheetCollection.get();
      int currentIndex = weightSheetSnapshot.docs.length + 1;

      // Create a new map entry with the current index as the key and netWeight and grossWeight as values
      Map<String, dynamic> newData = {
        'n_wght': data['netWeight'],
        'g_wght': data['grossWeight'],
      };

      // Set the data in the weight sheet collection with the current index as the document ID
      await weightSheetCollection.doc(currentIndex.toString()).set(newData);

      // Display data in the table
      setState(() {
        tableData.add({
          'index': currentIndex.toString(),
          'netWeight': data['netWeight'],
          'grossWeight': data['grossWeight'],
        });
      });
    } catch (e) {
      print(e.toString());
    }
  }


  Future<void> refreshTableData() async {
    try {
      // Get data from Firebase
      CollectionReference weightSheetCollection = FirebaseFirestore.instance
          .collection('Care_utility_db/dual_air_dev/mgmt_record/records_data/batches')
          .doc(selectedBatchNumber)
          .collection('weight_sheet');

      QuerySnapshot querySnapshot = await weightSheetCollection.get();

      // Update the table
      setState(() {
        tableData.clear();
        for (var docSnapshot in querySnapshot.docs) {
          var docData = docSnapshot.data();
          if (docData != null && docData is Map<String, dynamic>) {
            // Extract data from each document and add to tableData
            tableData.add({
              'index': docSnapshot.id,
              'netWeight': docData['n_wght'] as String,
              'grossWeight': docData['g_wght'] as String,
            });
          }
        }

      });
    } catch (e) {
      print(e.toString());
    }
  }



}