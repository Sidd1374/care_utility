import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../MainFiles/home_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../MainFiles/register_page.dart';
import 'package:care_utility/MainFiles/login_page.dart'as lg;

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

  // Variable to track the active button
  String _activeButton = 'Login';

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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextButton(
                          onPressed: () {
                            setState(() {
                              _activeButton = 'Login';
                            });
                            print("Login pressed");
                          },
                          child: Text(
                            'Login',
                            style: TextStyle(
                              fontSize: ScreenUtil().setSp(28),
                              color: _activeButton == 'Login' ? Colors.green : const Color.fromRGBO(1, 10, 89, 50),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            setState(() {
                              _activeButton = 'Register';
                            });
                            print("Register pressed");
                          },
                          child: Text(
                            'Register',
                            style: TextStyle(
                              fontSize: ScreenUtil().setSp(28),
                              color: _activeButton == 'Register' ? Colors.green : const Color.fromRGBO(1, 10, 89, 50),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: ScreenUtil().setHeight(35)),
                    Form(
                      key: _formKey,
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
                        ],
                      ),
                    ),
                    SizedBox(height: ScreenUtil().setHeight(20)),
                    ElevatedButton(
                      onPressed: () {
                        // Implement your reset password logic here
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const lg.LoginPage(title: "login")),
                        );
                      },                      // onPressed: _login,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromRGBO(1, 10, 89, 50),
                        // backgroundColor: _activeButton == 'Login' ? Colors.green : const Color.fromRGBO(1, 10, 89, 50),
                      ),
                      child: const Text(
                        'Login',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    SizedBox(height: ScreenUtil().setHeight(20)),
                    TextButton(
                      onPressed: () {
                        // Implement your reset password logic here
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(builder: (context) => const ProfilePage()),
                        // );
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
              ),
            ),
          ),
        ),
      ),
    );
  }
}
