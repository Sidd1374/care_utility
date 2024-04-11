import 'package:flutter/material.dart';
// import '../try/try_file3.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';

class TestScreen extends StatelessWidget {
  const TestScreen({super.key});

  Future<QuerySnapshot> fetchLatestBatches() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('Care_utility_db')
          .doc('dual_air_dev')
          .collection('mgmt_record')
          .doc('batch_info')
          .collection('batch_list')
          .orderBy(FieldPath.documentId, descending: true)
          .limit(5)
          .get();


      print("success we got data");
      return querySnapshot;
    } catch (e) {
      print("error: $e");
      throw Exception('Failed to fetch latest batches: $e');
    }
  }

  Future<void> fetchBatches() async {
    try {
      CollectionReference batches = FirebaseFirestore.instance.collection('Care_utility_db/dual_air_dev/mgmt_record/batch_info/batches');
      QuerySnapshot querySnapshot = await batches.get();
      List<DocumentSnapshot> docs = querySnapshot.docs;
      List<String> docNumbers = [];
      for (var doc in docs) {
        docNumbers.add(doc.id); // or doc['your_field_name'] if you want to get field value
      }
      print(docNumbers);

    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            TextButton(
              onPressed: () {
                // fetchLatestBatches();
                fetchBatches();
              },
              child: Text("test"),
            )
          ],
        ),
      ),
    );
  }
}
