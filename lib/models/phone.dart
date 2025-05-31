class Smartphone {
  final int id;
  final String model;
  final String brand;
  final double price;
  final String image;
  final int ram;
  final int storage;

  Smartphone({
    required this.id,
    required this.model,
    required this.brand,
    required this.price,
    required this.image,
    this.ram = 0,
    this.storage = 0,
  });

  factory Smartphone.fromJson(Map<String, dynamic> json) {
    return Smartphone(
      id: json['id'],
      model: json['model'] ?? '',
      brand: json['brand'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      image: json['imageUrl'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'model': model,
      'brand': brand,
      'price': price,
      'ram': ram,
      'storage': storage,
    };
  }
}
