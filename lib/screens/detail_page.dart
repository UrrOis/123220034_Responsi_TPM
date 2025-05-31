import 'package:flutter/material.dart';
import '../models/phone.dart';

class DetailPage extends StatelessWidget {
  final Smartphone phone;

  const DetailPage({super.key, required this.phone});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('${phone.brand} ${phone.model}')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(child: Image.network(phone.image, height: 150)),
            SizedBox(height: 16),
            Text('Brand: ${phone.brand}', style: TextStyle(fontSize: 18)),
            Text('Model: ${phone.model}', style: TextStyle(fontSize: 18)),
            Text('Price: Rp ${phone.price}', style: TextStyle(fontSize: 18)),
            Text('RAM: ${phone.ram} GB', style: TextStyle(fontSize: 18)),
            Text(
              'Storage: ${phone.storage} GB',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
