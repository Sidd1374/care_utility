import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../batch_record.dart';
import 'package:care_utility/MainFiles/register_page.dart';
import 'MainFiles/batch_record_page.dart';
import 'MainFiles/batch_weight_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, designSize: Size(411, 890), minTextAdapt: true);

    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page'),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          color: Color.fromRGBO(255, 255, 255, 1),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: ScreenUtil().setHeight(100)),
            _buildText(),
            SizedBox(height: ScreenUtil().setHeight(150)),
            _buildGridButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildText() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          'Welcome to',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Color.fromRGBO(0, 0, 0, 1),
            fontFamily: 'Inter',
            fontSize: ScreenUtil().setSp(32),
            letterSpacing: 0,
            fontWeight: FontWeight.normal,
            height: 1,
          ),
        ),
        Text(
          'Production Manager',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Color.fromRGBO(0, 0, 0, 1),
            fontFamily: 'Inter',
            fontSize: ScreenUtil().setSp(32),
            letterSpacing: 0,
            fontWeight: FontWeight.normal,
            height: 1,
          ),
        ),
      ],
    );
  }

  Widget _buildGridButtons() {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(50)), // Adjust horizontal padding
      mainAxisSpacing: ScreenUtil().setHeight(12), // Vertical spacing between buttons
      crossAxisSpacing: ScreenUtil().setWidth(12), // Horizontal spacing between buttons
      children: [
        _buildButton('Button 1', () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => BatchRecordPage()),
          );
        }),
        _buildButton('Button 2', () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => RegistrationPage()),
          );
        }),
        _buildButton('Button 3', () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => BatchWeightPage()),
          );
        }),
        _buildButton('Button 4', () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => BatchRecord()),
          );
        }),
      ],
    );
  }

  Widget _buildButton(String label, VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue, // Change the color as needed
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(ScreenUtil().setWidth(40)), // Adjust button border radius
        ),
      ),
      child: SizedBox(
        width: ScreenUtil().setWidth(100), // Adjust button width
        height: ScreenUtil().setHeight(80), // Adjust button height
        child: Center(
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'Inter',
              fontSize: ScreenUtil().setSp(14), // Adjust button text size
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

}
