import 'package:flutter/material.dart';
import '../services/api_service.dart';

class CreatePage extends StatefulWidget {
  @override
  _CreatePageState createState() => _CreatePageState();
}

class _CreatePageState extends State<CreatePage> {
  final _formKey = GlobalKey<FormState>();
  final model = TextEditingController();
  final brand = TextEditingController();
  final price = TextEditingController();
  int ram = 2;
  int storage = 128;

  final List<int> ramOptions = [2, 4, 8, 16, 32];
  final List<int> storageOptions = [128, 256, 512];

  void _submit() async {
    if (_formKey.currentState!.validate()) {
      await ApiService.createSmartphone({
        'model': model.text,
        'brand': brand.text,
        'price': double.tryParse(price.text) ?? 0,
        'ram': ram,
        'storage': storage,
      });
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Tambah Ponsel')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: brand,
                decoration: InputDecoration(labelText: 'Brand'),
                validator: (v) => v!.isEmpty ? 'Wajib diisi' : null,
              ),
              TextFormField(
                controller: model,
                decoration: InputDecoration(labelText: 'Model'),
                validator: (v) => v!.isEmpty ? 'Wajib diisi' : null,
              ),
              TextFormField(
                controller: price,
                decoration: InputDecoration(labelText: 'Price'),
                keyboardType: TextInputType.number,
              ),
              // Ubah input RAM menjadi text box
              TextFormField(
                initialValue: ram.toString(),
                decoration: InputDecoration(labelText: 'RAM (GB)'),
                keyboardType: TextInputType.number,
                validator: (v) {
                  if (v!.isEmpty) {
                    return 'Wajib diisi';
                  }
                  int? ramValue = int.tryParse(v);
                  if (ramValue == null || ramValue == 0) {
                    return 'Harus kelipatan 2 dan tidak boleh 0';
                  }
                  if (ramValue % 2 != 0) {
                    return 'Harus kelipatan 2';
                  }
                  return null;
                },
                onChanged: (v) {
                  int? ramValue = int.tryParse(v);
                  if (ramValue != null && ramValue % 2 == 0 && ramValue != 0) {
                    setState(() {
                      ram = ramValue;
                    });
                  }
                },
              ),
              DropdownButtonFormField<int>(
                value: storage,
                decoration: InputDecoration(labelText: 'Storage'),
                items:
                    storageOptions
                        .map(
                          (val) => DropdownMenuItem(
                            value: val,
                            child: Text('$val GB'),
                          ),
                        )
                        .toList(),
                onChanged: (val) => setState(() => storage = val!),
              ),
              SizedBox(height: 20),
              ElevatedButton(onPressed: _submit, child: Text('Submit')),
            ],
          ),
        ),
      ),
    );
  }
}
