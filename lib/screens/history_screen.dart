import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({Key? key}) : super(key: key); // tambahkan Key

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
            return const Center(child: CircularProgressIndicator());

          final orders = snapshot.data!.docs;

          // Hitung jumlah pesanan per hari
          Map<String, int> dailyCount = {};
          for (var order in orders) {
            DateTime ts = (order['timestamp'] as Timestamp).toDate();
            String day = DateFormat('yyyy-MM-dd').format(ts);
            dailyCount[day] = (dailyCount[day] ?? 0) + (order['jumlah'] as int);
          }

          final sortedDays = dailyCount.keys.toList()..sort();

          if (sortedDays.isEmpty)
            return const Center(child: Text("Belum ada data pesanan selesai"));

          return Padding(
            padding: const EdgeInsets.all(16),
            child: LineChart(
              LineChartData(
                minY: 0,
                maxY: dailyCount.values.reduce((a, b) => a > b ? a : b).toDouble() + 2,
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: true),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        int idx = value.toInt();
                        if (idx < 0 || idx >= sortedDays.length) return const Text('');
                        return Text(sortedDays[idx].substring(5)); // MM-dd
                      },
                    ),
                  ),
                ),
                lineBarsData: [
                  LineChartBarData(
                    spots: List.generate(
                      sortedDays.length,
                      (index) => FlSpot(
                          index.toDouble(),
                          dailyCount[sortedDays[index]]!.toDouble()),
                    ),
                    isCurved: true,
                    barWidth: 3,
                    color: Colors.blue, // API baru: color
                    dotData: FlDotData(show: true),
                  ),
                ],
                gridData: FlGridData(show: true),
                borderData: FlBorderData(show: true),
              ),
            ),
          );
        },
      ),
    );
  }
}
