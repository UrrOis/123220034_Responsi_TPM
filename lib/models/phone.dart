class Phone {
  final String? id;
  final String model;
  final String brand;
  final double price;
  final String image;
  final int ram;
  final int storage;
  final String? website;

  Phone({
    this.id,
    required this.model,
    required this.brand,
    required this.price,
    required this.image,
    required this.ram,
    required this.storage,
    this.website,
  });

  factory Phone.fromJson(Map<String, dynamic> json) {
    return Phone(
      id: json['id']?.toString(),
      model: json['model'] as String,
      brand: json['brand'] as String,
      price: double.parse(json['price'].toString()),
      image: json['gambar'] as String,
      ram: json['ram'] as int,
      storage: json['storage'] as int,
      website: json['website'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'model': model,
      'brand': brand,
      'price': price,
      'gambar': image,
      'ram': ram,
      'storage': storage,
      if (website != null) 'website': website,
    };
  }
}
