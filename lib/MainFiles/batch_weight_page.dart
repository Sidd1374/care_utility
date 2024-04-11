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
  List<Map<String, dynamic>> tableData = []; // Add this line

  @override
  void initState() {
    super.initState();
    fetchBatches();
  }

  // Future<void> fetchBatchNumbers() async {
  //   try {
  //     QuerySnapshot querySnapshot = await FirebaseFirestore.instance
  //         .collection('Care_utility_db')
  //         .doc('dual_air_dev')
  //         .collection('mgmt_record')
  //         .doc('batch_info')
  //         .collection('batches')
  //         .get();
  //
  //     List<Map<String, dynamic>> numbers = [];
  //     for (QueryDocumentSnapshot doc in querySnapshot.docs) {
  //       QuerySnapshot numberSnapshot = await doc.reference.collection('numbers')
  //           .get();
  //       for (QueryDocumentSnapshot numberDoc in numberSnapshot.docs) {
  //         numbers.add({'batchNumber': numberDoc['batch_number'] as String});
  //       }
  //     }
  //
  //     setState(() {
  //       print("got the data");
  //       print(numbers);
  //       batchNumbers = numbers;
  //     });
  //   } catch (e) {
  //     print("Error fetching batch numbers: $e");
  //     throw Exception('Failed to fetch batch numbers: $e');
  //   }
  // }

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
        print(numbers);
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
            mainAxisSize: MainAxisSize.min, // add this line
            children: [
              SizedBox(width: 80.h),

              const Flexible( // replace Expanded with Flexible
                fit: FlexFit.loose, // add this line
                child:
                Text(
                  'Weight Table',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(width: 70.h), // Add this line to add space
              IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: () {
                  refreshTableData();
                },
              ),
            ],
          ),
          DataTable(
            columns: const [
              DataColumn(label: Text('Sr Number')),
              DataColumn(label: Text('Net Weight')),
              DataColumn(label: Text('Gross Weight')),
            ],
            rows: tableData.map((row) => DataRow(
              cells: [
                DataCell(Text(row['batchNumber'])),
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
      // Add data to Firebase
      CollectionReference records = FirebaseFirestore.instance.collection('Care_utility_db/dual_air_dev/mgmt_record/records_data/weight_sheet/data');
      await records.doc(batchNumber).set(data);

      // Display data in the table
      setState(() {
        tableData.add(data);
      });
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> refreshTableData() async {
    try {
      // Get data from Firebase
      DocumentReference docRef = FirebaseFirestore.instance.collection('Care_utility_db/dual_air_dev/mgmt_record/records_data/weight_sheet/data').doc(selectedBatchNumber);
      DocumentSnapshot docSnapshot = await docRef.get();

      // Update the table
      setState(() {
        tableData.clear();
        var docData = docSnapshot.data();
        if (docData is Map<String, dynamic>) {
          tableData = [docData];
        } else {
          print('Invalid data format: $docData');
        }
      });
    } catch (e) {
      print(e.toString());
    }
  }


}