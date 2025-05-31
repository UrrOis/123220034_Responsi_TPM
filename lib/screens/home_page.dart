import 'package:flutter/material.dart';
import '../models/phone.dart';
import '../services/api_service.dart';
import '../util/shared_prefs.dart';
import 'login_page.dart';
import 'detail_page.dart';
import 'create_page.dart';
import 'edit_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<Smartphone>> _futurePhones;
  String? nim;

  @override
  void initState() {
    super.initState();
    _loadUser();
    _futurePhones = ApiService.getSmartphones();
  }

  Future<void> _loadUser() async {
    final user = await SessionManager.getLogin();
    setState(() {
      nim = user;
    });
  }

  void _logout() async {
    await SessionManager.logout();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
    );
  }

  void _refresh() {
    setState(() {
      _futurePhones = ApiService.getSmartphones();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text(nim == null ? 'Halo!' : 'Halo, $nim')),
        actions: [IconButton(onPressed: _logout, icon: Icon(Icons.logout))],
      ),
      body: FutureBuilder<List<Smartphone>>(
        future: _futurePhones,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final phones = snapshot.data!;
            return ListView.builder(
              itemCount: phones.length,
              itemBuilder: (context, index) {
                final phone = phones[index];
                return ListTile(
                  leading: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.black, // Warna border
                        width: 2, // Ketebalan border
                      ),
                      borderRadius: BorderRadius.circular(
                        8,
                      ), // Radius untuk sudut yang lebih halus (optional)
                    ),
                    child: Image.network(
                      phone.image,
                      width:
                          50, // Ukuran lebar gambar, sesuaikan dengan kebutuhan
                      height: 50, // Menjaga agar gambar tetap proporsional
                      fit:
                          BoxFit
                              .cover, // Agar gambar terisi dengan baik pada kontainer
                    ),
                  ),
                  title: Text('${phone.brand} ${phone.model}'),
                  subtitle: Text('Rp ${phone.price}'),
                  onTap:
                      () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DetailPage(phone: phone),
                        ),
                      ),
                  trailing:
                      index >= 10
                          ? Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: Icon(Icons.edit),
                                onPressed:
                                    () => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder:
                                            (context) => EditPage(phone: phone),
                                      ),
                                    ).then((_) => _refresh()),
                              ),
                              IconButton(
                                icon: Icon(Icons.delete),
                                onPressed: () async {
                                  await ApiService.deleteSmartphone(phone.id);
                                  _refresh();
                                },
                              ),
                            ],
                          )
                          : null,
                );
              },
            );
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed:
            () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => CreatePage()),
            ).then((_) => _refresh()),
        child: Icon(Icons.add),
      ),
    );
  }
}
