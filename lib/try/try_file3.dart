import 'package:flutter/material.dart';

class MaterialReconciliationPage extends StatefulWidget {
  @override
  _MaterialReconciliationPageState createState() =>
      _MaterialReconciliationPageState();
}

class _MaterialReconciliationPageState
    extends State<MaterialReconciliationPage> {
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
        'qtyUsed': TextEditingController(), // Added for Qty Used
        'qtyReturned': TextEditingController(), // Added for Qty Returned
        'percentageRejection': TextEditingController(), // Added for % Rejection
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
        columns: [
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
            // Retrieve values from controllers or provide default empty string
            String qtyReceived = controllers[index]['qtyReceived']?.text ?? '';
            String fgReceived = controllers[index]['fgReceived']?.text ?? '';
            String totalRejection =
                controllers[index]['totalRejection']?.text ?? '';
            String qcControlSample =
                controllers[index]['qcControlSample']?.text ?? '';
            String qtyUsed = controllers[index]['qtyUsed']?.text ?? '';
            String qtyReturned = controllers[index]['qtyReturned']?.text ?? '';
            String percentageRejection =
                controllers[index]['percentageRejection']?.text ?? '';

            return DataRow(
              cells: [
                DataCell(Text(materials[index])),
                DataCell(Text(qtyReceived)),
                DataCell(Text(fgReceived)),
                DataCell(Text(totalRejection)),
                DataCell(Text(qcControlSample)),
                DataCell(Text(qtyUsed)),
                DataCell(Text(qtyReturned)),
                DataCell(Text(percentageRejection)),
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
          String totalRejection = controllers[i]['totalRejection']!.text;
          String qcControlSample = controllers[i]['qcControlSample']!.text;

          double qtyUsed = _calculateQtyUsed(qtyReceived, totalRejection, qcControlSample);
          double qtyReturned = _calculateQtyReturned(qtyReceived, qtyUsed);
          double percentageRejection = _calculatePercentageRejection(totalRejection, qtyUsed);

          // Perform null check before accessing text property
          if (controllers[i]['qtyUsed'] != null &&
              controllers[i]['qtyReturned'] != null &&
              controllers[i]['percentageRejection'] != null) {
            controllers[i]['qtyUsed']!.text = qtyUsed.toStringAsFixed(2);
            controllers[i]['qtyReturned']!.text = qtyReturned.toStringAsFixed(2);
            controllers[i]['percentageRejection']!.text = percentageRejection.toStringAsFixed(2);
          }
        }
      });
    }
  }






  double _calculateQtyUsed(String qtyReceived, String totalRejection, String qcControlSample) {
    double a = double.parse(qtyReceived);
    double b = double.parse(totalRejection);
    double c = double.parse(qcControlSample);
    return a + b + c;
  }

  double _calculateQtyReturned(String qtyReceived, double qtyUsed) {
    double A = double.parse(qtyReceived);
    return A - qtyUsed;
  }

  double _calculatePercentageRejection(String totalRejection, double qtyUsed) {
    double b = double.parse(totalRejection);
    return (b * 100) / qtyUsed;
  }



  @override
  void dispose() {
    // Dispose of the TextEditingController instances to avoid memory leaks
    controllers.forEach((map) {
      map.forEach((key, controller) {
        controller.dispose();
      });
    });
    super.dispose();
  }
}
