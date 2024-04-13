import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'batch_record_page.dart';
import 'reconciliation_page.dart';
import 'batch_weight_page.dart';
import 'dispensing_page.dart';
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
            // SizedBox(
            //   height: 20.h,
            // ),
            Image(
              image: const AssetImage('assets/imgs/cu_logo_rmvbg.png'),
              width: ScreenUtil().setWidth(250),
              height: ScreenUtil().setHeight(250),
            ),
            _buildText(),

            SizedBox(
              height: 50.h,
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: GridView.count(
                crossAxisCount: 2, // Two columns
                crossAxisSpacing: ScreenUtil().setWidth(20.0),
                mainAxisSpacing: ScreenUtil().setHeight(10.0),
                shrinkWrap: true,
                children: <Widget>[
                  _buildButton(
                    'New Batch',
                    () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => BatchRecordPage()),
                      );
                    },const Icon(Icons.add_box,
                    size: 40,
                    color: Colors.white,
                  ),
                  ),
                  _buildButton(
                    'Material Dispensing',
                    () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => MaterialDispensingPage()),
                            // builder: (context) => TestScreen()),
                      );
                    },const Icon(Icons.table_chart_rounded,
                    size: 40,
                    color: Colors.white,),
                  ),
                  _buildButton(
                    'Update Weight',
                    () {
                      // Navigator.pushNamed(context, "");
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => BatchWeightPage()),
                      );
                    },const Icon(CupertinoIcons.archivebox_fill,
                    size: 40,
                    color: Colors.white,),
                  ),
                  _buildButton(
                    'Material Reconciliation',
                    () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => MaterialReconciliationPage()),
                      );
                    },const Icon(Icons.file_present_rounded,
                    size: 40,
                    color: Colors.white,),
                  ),
                ],
              ),
            ),
            const SizedBox(
                height:
                    20), // Add some space between the grid view and the text
          ],
        ),
      ),
    );
  }

  Widget _buildButton(String label, VoidCallback onPressed, Icon icon) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50), // Adjusted border radius
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          icon,
          SizedBox(height: 8), // Adjusted space between icon and text
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontFamily: 'Inter',
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildText() {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Text(
        //   'Welcome to ',
        //   textAlign: TextAlign.center,
        //   style: TextStyle(
        //     color: Color.fromRGBO(0, 0, 0, 1),
        //     fontFamily: 'Inter',
        //     fontSize: 32, // Removed ScreenUtil usage for font size
        //     letterSpacing: 0,
        //     fontWeight: FontWeight.normal,
        //     height: 1,
        //   ),
        // ),
        Text(
          'Production Manager',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Color.fromRGBO(0, 0, 0, 1),
            fontFamily: 'Inter',
            fontSize: 32,
            letterSpacing: 0,
            fontWeight: FontWeight.bold,
            height: 1,
          ),
        ),
      ],
    );
  }
}
