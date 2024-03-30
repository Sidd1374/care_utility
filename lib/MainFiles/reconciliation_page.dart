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
          materials.length,
              (index) {
            return DataRow(
              cells: [
                DataCell(Text(materials[index])),
                DataCell(Text(controllers[index]['qtyReceived']?.text ?? '')),
                DataCell(Text(controllers[index]['fgReceived']?.text ?? '')),
                DataCell(Text(controllers[index]['totalRejection']?.text ?? '')),
                DataCell(Text(controllers[index]['qcControlSample']?.text ?? '')),
                DataCell(Text('')), // Qty. Used
                DataCell(Text('')), // Qty. Returned
                DataCell(Text('')), // % Rejection
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

          weightList.add({
            'material': materials[i],
            'qtyReceived': qtyReceived,
            'fgReceived': fgReceived,
            'totalRejection': totalRejection,
            'qcControlSample': qcControlSample,
          });
        }
      });
    }
  }

}
