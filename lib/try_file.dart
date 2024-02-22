import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'MainFiles/home_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'MainFiles/register_page.dart';

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

  Future<void> _login() async {
    try {
      final UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
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
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        // Optionally, you can add a title to the app bar
        // title: Text(
        //   widget.title,
        //   style: const TextStyle(color: Colors.black45),
        // ),
      ),

      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(ScreenUtil().setWidth(16.0)),
          child: Center(
            child: ListView(
              children: [
                SizedBox(height: ScreenUtil().setHeight(20)),
                Image(
                  image: const AssetImage('assets/imgs/cu_logo_rmvbg.png'),
                  width: ScreenUtil().setWidth(200),
                  height: ScreenUtil().setHeight(200),
                ),
                SizedBox(height: ScreenUtil().setHeight(20)),
                Center(
                  child: Text(
                    'Login',
                    style: TextStyle(
                      fontSize: ScreenUtil().setSp(35),
                      color: Colors.indigo,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: ScreenUtil().setHeight(20)),
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
                          // You can add more email validation logic here if needed
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
                          // You can add more password validation logic here if needed
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
                SizedBox(height: ScreenUtil().setHeight(20)),
                Center(
                  child: ElevatedButton(
                    onPressed: _login,
                    child: Text('Login'),
                  ),
                ),
                SizedBox(height: ScreenUtil().setHeight(20)),
                TextButton(
                  onPressed: () {
                    // Implement your reset password logic here
                    print('Forgot Password link pressed');
                  },
                  child: const Text(
                    'Forgot Password?',
                    style: TextStyle(
                      color: Colors.blue, // You can customize the color
                    ),
                  ),
                ),

                const Divider(height: 50,),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const RegistrationPage()),
                    );
                  },
                  child: const Text(
                    "Register Now",
                    style: TextStyle(
                      color: Colors.teal, // You can customize the color
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
