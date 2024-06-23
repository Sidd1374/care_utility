import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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

  List<Map<String, String>> weightList = [];
  List<Map<String, dynamic>> batchNumbers = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    isLoading = true;
    initializeControllers();
    initializeWeightList();
    fetchBatches();
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
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Padding(
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
          ),
          if (isLoading)
            const Center(
              child: CircularProgressIndicator(),
            ),
        ],
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

  Widget _buildDropDownMenu() {
    return DropdownButtonFormField<String>(
      value: selectedOption,
      items: batchNumbers.map((batch) {
        return DropdownMenuItem<String>(
          value: batch['batchNumber'],
          child: Text(batch['batchNumber']),
        );
      }).toList(),
      onChanged: (String? newValue) {
        setState(() {
          selectedOption = newValue;
        });
      },
      decoration: const InputDecoration(
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
            TextField(
              controller: controllers[index]['qtyReceived'],
              decoration: const InputDecoration(labelText: 'Qty. Received'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: controllers[index]['fgReceived'],
              decoration: const InputDecoration(labelText: 'FG Received by Store'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: controllers[index]['totalRejection'],
              decoration: const InputDecoration(labelText: 'Total Rejection'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: controllers[index]['qcControlSample'],
              decoration: const InputDecoration(labelText: 'QC+ Control Sample'),
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
      child: const Text('Submit'),
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'Reconciliation Table',
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: () {
                _refreshTableData();
              },
            ),
          ],
        ),
        SingleChildScrollView(
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
                    DataCell(Text(weightList[index]['qtyUsed'] ?? '')),
                    DataCell(Text(weightList[index]['qtyReturned'] ?? '')),
                    DataCell(Text(weightList[index]['percentRejection'] ?? '')),
                  ],
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  void _submitData() async {
    if (selectedOption != null) {
      setState(() {
        isLoading = true;
      });
      try {
        CollectionReference reconciliationSheetRef = FirebaseFirestore.instance.collection(
          'Care_utility_db/dual_air_dev/mgmt_record/records_data/batches/$selectedOption/reconciliation_sheet',
        );

        for (int i = 0; i < materials.length; i++) {
          String qtyReceived = controllers[i]['qtyReceived']!.text;
          String fgReceived = controllers[i]['fgReceived']!.text;
          String totalRejection = controllers[i]['totalRejection']!.text;
          String qcControlSample = controllers[i]['qcControlSample']!.text;

          // Check if the strings are valid integers before parsing
          if (_isValidInteger(qtyReceived) &&
              _isValidInteger(fgReceived) &&
              _isValidInteger(totalRejection) &&
              _isValidInteger(qcControlSample)) {
            // Calculate the values
            int qtyUsed =
                int.parse(fgReceived) + int.parse(totalRejection) + int.parse(qcControlSample);
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
              'percentRejection': '${percentRejection.toStringAsFixed(2)}%', // to keep only two decimal places
            };

            // Upload the calculated data to Firestore
            await reconciliationSheetRef.doc(materials[i]).set({
              'qtyReceived': qtyReceived,
              'fgReceived': fgReceived,
              'totalRejection': totalRejection,
              'qcControlSample': qcControlSample,
              'qtyUsed': qtyUsed.toString(),
              'qtyReturned': qtyReturned.toString(),
              'percentRejection': '${percentRejection.toStringAsFixed(2)}%',
            });
          } else {
            // Handle the error
            // print('Invalid input');
          }
        }

        setState(() {
          isLoading = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Data submitted successfully!'),
            backgroundColor: Colors.green,
          ),
        );

        // Refresh the table after submitting data
        // _refreshTableData();
      } catch (e) {
        setState(() {
          isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to submit data. Error: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }



  bool _isValidInteger(String str) {
    return int.tryParse(str) != null;
  }

  Future<void> _refreshTableData() async {
    if (selectedOption != null) {
      setState(() {
        isLoading = true;
      });
      try {
        CollectionReference reconciliationSheetRef =
        FirebaseFirestore.instance.collection(
            'Care_utility_db/dual_air_dev/mgmt_record/records_data/batches/$selectedOption/reconciliation_sheet');

        QuerySnapshot querySnapshot = await reconciliationSheetRef.get();

        List<Map<String, String>> updatedWeightList = List.generate(
          materials.length,
              (index) => {
            'material': materials[index],
            'qtyReceived': '',
            'fgReceived': '',
            'totalRejection': '',
            'qcControlSample': '',
            'qtyUsed': '',
            'qtyReturned': '',
            'percentRejection': '',
          },
        );

        querySnapshot.docs.forEach((doc) {
          String material = doc.id;
          int index = materials.indexOf(material);
          if (index != -1) {
            setState(() {
              updatedWeightList[index] = {
                'material': material,
                'qtyReceived': doc['qtyReceived'] != null ? doc['qtyReceived'].toString() : '',
                'fgReceived': doc['fgReceived'] != null ? doc['fgReceived'].toString() : '',
                'totalRejection': doc['totalRejection'] != null ? doc['totalRejection'].toString() : '',
                'qcControlSample': doc['qcControlSample'] != null ? doc['qcControlSample'].toString() : '',
                'qtyUsed': doc['qtyUsed'] != null ? doc['qtyUsed'].toString() : '',
                'qtyReturned': doc['qtyReturned'] != null ? doc['qtyReturned'].toString() : '',
                'percentRejection': doc['percentRejection'] != null ? doc['percentRejection'].toString() : '',
              };
            });
          }
        });

        setState(() {
          weightList = updatedWeightList;
          isLoading = false;
        });
      } catch (e) {
        setState(() {
          isLoading = false;
        });
        // print('Error fetching data: $e');
      }
    } else {
      // print('No batch number selected');
    }
  }




  Future<void> fetchBatches() async {
    try {
      CollectionReference batches = FirebaseFirestore.instance.collection(
        'Care_utility_db/dual_air_dev/mgmt_record/batch_info/batches',
      );
      QuerySnapshot querySnapshot = await batches.get();

      List<Map<String, String>> numbers = [];
      for (var doc in querySnapshot.docs) {
        numbers.add({
          'batchNumber': doc.id,
        });
      }

      setState(() {
        batchNumbers = numbers;
        if (numbers.isNotEmpty) {
          selectedOption = numbers[0]['batchNumber']; // Set selectedOption to the first batch number
        }
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      // print(e.toString());
    }
  }

}
