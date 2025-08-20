import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class HistoryScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("History Screen")),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('orders')
            .where('status', isEqualTo: 'selesai')
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return Center(child: CircularProgressIndicator());
          final orders = snapshot.data!.docs;

          // Hitung jumlah pesanan harian
          Map<String, int> dailyCount = {};
          for (var order in orders) {
            DateTime ts = order['timestamp'].toDate();
            String day = DateFormat('yyyy-MM-dd').format(ts);
            dailyCount[day] = ((dailyCount[day] ?? 0) + (order['jumlah'] as num).toInt());

          }

          return ListView(
            children: dailyCount.entries
                .map((e) => ListTile(
                      title: Text(e.key),
                      trailing: Text(e.value.toString()),
                    ))
                .toList(),
          );
        },
      ),
    );
  }
}
