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
    return DropdownButtonFormField<String>(
      value: selectedBatchNumber,
      items: ['Batch 1', 'Batch 2', 'Batch 3'].map((String batch) {
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
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: FittedBox(
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
    );
  }

}
