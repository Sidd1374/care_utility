import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({Key? key});

  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController employeeIdController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  String? selectedDesignation;
  bool showPassword = false;

  final List<String> designations = ['Administrator', 'Manager', 'Employee'];

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, designSize: const Size(411, 890), minTextAdapt: true);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('User Registration'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.w),
        child: ListView(
          children: [
            const SizedBox(height: 20),
            Center(
              child: Text(
                'Register User',
                style: TextStyle(
                  color: Colors.black,
                  fontFamily: 'Inter',
                  fontSize: 26.sp,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ),
            const SizedBox(height: 20),
            _buildTextField('Name', nameController, Icons.person),
            _buildTextField('Email', emailController, Icons.email),
            _buildTextField('Employee ID', employeeIdController, Icons.work),
            _buildDropDownField('Designation', designations, selectedDesignation, Icons.work_outline),
            _buildPasswordField('Password', passwordController),
            _buildPasswordField('Confirm Password', confirmPasswordController),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _registerUser();
              },
              child: const Text('Register'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String labelText, TextEditingController controller, IconData iconData) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.h),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          border: Border.all(color: Colors.grey),
        ),
        child: TextField(
          controller: controller,
          decoration: InputDecoration(
            labelText: labelText,
            border: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(horizontal: 10.0),
            prefixIcon: Icon(iconData),
          ),
        ),
      ),
    );
  }

  Widget _buildPasswordField(String labelText, TextEditingController controller) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.h),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          border: Border.all(color: Colors.grey),
        ),
        child: TextField(
          controller: controller,
          obscureText: !showPassword,
          decoration: InputDecoration(
            labelText: labelText,
            border: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(horizontal: 10.0),
            prefixIcon: Icon(Icons.lock),
            suffixIcon: IconButton(
              icon: Icon(showPassword ? Icons.visibility : Icons.visibility_off),
              onPressed: () {
                setState(() {
                  showPassword = !showPassword;
                });
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDropDownField(String labelText, List<String> items, String? value, IconData iconData) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.h),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          border: Border.all(color: Colors.grey),
        ),
        child: Row(
          children: [
            Expanded(
              child: DropdownButtonFormField<String>(
                value: value,
                items: items.map((String item) {
                  return DropdownMenuItem<String>(
                    value: item,
                    child: Text(item),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    selectedDesignation = newValue;
                  });
                },
                decoration: InputDecoration(
                  labelText: labelText,
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(horizontal: 10.0),
                ),
              ),
            ),
            Icon(iconData),
          ],
        ),
      ),
    );
  }

  void _registerUser() {
    if (passwordController.text != confirmPasswordController.text) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Passwords do not match.'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
      return;
    }

    // Implement user registration logic here
  }
}
