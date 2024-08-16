class CartOwnModel {
  final String subtotal;
  final String total;
  final String shippingTotal;
  List<Product> products;

  CartOwnModel({
    required this.subtotal,
    required this.total,
    required this.shippingTotal,
    required this.products,
  });

  factory CartOwnModel.fromJson(Map<String, dynamic> json) {
    var productsJson = json['products'] as List<dynamic>?; // Fixed key to 'products'
    List<Product> productsList = productsJson != null
        ? productsJson.map((productJson) => Product.fromJson(productJson as Map<String, dynamic>)).toList()
        : [];

    return CartOwnModel(
      subtotal: json['subtotal'] as String,
      total: json['total'] as String,
      shippingTotal: json['shippingTotal'] as String,
      products: productsList,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'subtotal': subtotal,
      'total': total,
      'shippingTotal': shippingTotal,
      'products': products.map((product) => product.toJson()).toList(),
    };
  }
}

class Product {
  String? name;
  String? sku;
  int? databaseId;
  int? productId;
  List<String>? images;

  Product({
    this.name,
    this.sku,
    this.databaseId,
    this.productId,
    this.images,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    var imagesFromJson = json['images'] as List<dynamic>?;
    List<String>? imagesList = imagesFromJson?.map((image) => image as String).toList();

    return Product(
      name: json['name'] as String?,
      sku: json['sku'] as String?,
      databaseId: json['databaseId'] as int?,
      productId: json['productId'] as int?,
      images: imagesList,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'sku': sku,
      'databaseId': databaseId,
      'productId': productId,
      'images': images,
    };
  }
}
