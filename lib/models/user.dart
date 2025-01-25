enum UserRole {
  BUYER,
  SELLER,
  ADMIN,
}

class CartItem {
  final String productId;
  final int quantity;

  CartItem({
    required this.productId,
    required this.quantity,
  });

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      productId: json['product'],
      quantity: json['quantity'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'product': productId,
      'quantity': quantity,
    };
  }
}

class User {
  final String id;
  final String name;
  final String email;
  final UserRole role;
  final List<CartItem> cart;
  final DateTime createdAt;
  final DateTime updatedAt;

  User({
    required this.id,
    required this.name,
    required this.email,
    this.role = UserRole.BUYER,
    this.cart = const [],
    required this.createdAt,
    required this.updatedAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['_id'],
      name: json['name'],
      email: json['email'],
      role: UserRole.values.firstWhere(
        (e) => e.toString() == 'UserRole.${json['role']}',
        orElse: () => UserRole.BUYER,
      ),
      cart: (json['cart'] as List?)
          ?.map((item) => CartItem.fromJson(item))
          .toList() ??
          [],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }
}