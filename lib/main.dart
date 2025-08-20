import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'screens/cooking_screen.dart';
import 'screens/history_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kitchen Monitoring',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Kitchen Monitoring")),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            child: Text("Cooking Screen"),
            onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => CookingScreen())),
          ),
          ElevatedButton(
            child: Text("History Screen"),
            onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => HistoryScreen())),
          ),
        ],
      ),
    );
  }
}
