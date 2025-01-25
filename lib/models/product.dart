class Specs {
  final double megapixels;
  final String sensorType;
  final String videoResolution;
  final String isoRange;
  final String weight;

  Specs({
    required this.megapixels,
    required this.sensorType,
    required this.videoResolution,
    required this.isoRange,
    required this.weight,
  });

  factory Specs.fromJson(Map<String, dynamic> json) {
    return Specs(
      megapixels: json['megapixels'],
      sensorType: json['sensor_type'],
      videoResolution: json['video_resolution'],
      isoRange: json['iso_range'],
      weight: json['weight'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'megapixels': megapixels,
      'sensor_type': sensorType,
      'video_resolution': videoResolution,
      'iso_range': isoRange,
      'weight': weight,
    };
  }
}

class Product {
  final String id;
  final String createdBy;
  final String name;
  final String category;
  final double price;
  final String currency;
  final String brand;
  final String description;
  final Specs specs;
  final int stock;
  final double rating;
  final List<String> images;
  final bool featured;
  final DateTime createdAt;
  final DateTime updatedAt;

  Product({
    required this.id,
    required this.createdBy,
    required this.name,
    required this.category,
    required this.price,
    required this.currency,
    required this.brand,
    required this.description,
    required this.specs,
    required this.stock,
    required this.rating,
    required this.images,
    required this.featured,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['_id'],
      createdBy: json['createdBy'],
      name: json['name'],
      category: json['category'],
      price: json['price'].toDouble(),
      currency: json['currency'],
      brand: json['brand'],
      description: json['description'],
      specs: Specs.fromJson(json['specs']),
      stock: json['stock'],
      rating: json['rating'].toDouble(),
      images: List<String>.from(json['images']),
      featured: json['featured'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'createdBy': createdBy,
      'name': name,
      'category': category,
      'price': price,
      'currency': currency,
      'brand': brand,
      'description': description,
      'specs': specs.toJson(),
      'stock': stock,
      'rating': rating,
      'images': images,
      'featured': featured,
    };
  }
}