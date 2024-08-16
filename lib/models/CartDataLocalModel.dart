class CartItem {
  String? subtotal;
  String? total;
  String? shippingTotal;
  Contents? contents;

  CartItem({this.subtotal, this.total, this.shippingTotal, this.contents});

  CartItem.fromJson(Map<String, dynamic> json) {
    subtotal = json['subtotal'];
    total = json['total'];
    shippingTotal = json['shippingTotal'];
    contents = json['contents'] != null
        ? new Contents.fromJson(json['contents'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['subtotal'] = this.subtotal;
    data['total'] = this.total;
    data['shippingTotal'] = this.shippingTotal;
    if (this.contents != null) {
      data['contents'] = this.contents!.toJson();
    }
    return data;
  }
}

class Contents {
  List<Product>? product;
  int? quantity;
  String? subtotal;
  String? subtotalTax;
  String? total;
  String? tax;
  Null? variation;

  Contents(
      {this.product,
        this.quantity,
        this.subtotal,
        this.subtotalTax,
        this.total,
        this.tax,
        this.variation});

  Contents.fromJson(Map<String, dynamic> json) {
    if (json['product'] != null) {
      product = <Product>[];
      json['product'].forEach((v) {
        product!.add(new Product.fromJson(v));
      });
    }
    quantity = json['quantity'];
    subtotal = json['subtotal'];
    subtotalTax = json['subtotalTax'];
    total = json['total'];
    tax = json['tax'];
    variation = json['variation'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.product != null) {
      data['product'] = this.product!.map((v) => v.toJson()).toList();
    }
    data['quantity'] = this.quantity;
    data['subtotal'] = this.subtotal;
    data['subtotalTax'] = this.subtotalTax;
    data['total'] = this.total;
    data['tax'] = this.tax;
    data['variation'] = this.variation;
    return data;
  }
}

class Product {
  String? name;
  String? sku;
  int? databaseId;
  int? productId;

  Product({this.name, this.sku, this.databaseId, this.productId});

  Product.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    sku = json['sku'];
    databaseId = json['databaseId'];
    productId = json['productId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['sku'] = this.sku;
    data['databaseId'] = this.databaseId;
    data['productId'] = this.productId;
    return data;
  }
}
