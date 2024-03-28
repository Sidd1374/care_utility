import 'package:flutter/material.dart';

class MaterialDespensingPage extends StatefulWidget {
  @override
  _MaterialDespensingPageState createState() => _MaterialDespensingPageState();
}

class _MaterialDespensingPageState extends State<MaterialDespensingPage> {
  List<String> labels = [
    'Upper Housing',
    'Lower Housing',
    'Plug Deck',
    'Adjust Ring',
    'Slide Button',
    'ESA',
    'Polybag',
    'Corrugated box & Tape',
  ];

  Map<String, List<TextEditingController>> textControllers = {};

  @override
  void initState() {
    super.initState();
    labels.forEach((label) {
      textControllers[label] = [
        TextEditingController(),
        TextEditingController(),
        TextEditingController(),
      ];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Material Despensing (RM/PM)'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: labels
              .map(
                (label) => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    label,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                ...textControllers[label]!.map((controller) => Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: controller,
                    decoration: InputDecoration(labelText: 'AR No., STD QTY, Actual Qty'),
                  ),
                )),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        textControllers[label]!.add(TextEditingController());
                        textControllers[label]!.add(TextEditingController());
                        textControllers[label]!.add(TextEditingController());
                      });
                    },
                    child: Icon(Icons.add),
                  ),
                ),
              ],
            ),
          )
              .toList(),
        ),
      ),
    );
  }
}

