import 'package:flutter/material.dart';

class MaterialReconciliationPage extends StatefulWidget {
  @override
  _MaterialReconciliationPageState createState() =>
      _MaterialReconciliationPageState();
}

class _MaterialReconciliationPageState
    extends State<MaterialReconciliationPage> {
  String? selectedOption;
  late TextEditingController optionController;
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
    selectedOption = '';
    optionController = TextEditingController();
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
        'qtyUsed': TextEditingController(),
        'qtyReturned': TextEditingController(),
        'percentageRejection': TextEditingController(),
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
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildDropDownMenu(),
            const SizedBox(height: 16.0),
            Column(
              children: _buildCards(),
            ),
            const SizedBox(height: 16.0),
            _buildSubmitButton(),
            const SizedBox(height: 16.0),
            _buildWeightTable(),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildCards() {
    List<Widget> cards = [];
    for (var material in materials) {
      cards.add(_buildCard(material));
      cards.add(const SizedBox(height: 16.0));
    }
    return cards;
  }

  Widget _buildCard(String material) {
    int index = materials.indexOf(material);
    return Card(
      elevation: 3.0,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              material,
              style: const TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16.0),
            _buildTextField(index, 'qtyReceived', 'Qty. Received'),
            const SizedBox(height: 16.0),
            _buildTextField(index, 'fgReceived', 'FG Received by Store'),
            const SizedBox(height: 16.0),
            _buildTextField(index, 'totalRejection', 'Total Rejection'),
            const SizedBox(height: 16.0),
            _buildTextField(index, 'qcControlSample', 'QC+ Control Sample'),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(int index, String key, String labelText) {
    return TextField(
      controller: controllers[index][key],
      decoration: InputDecoration(labelText: labelText),
      keyboardType: TextInputType.number,
    );
  }

  Widget _buildDropDownMenu() {
    return DropdownButtonFormField<String>(
      value: selectedOption,
      decoration: InputDecoration(
        labelText: 'Select Option',
        border: OutlineInputBorder(),
      ),
      items: [
        DropdownMenuItem(child: Text('Option 1'), value: 'option1'),
        DropdownMenuItem(child: Text('Option 2'), value: 'option2'),
      ],
      onChanged: (value) {
        setState(() {
          selectedOption = value!;
          optionController.text = selectedOption!;
        });
      },
    );
  }

  Widget _buildSubmitButton() {
    return ElevatedButton(
      onPressed: _submitData,
      child: const Text('Submit'),
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

          // Update calculated values
          controllers[i]['qtyUsed']!.text = qtyUsed.toStringAsFixed(2);
          controllers[i]['qtyReturned']!.text = qtyReturned.toStringAsFixed(2);
          controllers[i]['percentageRejection']!.text = percentageRejection.toStringAsFixed(2);
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

  Widget _buildWeightTable() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columns: [
          DataColumn(label: const Text('Material')),
          DataColumn(label: const Text('Qty. Received')),
          DataColumn(label: const Text('FG Received by Store')),
          DataColumn(label: const Text('Total Rejection')),
          DataColumn(label: const Text('QC+ Control Sample')),
          DataColumn(label: const Text('Qty. Used')),
          DataColumn(label: const Text('Qty. Returned')),
          DataColumn(label: const Text('% Rejection')),
        ],
        rows: List<DataRow>.generate(
          materials.length,
              (index) {
            String qtyReceived = controllers[index]['qtyReceived']?.text ?? '';
            String fgReceived = controllers[index]['fgReceived']?.text ?? '';
            String totalRejection = controllers[index]['totalRejection']?.text ?? '';
            String qcControlSample = controllers[index]['qcControlSample']?.text ?? '';
            String qtyUsed = controllers[index]['qtyUsed']?.text ?? '';
            String qtyReturned = controllers[index]['qtyReturned']?.text ?? '';
            String percentageRejection = controllers[index]['percentageRejection']?.text ?? '';

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
}
