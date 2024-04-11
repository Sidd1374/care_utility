import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MaterialReconciliationPage extends StatefulWidget {
  @override
  _MaterialReconciliationPageState createState() =>
      _MaterialReconciliationPageState();
}

class _MaterialReconciliationPageState extends State<MaterialReconciliationPage> {
  String? selectedOption;
  late List<Map<String, TextEditingController>> controllers;
  final List<String> materials = [
    'Upper Housing',
    'Lower Housing',
    'Plug Deck',
    'Adjust Ring',
    'Slide Button',
    'ESA',
    'Polybag',
    'Corrugated Box',
    'Tape',
  ];

  List<Map<String, String>> weightList = [];

  @override
  void initState() {
    super.initState();
    initializeControllers();
    initializeWeightList();
  }

  void initializeControllers() {
    controllers = List.generate(
      materials.length,
          (index) => {
        'qtyReceived': TextEditingController(),
        'fgReceived': TextEditingController(),
        'totalRejection': TextEditingController(),
        'qcControlSample': TextEditingController(),
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reconciliation of Material'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildDropDownMenu(),
              SizedBox(height: 16.0),
              Column(
                children: _buildCards(),
              ),
              SizedBox(height: 16.0),
              _buildSubmitButton(),
              SizedBox(height: 16.0),
              _buildWeightTable(),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildCards() {
    List<Widget> cards = [];
    for (var material in materials) {
      cards.add(_buildCard(material));
      cards.add(SizedBox(height: 16.0));
    }
    return cards;
  }

  Widget _buildDropDownMenu() {
    return DropdownButtonFormField<String>(
      value: selectedOption,
      items: [
        'Option 1',
        'Option 2',
        'Option 3',
      ].map((String option) {
        return DropdownMenuItem<String>(
          value: option,
          child: Text(option),
        );
      }).toList(),
      onChanged: (String? newValue) {
        setState(() {
          selectedOption = newValue;
        });
      },
      decoration: InputDecoration(
        labelText: 'Select Option',
        border: OutlineInputBorder(),
      ),
    );
  }

  Widget _buildCard(String material) {
    int index = materials.indexOf(material);
    return Card(
      elevation: 3.0,
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              material,
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: controllers[index]['qtyReceived'],
              decoration: InputDecoration(labelText: 'Qty. Received'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: controllers[index]['fgReceived'],
              decoration: InputDecoration(labelText: 'FG Received by Store'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: controllers[index]['totalRejection'],
              decoration: InputDecoration(labelText: 'Total Rejection'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: controllers[index]['qcControlSample'],
              decoration: InputDecoration(labelText: 'QC+ Control Sample'),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSubmitButton() {
    return ElevatedButton(
      onPressed: () {
        _submitData();
      },
      child: Text('Submit'),
    );
  }


  void initializeWeightList() {
    for (var material in materials) {
      weightList.add({
        'material': material,
        'qtyReceived': '',
        'fgReceived': '',
        'totalRejection': '',
        'qcControlSample': '',
        'qtyUsed': '', // Qty. Used
        'qtyReturned': '', // Qty. Returned
        'percentRejection': '', // % Rejection
      });
    }
  }

  Widget _buildWeightTable() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columns: const [
          DataColumn(label: Text('Material')),
          DataColumn(label: Text('Qty. Received')),
          DataColumn(label: Text('FG Received by Store')),
          DataColumn(label: Text('Total Rejection')),
          DataColumn(label: Text('QC+ Control Sample')),
          DataColumn(label: Text('Qty. Used')),
          DataColumn(label: Text('Qty. Returned')),
          DataColumn(label: Text('% Rejection')),
        ],
        rows: List<DataRow>.generate(
          weightList.length,
              (index) {
            return DataRow(
              cells: [
                DataCell(Text(weightList[index]['material'] ?? '')),
                DataCell(Text(weightList[index]['qtyReceived'] ?? '')),
                DataCell(Text(weightList[index]['fgReceived'] ?? '')),
                DataCell(Text(weightList[index]['totalRejection'] ?? '')),
                DataCell(Text(weightList[index]['qcControlSample'] ?? '')),
                DataCell(Text(weightList[index]['qtyUsed'] ?? '')), // Qty. Used
                DataCell(Text(weightList[index]['qtyReturned'] ?? '')), // Qty. Returned
                DataCell(Text(weightList[index]['percentRejection'] ?? '')), // % Rejection
              ],
            );
          },
        ),
      ),
    );
  }

  void _submitData() {
    if (selectedOption != null) {
      setState(() {
        for (int i = 0; i < materials.length; i++) {
          String qtyReceived = controllers[i]['qtyReceived']!.text;
          String fgReceived = controllers[i]['fgReceived']!.text;
          String totalRejection = controllers[i]['totalRejection']!.text;
          String qcControlSample = controllers[i]['qcControlSample']!.text;

          // Check if the strings are valid integers before parsing
          if (_isValidInteger(qtyReceived) && _isValidInteger(fgReceived) && _isValidInteger(totalRejection) && _isValidInteger(qcControlSample)) {
            // Calculate the values
            int qtyUsed = int.parse(fgReceived) + int.parse(totalRejection) + int.parse(qcControlSample);
            int qtyReturned = int.parse(qtyReceived) - qtyUsed;
            double percentRejection = (int.parse(totalRejection) * 100) / qtyUsed;

            // Update the existing entry in the weightList
            weightList[i] = {
              'material': materials[i],
              'qtyReceived': qtyReceived,
              'fgReceived': fgReceived,
              'totalRejection': totalRejection,
              'qcControlSample': qcControlSample,
              'qtyUsed': qtyUsed.toString(),
              'qtyReturned': qtyReturned.toString(),
              'percentRejection': percentRejection.toStringAsFixed(2) + '%', // to keep only two decimal places
            };
          } else {
            // Handle the error
            print('Invalid input');
          }
        }
      });
    }
  }

  bool _isValidInteger(String str) {
    return int.tryParse(str) != null;
  }

}
