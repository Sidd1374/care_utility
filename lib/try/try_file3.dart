import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../MainFiles/home_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../MainFiles/register_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isRegistering = false;

  Future<void> _login() async {
    try {
      final UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      // If login is successful, navigate to the home page
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
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
    ScreenUtil.init(context, designSize: const Size(411, 890), minTextAdapt: true);

    return Scaffold(
      backgroundColor: Color.fromRGBO(1, 10, 89, 50),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(ScreenUtil().setWidth(16.0)),
          child: Center(
            child: SingleChildScrollView(
              child: Container(
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
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
                    SizedBox(height: ScreenUtil().setHeight(35)),
                    Form(
                      key: _formKey,
                      child: Column(
                        children: _isRegistering
                            ? _buildRegistrationForm()
                            : _buildLoginForm(),
                      ),
                    ),
                    SizedBox(height: ScreenUtil().setHeight(20)),
                    ElevatedButton(
                      onPressed: _isRegistering ? _register : _login,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromRGBO(1, 10, 89, 50),
                      ),
                      child: Text(
                        _isRegistering ? 'Register' : 'Login',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    SizedBox(height: ScreenUtil().setHeight(20)),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          _isRegistering = !_isRegistering;
                        });
                      },
                      child: Text(
                        _isRegistering ? 'Already have an account? Login' : 'Don\'t have an account? Register',
                        style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildLoginForm() {
    return [
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
        obscureText: true,
        decoration: const InputDecoration(
          labelText: "Password",
          hintText: "Enter your Password",
          prefixIcon: Icon(Icons.password_outlined),
          border: OutlineInputBorder(),
        ),
        onChanged: (String value) {},
        validator: (value) {
          if (value!.isEmpty) {
            return 'Please enter password';
          }
          return null;
        },
      ),
    ];
  }

  List<Widget> _buildRegistrationForm() {
    // You can define your registration form fields here
    // For example:
    return [
      TextFormField(
        decoration: InputDecoration(
          labelText: 'Name',
          hintText: 'Enter your name',
          prefixIcon: Icon(Icons.person),
          border: OutlineInputBorder(),
        ),
      ),
      SizedBox(height: ScreenUtil().setHeight(10)),
      TextFormField(
        decoration: InputDecoration(
          labelText: 'Email',
          hintText: 'Enter your email',
          prefixIcon: Icon(Icons.email),
          border: OutlineInputBorder(),
        ),
      ),
      // Add more fields as needed
    ];
  }

  void _register() {
    // Implement registration logic here
    // For now, just toggle the form
    setState(() {
      _isRegistering = false;
    });
  }
}
