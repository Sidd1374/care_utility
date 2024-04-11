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
      QuerySnapshot querySnapshot = await batches.get();

      List<Map<String, dynamic>> numbers = [];
      for (var doc in querySnapshot.docs) {
        numbers.add({
          'batchNumber': doc.id,
        });
      }

      setState(() {
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
            _buildTextInput('Net Weight:', netWeightController, TextInputType.number),
            SizedBox(height: 10.h),
            _buildTextInput('Gross Weight:', grossWeightController, TextInputType.number),
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
          value: item['batchNumber'] as String,
          child: Text(item['batchNumber'] as String),
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

  Widget _buildTextInput(String labelText, TextEditingController controller, TextInputType keyboardType) {
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
                DataCell(Text(row['batchNumber'] as String)),
                DataCell(Text(row['netWeight'] as String)),
                DataCell(Text(row['grossWeight'] as String)),
              ],
            )).toList(),
          ),
        ],
      ),
    );
  }

  Future<void> submitData(String batchNumber, Map<String, dynamic> data) async {
    try {
      CollectionReference records = FirebaseFirestore.instance.collection('Care_utility_db/dual_air_dev/mgmt_record/records_data/weight_sheet/data');
      DocumentReference batchDocRef = records.doc(batchNumber);
      QuerySnapshot batchSnapshot = await batchDocRef.collection('records').get();

      List<Map<String, dynamic>> existingData = batchSnapshot.docs.map<Map<String, dynamic>>((doc) => doc.data() as Map<String, dynamic>).toList();
      existingData.add(data);

      await batchDocRef.set({
        'records': existingData,
      });

      setState(() {
        tableData = existingData;
      });
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> refreshTableData() async {
    try {
      if (selectedBatchNumber != null) {
        CollectionReference records = FirebaseFirestore.instance.collection('Care_utility_db/dual_air_dev/mgmt_record/records_data/weight_sheet/data');
        QuerySnapshot batchSnapshot = await records.doc(selectedBatchNumber!).collection('records').get();

        setState(() {
          tableData = batchSnapshot.docs.map<Map<String, dynamic>>((doc) => doc.data() as Map<String, dynamic>).toList();
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }

}
