import 'package:flutter/material.dart';
import '../models/phone.dart';
import '../services/api_service.dart';

class EditPage extends StatefulWidget {
  final Smartphone phone; // Pastikan tipe 'Smartphone' digunakan

  const EditPage({super.key, required this.phone});

  @override
  _EditPageState createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController model;
  late TextEditingController brand;
  late TextEditingController price;
  late int ram;
  late int storage;

  final List<int> ramOptions = [2, 4, 8, 16, 32];
  final List<int> storageOptions = [128, 256, 512];

  @override
  void initState() {
    super.initState();
    model = TextEditingController(text: widget.phone.model);
    brand = TextEditingController(text: widget.phone.brand);
    price = TextEditingController(text: widget.phone.price.toString());

    ram =
        ramOptions.contains(widget.phone.ram)
            ? widget.phone.ram
            : ramOptions.first;
    storage =
        storageOptions.contains(widget.phone.storage)
            ? widget.phone.storage
            : storageOptions.first;
  }

  void _submit() async {
    if (_formKey.currentState!.validate()) {
      await ApiService.updateSmartphone(widget.phone.id!, {
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
      appBar: AppBar(title: Text('Edit Ponsel')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: brand,
                decoration: InputDecoration(labelText: 'Brand'),
              ),
              TextFormField(
                controller: model,
                decoration: InputDecoration(labelText: 'Model'),
              ),
              TextFormField(
                controller: price,
                decoration: InputDecoration(labelText: 'Price'),
                keyboardType: TextInputType.number,
              ),
              // Ubah input RAM menjadi text box dan tambahkan validasi
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
              ElevatedButton(onPressed: _submit, child: Text('Update')),
            ],
          ),
        ),
      ),
    );
  }
}
