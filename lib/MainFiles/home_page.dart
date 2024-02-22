import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../batch_record.dart';
import '../try_file2.dart';
import 'package:care_utility/MainFiles/register_page.dart';
import 'batch_record_page.dart';
import 'batch_weight_page.dart';


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
        width: ScreenUtil().screenWidth,
        height: ScreenUtil().screenHeight,
        decoration: BoxDecoration(
          color: Color.fromRGBO(255, 255, 255, 1),
        ),
        child: Stack(
          children: <Widget>[
            _buildButton(
              ScreenUtil().setWidth(517),
              ScreenUtil().setHeight(20),
              'Button 1',
                  () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => BatchRecordPage()),
                );
              },
            ),
            _buildButton(
              ScreenUtil().setWidth(517),
              ScreenUtil().setHeight(212),
              'Button 2',
                  () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RegistrationPage()),
                );
              },
            ),
            _buildButton(
              ScreenUtil().setWidth(613),
              ScreenUtil().setHeight(20),
              'Button 3',
                  () {Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => BatchWeightPage()),
                  );
              },
            ),
            _buildButton(
              ScreenUtil().setWidth(613),
              ScreenUtil().setHeight(212),
              'Button 4',
                  () {
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => BatchRecord()),
                  );
              },
            ),
            _buildText(),
          ],
        ),
      ),
    );
  }


  Widget _buildButton(double top, double left, String label,
      VoidCallback onPressed) {
    return Positioned(
      top: top,
      left: left,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          primary: Colors.blue, // Change the color as needed
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(ScreenUtil().setWidth(30)),
          ),
        ), // Corrected this line
        child: SizedBox(
          width: ScreenUtil().setWidth(131),
          height: ScreenUtil().setHeight(85),
          child: Center(
            child: Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontFamily: 'Inter',
                fontSize: ScreenUtil().setSp(16),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildText() {
    return Positioned(
      top: ScreenUtil().setHeight(256),
      left: ScreenUtil().setWidth(41),
      child: Column(
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
      ),
    );
  }
}
