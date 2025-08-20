import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CookingScreen extends StatefulWidget {
  @override
  _CookingScreenState createState() => _CookingScreenState();
}

class _CookingScreenState extends State<CookingScreen> {
  bool shiftStarted = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Cooking Screen")),
      body: Column(
        children: [
          ElevatedButton(
            child: Text(shiftStarted ? "Shift Started" : "Mulai Shift"),
            onPressed: shiftStarted
                ? null
                : () {
                    setState(() {
                      shiftStarted = true;
                    });
                  },
          ),
          Expanded(
            child: shiftStarted
                ? StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('orders')
                        .where('status', isEqualTo: 'belum selesai')
                        .orderBy('timestamp')
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData)
                        return Center(child: CircularProgressIndicator());
                      final orders = snapshot.data!.docs;
                      if (orders.isEmpty)
                        return Center(child: Text("Tidak ada pesanan."));
                      return ListView.builder(
                        itemCount: orders.length,
                        itemBuilder: (context, index) {
                          final order = orders[index];
                          return ListTile(
                            title: Text(order['namaPesanan']),
                            subtitle: Text(
                                "Jumlah: ${order['jumlah'].toString()}"),
                            trailing: ElevatedButton(
                              child: Text("Selesai"),
                              onPressed: () {
                                FirebaseFirestore.instance
                                    .collection('orders')
                                    .doc(order.id)
                                    .update({'status': 'selesai'});
                              },
                            ),
                          );
                        },
                      );
                    },
                  )
                : Center(child: Text("Tekan 'Mulai Shift' dulu")),
          ),
        ],
      ),
    );
  }
}
