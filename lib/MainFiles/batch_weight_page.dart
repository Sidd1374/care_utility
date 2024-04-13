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
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchBatches();
  }

  Future<void> fetchBatches() async {
    setState(() {
      isLoading = true; // Start loading indicator
    });
    try {
      CollectionReference batches =
      FirebaseFirestore.instance.collection('Care_utility_db/dual_air_dev/mgmt_record/batch_info/batches');
      QuerySnapshot querySnapshot = await batches.get();

      List<Map<String, dynamic>> numbers = [];
      for (var doc in querySnapshot.docs) {
        numbers.add({
          'batchNumber': doc.id,
        });
      }

      setState(() {
        batchNumbers = numbers;
        isLoading = false; // Stop loading indicator after fetching data
      });
    } catch (e) {
      setState(() {
        isLoading = false; // Stop loading indicator in case of error
      });
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
              onPressed: isLoading ? null : () {
                submitData(selectedBatchNumber!, {
                  'netWeight': netWeightController.text,
                  'grossWeight': grossWeightController.text,
                });
              },
              child: isLoading
                  ? SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
                  : Text('Submit'),
            ),
            SizedBox(height: 20.h),
            Visibility(
              visible: !isLoading, // Hide when loading
              child: _buildWeightTable(),
            ),
            Visibility(
              visible: isLoading, // Show only when loading
              child: Center(
                child: CircularProgressIndicator(), // Show loading indicator
              ),
            ),
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
                onPressed: isLoading ? null : refreshTableData, // Disable refresh button when loading
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
    setState(() {
      isLoading = true; // Start loading indicator
    });
    try {
      CollectionReference weightSheetCollection = FirebaseFirestore.instance
          .collection('Care_utility_db/dual_air_dev/mgmt_record/records_data/batches/$batchNumber/weight_sheet');

      QuerySnapshot weightSheetSnapshot = await weightSheetCollection.get();
      int currentIndex = weightSheetSnapshot.docs.length + 1;

      Map<String, dynamic> newData = {
        'n_wght': data['netWeight'],
        'g_wght': data['grossWeight'],
      };

      await weightSheetCollection.doc(currentIndex.toString()).set(newData);

      setState(() {
        tableData.add({
          'index': currentIndex.toString(),
          'netWeight': data['netWeight'],
          'grossWeight': data['grossWeight'],
        });
        isLoading = false; // Stop loading indicator after data submission
      });
    } catch (e) {
      setState(() {
        isLoading = false; // Stop loading indicator in case of error
      });
      print(e.toString());
    }
  }

  Future<void> refreshTableData() async {
    setState(() {
      isLoading = true; // Start loading indicator
    });
    try {
      CollectionReference weightSheetCollection = FirebaseFirestore.instance
          .collection('Care_utility_db/dual_air_dev/mgmt_record/records_data/batches/$selectedBatchNumber/weight_sheet');

      QuerySnapshot querySnapshot = await weightSheetCollection.get();

      setState(() {
        tableData.clear();
        for (var docSnapshot in querySnapshot.docs) {
          var docData = docSnapshot.data();
          if (docData != null && docData is Map<String, dynamic>) {
            tableData.add({
              'index': docSnapshot.id,
              'netWeight': docData['n_wght'] as String,
              'grossWeight': docData['g_wght'] as String,
            });
          }
        }
        isLoading = false; // Stop loading indicator after data refresh
      });
    } catch (e) {
      setState(() {
        isLoading = false; // Stop loading indicator in case of error
      });
      print(e.toString());
    }
  }
}
