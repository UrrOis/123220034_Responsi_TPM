import 'package:flutter/material.dart';
import 'screens/login_page.dart';
import 'util/shared_prefs.dart';
import 'screens/home_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Phone Catalog',
      theme: ThemeData(primarySwatch: Colors.indigo),
      home: FutureBuilder<String?>(
        future: SessionManager.getLogin(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Scaffold(body: Center(child: CircularProgressIndicator()));
          }
          return snapshot.data == null ? LoginPage() : HomePage();
        },
      ),
    );
  }
}
