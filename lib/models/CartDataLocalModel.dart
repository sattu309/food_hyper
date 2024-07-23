class CartItem {
  dynamic id;
  dynamic usersId;
  dynamic sessionId;
  dynamic productId;
  dynamic productVariantId;
  dynamic orderId;
  dynamic price;
  dynamic salePrice;
  dynamic status;
  dynamic qty;
  dynamic amount;
  dynamic discount;
  dynamic productName;
  dynamic varName;
  dynamic slug;
  dynamic cartMsg;
  dynamic isPromo;
  dynamic isStoreStock;
  dynamic image;

  CartItem({
    required this.id,
    required this.usersId,
    required this.sessionId,
    required this.productId,
    required this.productVariantId,
    required this.orderId,
    required this.price,
    required this.salePrice,
    required this.status,
    required this.qty,
    required this.amount,
    required this.discount,
    required this.productName,
    required this.varName,
    required this.slug,
    required this.cartMsg,
    required this.isPromo,
    required this.isStoreStock,
    required this.image,
  });

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      id: json['id'],
      usersId: json['users_id'],
      sessionId: json['sessionid'],
      productId: json['product_id'],
      productVariantId: json['productvariant_id'],
      orderId: json['order_id'],
      price: json['price'],
      salePrice: json['saleprice'],
      status: json['status'],
      qty: json['qty'],
      amount: json['amount'],
      discount: json['discount'],
      productName: json['productname'],
      varName: json['varname'],
      slug: json['slug'],
      cartMsg: json['cartmsg'],
      isPromo: json['is_promo'],
      isStoreStock: json['is_storestock'],
      image: json['image'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'users_id': usersId,
      'sessionid': sessionId,
      'product_id': productId,
      'productvariant_id': productVariantId,
      'order_id': orderId,
      'price': price,
      'saleprice': salePrice,
      'status': status,
      'qty': qty,
      'amount': amount,
      'discount': discount,
      'productname': productName,
      'varname': varName,
      'slug': slug,
      'cartmsg': cartMsg,
      'is_promo': isPromo,
      'is_storestock': isStoreStock,
      'image': image,
    };
  }
}
