import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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

  final List<String> mat_desc = [
    'CTR/UPH/2024',
    'CTR/LOH/2024',
    'CTR/PLD/2024',
    'CTR/ADR/2024',
    'CTR/SLB/2024',
    'CTR/ESA/2024',
    'CTR/PLB/2024',
    'CTR/DA-S/2024',
    'CTR/TPT/2024',
  ];

  List<Map<String, String>> dispensedList = [];
  List<Map<String, dynamic>> batchNumbers = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchBatches();
    initializeControllers();
  }

  // Fetch batch numbers from Firestore
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

  // Initialize text controllers
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
              Visibility(
                visible: !isLoading, // Hide when loading
                child: Column(
                  children: [
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
              Visibility(
                visible: isLoading, // Show only when loading
                child: Center(
                  child: CircularProgressIndicator(), // Show loading indicator
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Build dropdown menu with batch numbers
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
        labelText: 'Select Batch Number',
        border: OutlineInputBorder(),
      ),
    );
  }

  // Build cards for materials
  List<Widget> _buildCards() {
    List<Widget> cards = [];
    for (var i = 0; i < materials.length; i++) {
      cards.add(_buildCard(materials[i], mat_desc[i]));
      cards.add(const SizedBox(height: 16.0));
    }
    return cards;
  }

  // Build a card for a material
  Widget _buildCard(String material, String desc) {
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
            const SizedBox(height: 8.0),
            TextField(
              controller: controllers[index]['AR. No'],
              decoration: InputDecoration(labelText: 'AR. No ($desc)'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16.0),
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

  // Build submit button with loading indicator
  Widget _buildSubmitButton() {
    return ElevatedButton(
      onPressed: isLoading ? null : _submitData, // Disable button when loading
      child: isLoading
          ? SizedBox(
        width: 24,
        height: 24,
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
        ),
      )
          : Text('Submit'),
    );
  }

  // Build dispensed material table
  Widget _buildDispensedTable() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(width: 50.h),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'Dispensed Materials',
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            IconButton(
              icon: Icon(Icons.refresh),
              onPressed: isLoading ? null : _refreshTableData, // Disable refresh button when loading
            ),
          ],
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            columns: const [
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
        ),
      ],
    );
  }

  // Submit data
  void _submitData() async {
    if (selectedOption != null) {
      setState(() {
        isLoading = true; // Start loading indicator
      });
      try {
        CollectionReference dispensingSheetRef = FirebaseFirestore.instance
            .collection('Care_utility_db/dual_air_dev/mgmt_record/records_data/batches/$selectedOption/dispensing_sheet');

        for (int i = 0; i < materials.length; i++) {
          String material = materials[i];
          String arNo = controllers[i]['AR. No']!.text;
          String stdQty = controllers[i]['STD Qty']!.text;
          String actualQty = controllers[i]['Actual Qty']!.text;

          DocumentSnapshot materialDoc = await dispensingSheetRef.doc(material).get();

          if (materialDoc.exists) {
            await dispensingSheetRef.doc(material).update({
              'AR No': arNo,
              'STD Qty': stdQty,
              'Actual Qty': actualQty,
            });
          } else {
            await dispensingSheetRef.doc(material).set({
              'AR No': arNo,
              'STD Qty': stdQty,
              'Actual Qty': actualQty,
            });
          }
        }

        setState(() {
          isLoading = false; // Stop loading indicator after data submission
        });

        dispensedList.clear();

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Data submitted successfully!'),
            backgroundColor: Colors.green,
          ),
        );
      } catch (e) {
        setState(() {
          isLoading = false; // Stop loading indicator in case of error
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

  // Refresh table data
  Future<void> _refreshTableData() async {
    if (selectedOption != null) {
      setState(() {
        isLoading = true; // Start loading indicator
      });
      try {
        CollectionReference dispensingSheetRef = FirebaseFirestore.instance
            .collection('Care_utility_db/dual_air_dev/mgmt_record/records_data/batches/$selectedOption/dispensing_sheet');

        QuerySnapshot querySnapshot = await dispensingSheetRef.get();

        List<Map<String, String>> updatedControllers = List.generate(
          materials.length,
              (index) => {
            'AR. No': '',
            'STD Qty': '',
            'Actual Qty': '',
          },
        );

        querySnapshot.docs.forEach((doc) {
          String material = doc.id;
          Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
          int index = materials.indexOf(material);
          if (index != -1) {
            setState(() {
              updatedControllers[index]['AR. No'] = data['AR No'] ?? '';
              updatedControllers[index]['STD Qty'] = data['STD Qty'] ?? '';
              updatedControllers[index]['Actual Qty'] = data['Actual Qty'] ?? '';
            });
          }
        });

        setState(() {
          controllers = updatedControllers.map((data) {
            return {
              'AR. No': TextEditingController(text: data['AR. No']),
              'STD Qty': TextEditingController(text: data['STD Qty']),
              'Actual Qty': TextEditingController(text: data['Actual Qty']),
            };
          }).toList();
          isLoading = false; // Stop loading indicator after data refresh
        });
      } catch (e) {
        setState(() {
          isLoading = false; // Stop loading indicator in case of error
        });
        print(e.toString());
      }
    } else {
      print('No batch number selected');
    }
  }
}
