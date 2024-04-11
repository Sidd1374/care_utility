import 'package:flutter/material.dart';

class MaterialDispensingPage extends StatefulWidget {
  @override
  _MaterialDispensingPageState createState() => _MaterialDispensingPageState();
}

class _MaterialDispensingPageState extends State<MaterialDispensingPage> {
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

  List<Map<String, String>> dispensedList = [];

  @override
  void initState() {
    super.initState();
    initializeControllers();
  }

  void initializeControllers() {
    controllers = List.generate(
      materials.length,
      (index) => {
        'AR. No': TextEditingController(),
        'STD Qty': TextEditingController(),
        'Actual Qty': TextEditingController(),
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Material Dispensing'),
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
              _buildDispensedTable(),
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
              controller: controllers[index]['AR. No'],
              decoration: InputDecoration(labelText: 'AR. No'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: controllers[index]['STD Qty'],
              decoration: InputDecoration(labelText: 'STD Qty'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: controllers[index]['Actual Qty'],
              decoration: InputDecoration(labelText: 'Actual Qty'),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
      ),
    );
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

  Widget _buildSubmitButton() {
    return ElevatedButton(
      onPressed: () {
        _submitData();
      },
      child: Text('Submit'),
    );
  }

  Widget _buildDispensedTable() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columns: [
          DataColumn(label: Text('Material')),
          DataColumn(label: Text('AR. No')),
          DataColumn(label: Text('STD Qty')),
          DataColumn(label: Text('Actual Qty')),
        ],
        rows: List<DataRow>.generate(
          materials.length,
          (index) {
            return DataRow(
              cells: [
                DataCell(Text(materials[index])),
                DataCell(Text(controllers[index]['AR. No']?.text ?? '')),
                DataCell(Text(controllers[index]['STD Qty']?.text ?? '')),
                DataCell(Text(controllers[index]['Actual Qty']?.text ?? '')),
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
          String arNo = controllers[i]['AR. No']!.text;
          String stdQty = controllers[i]['STD Qty']!.text;
          String actualQty = controllers[i]['Actual Qty']!.text;

          dispensedList.add({
            'material': materials[i],
            'AR. No': arNo,
            'STD Qty': stdQty,
            'Actual Qty': actualQty,
          });
        }
      });
    }
  }
}
