import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../archive/batch_record.dart';
// import '../try/try_file3.dart';
// import 'package:care_utility/try/trry.dart';
import 'reconciliation_page.dart';
import 'package:care_utility/archive/register_page.dart';
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
        title: const Text(
          'Home Page',
          // style: Font,
        ),
      ),
      body: Container(
        padding: EdgeInsets.all(ScreenUtil().setWidth(10.0)),
        decoration: const BoxDecoration(
          color: Color.fromRGBO(255, 255, 255, 1),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            _buildText(),
            SizedBox(height: 80.h,),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: GridView.count(
                  crossAxisCount: 2, // Two columns
                  crossAxisSpacing: ScreenUtil().setWidth(20.0),
                  mainAxisSpacing: ScreenUtil().setHeight(10.0),
                  shrinkWrap: true,
                  children: <Widget>[

                    _buildButton(
                      'Button 1',
                          () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => BatchRecordPage()),
                        );
                      },
                    ),
                    _buildButton(
                      'Button 2',
                          () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => MaterialReconciliationPage()),
                        );
                      },
                    ),
                    _buildButton(
                      'Button 3',
                          () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => BatchWeightPage()),
                        );
                      },
                    ),
                    _buildButton(
                      'Button 4',
                          () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => BatchRecord()),
                        );
                      },
                    ),
                  ],
                ),
            ),
            SizedBox(height: 20), // Add some space between the grid view and the text
          ],
        ),
      ),
    );
  }

  Widget _buildButton(String label, VoidCallback onPressed) {
    return ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50), // Adjusted border radius
          ),
        ),
        child: SizedBox(
          width: 150, // Adjusted button width
          height: 50, // Adjusted button height
          child: Center(
            child: Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontFamily: 'Inter',
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      );
  }

  Widget _buildText() {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          'Welcome to ',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Color.fromRGBO(0, 0, 0, 1),
            fontFamily: 'Inter',
            fontSize: 32, // Removed ScreenUtil usage for font size
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
            fontSize: 32, // Removed ScreenUtil usage for font size
            letterSpacing: 0,
            fontWeight: FontWeight.normal,
            height: 1,
          ),
        ),
      ],
    );
  }
}
