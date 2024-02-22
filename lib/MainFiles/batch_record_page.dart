import 'package:flutter/material.dart';

class BatchRecordPage extends StatefulWidget {
  @override
  _BatchRecordPageState createState() => _BatchRecordPageState();
}

class _BatchRecordPageState extends State<BatchRecordPage> {
  TextEditingController batchNumberController = TextEditingController();
  TextEditingController commencementDateController = TextEditingController();
  TextEditingController completionDateController = TextEditingController();

  bool completionDateSameAsCommencement = false;

  String selectedShiftOption = '';
  String selectedLineOption = '';

  Future<void> _selectCommencementDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (picked != null) {
      setState(() {
        commencementDateController.text = picked.toString().split(' ')[0];
      });
    }
  }

  Future<void> _selectCompletionDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (picked != null) {
      setState(() {
        completionDateController.text = picked.toString().split(' ')[0];
      });
    }
  }

  @override
  void initState() {
    super.initState();
    completionDateSameAsCommencement = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Batch Management Record'),
      ),
      body: Container(
        width: 411,
        height: 890,
        color: const Color.fromRGBO(255, 255, 255, 1),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              _buildHeaderText('Enter Data'),
              _buildTextInput('Batch Number:', batchNumberController),
              _buildDateInput('Date of Commencement:', commencementDateController, _selectCommencementDate),
              _buildDateInput('Date of Completion:', completionDateController, _selectCompletionDate),
              _buildCheckBoxButton('Completion date same as commencement', completionDateSameAsCommencement, () {
                setState(() {
                  completionDateSameAsCommencement = !completionDateSameAsCommencement;
                });
              }),
              _buildHeaderText('Shift:'),
              _buildOptionsRow(['A', 'B', 'C'], selectedShiftOption, (option) {
                setState(() {
                  selectedShiftOption = option;
                });
              }),

              _buildHeaderText('Line No:'),
              _buildOptionsRow(['1', '2', '3'], selectedLineOption, (option) {
                setState(() {
                  selectedLineOption = option;
                });
              }),

              _buildSubmitButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderText(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Text(
        text,
        style: const TextStyle(
          color: Color.fromRGBO(0, 0, 0, 1),
          fontFamily: 'Inter',
          fontSize: 26,
          letterSpacing: 0,
          fontWeight: FontWeight.normal,
          height: 1,
        ),
      ),
    );
  }

  Widget _buildTextInput(String labelText, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: labelText,
          contentPadding: EdgeInsets.all(10),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
      ),
    );
  }

  Widget _buildDateInput(String labelText, TextEditingController controller, Function(BuildContext) onSelect) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: labelText,
          contentPadding: const EdgeInsets.all(10),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          suffixIcon: IconButton(
            icon: const Icon(Icons.calendar_today),
            onPressed: () => onSelect(context),
          ),
        ),
      ),
    );
  }

  Widget _buildSelectableButton(String label, String value, bool isSelected, ValueChanged<String> onChanged) {
    return Row(
      children: [
        Radio(
          value: value,
          groupValue: isSelected ? value : null,
          onChanged: (String? newValue) {
            onChanged(newValue!);
          },
        ),
        Text(label),
      ],
    );
  }

  Widget _buildOptionsRow(List<String> options, String selectedOption, ValueChanged<String> onOptionChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: options.map((option) {
          return _buildSelectableButton(option, option, selectedOption == option, (newValue) {
            onOptionChanged(newValue);
          });
        }).toList(),
      ),
    );
  }


  Widget _buildCheckBoxButton(String label, bool isChecked, VoidCallback onPressed) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        InkWell(
          onTap: () {
            if (!completionDateSameAsCommencement) {
              completionDateController.text = commencementDateController.text;
            }
            onPressed();
          },
          child: Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black),
              borderRadius: BorderRadius.circular(5),
              color: isChecked ? Colors.blue : Colors.white,
            ),
            child: isChecked
                ? const Icon(
              Icons.check,
              color: Colors.white,
            )
                : null,
          ),
        ),
        const SizedBox(width: 10),
        Text(label),
      ],
    );
  }

  Widget _buildSubmitButton() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: ElevatedButton(
        onPressed: () {
          print('Submit button pressed');
          print('Batch Number: ${batchNumberController.text}');
          print('Date of Commencement: ${commencementDateController.text}');
          print('Date of Completion: ${completionDateController.text}');
          print('Completion date same as commencement: $completionDateSameAsCommencement');
          print('Selected Shift: $selectedShiftOption');
          print('Selected Line: $selectedLineOption');
        },
        child: const Text('Submit'),
      ),
    );
  }
}