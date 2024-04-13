import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../MainFiles/home_page.dart';
import 'package:firebase_auth/firebase_auth.dart';


class LoginPage extends StatefulWidget {
  const LoginPage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _loginFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _registrationFormKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController(); // Added

  bool _isRegistering = false;
  bool _isPasswordVisible = false;
  String? _selectedRole;

  Future<void> _login() async {
    try {
      final UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      // If login is successful, navigate to the home page
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomePage()),
      );
    } catch (e) {
      // Show specific error message based on error type
      String errorMessage = 'Login failed';
      if (e is FirebaseAuthException) {
        errorMessage = e.message ?? 'An error occurred';
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(
      context,
      designSize: const Size(411, 890),
      minTextAdapt: true,
    );

    return Scaffold(
      backgroundColor: const Color.fromRGBO(1, 10, 89, 50),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(ScreenUtil().setWidth(16.0)),
          child: Center(
            child: SingleChildScrollView(
              child: Container(
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 40,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image(
                      image: const AssetImage('assets/imgs/cu_logo_rmvbg.png'),
                      width: ScreenUtil().setWidth(200),
                      height: ScreenUtil().setHeight(200),
                    ),
                    SizedBox(height: ScreenUtil().setHeight(20)),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextButton(
                          onPressed: () {
                            setState(() {
                              _isRegistering = false;
                            });
                          },
                          child: Text(
                            'Login',
                            style: TextStyle(
                              fontSize: ScreenUtil().setSp(28),
                              color: !_isRegistering
                                  ? Colors.green
                                  : const Color.fromRGBO(1, 10, 89, 50),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            setState(() {
                              _isRegistering = true;
                            });
                          },
                          child: Text(
                            'Register',
                            style: TextStyle(
                              fontSize: ScreenUtil().setSp(28),
                              color: _isRegistering
                                  ? Colors.green
                                  : const Color.fromRGBO(1, 10, 89, 50),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),

                    AnimatedCrossFade(
                      firstChild: _buildRegistrationForm(),
                      secondChild: _buildLoginForm(),
                      crossFadeState: _isRegistering ? CrossFadeState.showFirst : CrossFadeState.showSecond,
                      duration: const Duration(milliseconds: 100),
                      // onCompleted: () {
                      //   // Start animation after page transition is completed
                      //   // Add your animation controller forward here
                      // },
                    ),

                    SizedBox(height: ScreenUtil().setHeight(35)),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoginForm() {
    return Form(
      key: _loginFormKey,
      child: Column(
        children: [
          TextFormField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(
              labelText: "Email",
              hintText: "Enter your Email",
              prefixIcon: Icon(Icons.email_outlined),
              border: OutlineInputBorder(),
            ),
            onChanged: (String value) {},
            validator: (value) {
              if (value!.isEmpty) {
                return 'Please enter email';
              }
              return null;
            },
          ),
          SizedBox(height: ScreenUtil().setHeight(10)),
          TextFormField(
            controller: _passwordController,
            keyboardType: TextInputType.visiblePassword,
            obscureText: !_isPasswordVisible,
            decoration: InputDecoration(
              labelText: "Password",
              hintText: "Enter your Password",
              prefixIcon: const Icon(Icons.password_outlined),
              border: const OutlineInputBorder(),
              suffixIcon: IconButton(
                icon: Icon(
                  _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                ),
                onPressed: () {
                  setState(() {
                    _isPasswordVisible = !_isPasswordVisible;
                  });
                },
              ),
            ),
            onChanged: (String value) {},
            validator: (value) {
              if (value!.isEmpty) {
                return 'Please enter password';
              }
              return null;
            },
          ),
          SizedBox(height: ScreenUtil().setHeight(20)),
          ElevatedButton(
            onPressed: _login,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromRGBO(1, 10, 89, 50),
            ),
            child: const Text(
              'Login',
              style: TextStyle(color: Colors.white),
            ),
          ),
          SizedBox(height: ScreenUtil().setHeight(20)),
          TextButton(
            onPressed: () {
              _resetPassword(); // Call the reset password function when the button is pressed
            },
            child: const Text(
              'Forgot Password?',
              style: TextStyle(
                color: Colors.blue,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

        ],
      ),
    );
  }

  Widget _buildRegistrationForm() {
    return Form(
      key: _registrationFormKey,
      child: Column(
        children: [
          TextFormField(
            controller: _nameController, // Add controller for name field
            decoration: const InputDecoration(
              labelText: 'Name',
              hintText: 'Enter your name',
              prefixIcon: Icon(Icons.person),
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value!.isEmpty) {
                return 'Please enter your name';
              }
              return null;
            },
          ),
          SizedBox(height: ScreenUtil().setHeight(10)),
          TextFormField(
            controller: _emailController,
            decoration: const InputDecoration(
              labelText: 'Email',
              hintText: 'Enter your email',
              prefixIcon: Icon(Icons.email),
              border: OutlineInputBorder(),
            ),
            // Validation logic...
          ),
          SizedBox(height: ScreenUtil().setHeight(10)),
          DropdownButtonFormField<String>(
            decoration: const InputDecoration(
              labelText: 'Role',
              hintText: 'Select your role',
              prefixIcon: Icon(Icons.assignment_ind),
              border: OutlineInputBorder(),
            ),
            value: _selectedRole,
            onChanged: (String? newValue) {
              setState(() {
                _selectedRole = newValue!;
              });
            },
            items: <String>['Admin', 'Manager', 'Employee']
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
          SizedBox(height: ScreenUtil().setHeight(10)),
          TextFormField(
            controller: _passwordController,
            decoration: InputDecoration(
              labelText: 'Password',
              hintText: 'Enter your password',
              prefixIcon: Icon(Icons.lock),
              border: OutlineInputBorder(),
              suffixIcon: IconButton(
                icon: Icon(
                  _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                ),
                onPressed: () {
                  setState(() {
                    _isPasswordVisible = !_isPasswordVisible;
                  });
                },
              ),
            ),
            obscureText: !_isPasswordVisible,
            validator: (value) {
              if (value!.isEmpty) {
                return 'Please enter your password';
              }
              return null;
            },
          ),
          SizedBox(height: ScreenUtil().setHeight(10)),
          TextFormField(
            decoration: InputDecoration(
              labelText: 'Confirm Password',
              hintText: 'Confirm your password',
              prefixIcon: Icon(Icons.lock),
              border: OutlineInputBorder(),
              suffixIcon: IconButton(
                icon: Icon(
                  _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                ),
                onPressed: () {
                  setState(() {
                    _isPasswordVisible = !_isPasswordVisible;
                  });
                },
              ),
            ),
            obscureText: !_isPasswordVisible,
            validator: (value) {
              if (value!.isEmpty) {
                return 'Please confirm your password';
              }
              if (value != _passwordController.text) {
                return 'Passwords do not match';
              }
              return null;
            },
          ),
          SizedBox(height: ScreenUtil().setHeight(20)),
          ElevatedButton(
            onPressed: _register,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromRGBO(1, 10, 89, 50),
            ),
            child: const Text(
              'Register',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }


  void _register() async {
    // Implement registration logic
    String name = _nameController.text.trim(); // Retrieve name from controller
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();
    String role = _selectedRole ?? '';

    if (name.isNotEmpty && email.isNotEmpty && password.isNotEmpty && role.isNotEmpty) {
      try {
        // Register user with Firebase Authentication
        UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );

        // Access Firestore instance
        FirebaseFirestore firestore = FirebaseFirestore.instance;

        // Determine the collection based on the selected role
        String collectionName = role == 'Manager' ? 'managers' : 'employees';

        // Create a reference to the 'users' collection
        CollectionReference usersCollection = firestore.collection('Care_utility_db').doc('user').collection(collectionName);

        // Create a document for the user with their email as the document ID
        usersCollection.doc(email).set({
          'name': name,
          'email': email,
          'role': role,
        }).then((_) {
          // Display a success message to the user
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Registration successful'),
              duration: Duration(seconds: 2),
            ),
          );

          // Reset the registration form
          _registrationFormKey.currentState!.reset();
          _selectedRole = null;

          setState(() {
            _isRegistering = false; // Switch back to login form
          });
        }).catchError((error) {
          // Handle registration error
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Registration failed: $error'),
              duration: Duration(seconds: 2),
            ),
          );
        });
      } catch (error) {
        // Handle registration error with Firebase Authentication
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Registration failed: $error'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    } else {
      // Show an error message if any field is empty
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill in all fields'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  void _resetPassword() {
    String email = _emailController.text.trim();

    if (email.isNotEmpty) {
      FirebaseAuth.instance.sendPasswordResetEmail(email: email)
          .then((_) {
        // Show a success message to the user
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Password reset email sent to $email'),
            duration: Duration(seconds: 2),
          ),
        );
      })
          .catchError((error) {
        // Show an error message if password reset fails
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to send password reset email: $error'),
            duration: Duration(seconds: 2),
          ),
        );
      });
    } else {
      // Show an error message if the email field is empty
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter your email'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }




}
