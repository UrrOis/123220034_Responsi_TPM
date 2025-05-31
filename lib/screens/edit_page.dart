import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/phone.dart';
import '../services/api_service.dart';

class EditPage extends StatefulWidget {
  const EditPage({Key? key}) : super(key: key);

  @override
  State<EditPage> createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  final _formKey = GlobalKey<FormState>();
  final _modelController = TextEditingController();
  final _brandController = TextEditingController();
  final _priceController = TextEditingController();
  final _imageController = TextEditingController();
  final _ramController = TextEditingController();
  final _websiteController = TextEditingController();
  int _selectedStorage = 128;
  bool _isLoading = false;

  final List<int> _storageOptions = [128, 256, 512];
  Phone? _phone;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final phone = ModalRoute.of(context)!.settings.arguments as Phone;
    if (_phone == null) {
      _phone = phone;
      _modelController.text = phone.model;
      _brandController.text = phone.brand;
      _priceController.text = phone.price.toString();
      _imageController.text = phone.image;
      _ramController.text = phone.ram.toString();
      _selectedStorage = phone.storage;
      _websiteController.text = phone.website ?? '';
    }
  }

  @override
  void dispose() {
    _modelController.dispose();
    _brandController.dispose();
    _priceController.dispose();
    _imageController.dispose();
    _ramController.dispose();
    _websiteController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      try {
        final updatedPhone = Phone(
          id: _phone!.id,
          model: _modelController.text,
          brand: _brandController.text,
          price: double.parse(_priceController.text),
          image: _imageController.text,
          ram: int.parse(_ramController.text),
          storage: _selectedStorage,
          website:
              _websiteController.text.isNotEmpty
                  ? _websiteController.text
                  : null,
        );

        final success = await APIService.updatePhone(_phone!.id!, updatedPhone);

        if (!mounted) return;

        if (success) {
          Navigator.pop(context, true);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Phone updated successfully')),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Failed to update phone'),
              backgroundColor: Colors.red,
            ),
          );
        }
      } catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
        );
      } finally {
        if (mounted) {
          setState(() => _isLoading = false);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Phone')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _modelController,
                decoration: const InputDecoration(
                  labelText: 'Model',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the model';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _brandController,
                decoration: const InputDecoration(
                  labelText: 'Brand',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the brand';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _priceController,
                decoration: const InputDecoration(
                  labelText: 'Price',
                  border: OutlineInputBorder(),
                  prefixText: '\$ ',
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
                ],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the price';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Please enter a valid price';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _imageController,
                decoration: const InputDecoration(
                  labelText: 'Image URL',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the image URL';
                  }
                  final uri = Uri.tryParse(value);
                  if (uri == null || !uri.isAbsolute) {
                    return 'Please enter a valid URL';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _ramController,
                decoration: const InputDecoration(
                  labelText: 'RAM (GB)',
                  border: OutlineInputBorder(),
                  helperText: 'Must be a multiple of 2',
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the RAM';
                  }
                  final ram = int.tryParse(value);
                  if (ram == null) {
                    return 'Please enter a valid number';
                  }
                  if (ram % 2 != 0) {
                    return 'RAM must be a multiple of 2';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<int>(
                value: _selectedStorage,
                decoration: const InputDecoration(
                  labelText: 'Storage (GB)',
                  border: OutlineInputBorder(),
                ),
                items:
                    _storageOptions.map((storage) {
                      return DropdownMenuItem<int>(
                        value: storage,
                        child: Text('$storage GB'),
                      );
                    }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() => _selectedStorage = value);
                  }
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _websiteController,
                decoration: const InputDecoration(
                  labelText: 'Website URL (Optional)',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value != null && value.isNotEmpty) {
                    final uri = Uri.tryParse(value);
                    if (uri == null || !uri.isAbsolute) {
                      return 'Please enter a valid URL';
                    }
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              SizedBox(
                height: 50,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _submitForm,
                  child:
                      _isLoading
                          ? const CircularProgressIndicator()
                          : const Text(
                            'Update Phone',
                            style: TextStyle(fontSize: 18),
                          ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
