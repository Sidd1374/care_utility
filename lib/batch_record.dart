import 'package:flutter/material.dart';

class BatchRecord extends StatefulWidget {
  @override
  _BatchRecordState createState() => _BatchRecordState();
}

class _BatchRecordState extends State<BatchRecord> {
  TextEditingController batchNumberController = TextEditingController();
  TextEditingController commencementDateController = TextEditingController();
  TextEditingController completionDateController = TextEditingController();

  bool completionDateSameAsCommencement = false;

  bool shiftOption1Selected = false;
  bool shiftOption2Selected = false;
  bool shiftOption3Selected = false;

  bool lineOption1Selected = false;
  bool lineOption2Selected = false;
  bool lineOption3Selected = false;

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
        title: Text('Batch Management Record'),
      ),
      body: Container(
        width: 411,
        height: 890,
        color: Color.fromRGBO(255, 255, 255, 1),
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
              _buildOptionsRow([
                _buildSelectableButton('A', shiftOption1Selected, () {
                  setState(() {
                    shiftOption1Selected = !shiftOption1Selected;
                  });
                }),
                _buildSelectableButton('B', shiftOption2Selected, () {
                  setState(() {
                    shiftOption2Selected = !shiftOption2Selected;
                  });
                }),
                _buildSelectableButton('C', shiftOption3Selected, () {
                  setState(() {
                    shiftOption3Selected = !shiftOption3Selected;
                  });
                }),
              ]),
              _buildHeaderText('Line No:'),
              _buildOptionsRow([
                _buildSelectableButton('1', lineOption1Selected, () {
                  setState(() {
                    lineOption1Selected = !lineOption1Selected;
                  });
                }),
                _buildSelectableButton('2', lineOption2Selected, () {
                  setState(() {
                    lineOption2Selected = !lineOption2Selected;
                  });
                }),
                _buildSelectableButton('3', lineOption3Selected, () {
                  setState(() {
                    lineOption3Selected = !lineOption3Selected;
                  });
                }),
              ]),
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
          contentPadding: EdgeInsets.all(10),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          suffixIcon: IconButton(
            icon: Icon(Icons.calendar_today),
            onPressed: () => onSelect(context),
          ),
        ),
      ),
    );
  }


  Widget _buildSelectableButton(String label, bool isSelected, VoidCallback onPressed) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: ElevatedButton(
        onPressed: onPressed,
        child: Text(label),
        style: ElevatedButton.styleFrom(
          primary: isSelected ? Colors.blue : Color.fromRGBO(217, 217, 217, 1),
        ),
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
              // If checkbox is checked, set completion date same as commencement date
              completionDateController.text = commencementDateController.text;
            }
            onPressed(); // Call the provided onPressed callback
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
                ? Icon(
              Icons.check,
              color: Colors.white,
            )
                : null,
          ),
        ),
        SizedBox(width: 10),
        Text(label),
      ],
    );
  }


  Widget _buildOptionsRow(List<Widget> options) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: options,
      ),
    );
  }

  Widget _buildSubmitButton() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: ElevatedButton(
         onPressed: () {
           printEnteredData();
          print('Submit button pressed');
        },
        child: Text('Submit'),
      ),
    );
  }

  void printEnteredData() {
    // Retrieve all entered data
    String batchNumber = batchNumberController.text;
    String commencementDate = commencementDateController.text;
    String completionDate = completionDateController.text;

    // Retrieve the selected shift options
    List<String> selectedShiftOptions = [];
    if (shiftOption1Selected) selectedShiftOptions.add('A');
    if (shiftOption2Selected) selectedShiftOptions.add('B');
    if (shiftOption3Selected) selectedShiftOptions.add('C');

    // Retrieve the selected line options
    List<String> selectedLineOptions = [];
    if (lineOption1Selected) selectedLineOptions.add('1');
    if (lineOption2Selected) selectedLineOptions.add('2');
    if (lineOption3Selected) selectedLineOptions.add('3');

    // Retrieve the checkbox status
    bool isCompletionDateSameAsCommencement = completionDateSameAsCommencement;

    // Print the gathered data
    print('Batch Number: $batchNumber');
    print('Commencement Date: $commencementDate');
    print('Completion Date: $completionDate');
    print('Selected Shift Options: $selectedShiftOptions');
    print('Selected Line Options: $selectedLineOptions');
    print('Is Completion Date Same As Commencement: $isCompletionDateSameAsCommencement');
  }

}
