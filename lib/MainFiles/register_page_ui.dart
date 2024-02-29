import 'package:flutter/material.dart';

class RegisterPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Register'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Add your registration form fields here
              TextFormField(
                // Name field
                decoration: InputDecoration(labelText: 'Name'),
              ),
              TextFormField(
                // Email field
                decoration: InputDecoration(labelText: 'Email'),
              ),
              // Dropdown for role selection
              DropdownButtonFormField<String>(
                items: ['Admin', 'Manager', 'Employee']
                    .map((role) => DropdownMenuItem(
                  value: role,
                  child: Text(role),
                ))
                    .toList(),
                onChanged: (value) {
                  // Handle role selection
                },
                decoration: InputDecoration(labelText: 'Role'),
              ),
              TextFormField(
                // Password field
                obscureText: true,
                decoration: InputDecoration(labelText: 'Password'),
              ),
              TextFormField(
                // Confirm Password field
                obscureText: true,
                decoration: InputDecoration(labelText: 'Confirm Password'),
              ),
              ElevatedButton(
                onPressed: () {
                  // Implement registration logic
                },
                child: Text('Register'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}