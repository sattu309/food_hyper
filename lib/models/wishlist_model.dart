class WishListDataModel {
  Data? data;

  WishListDataModel({this.data});

  WishListDataModel.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  List<Wishlist>? wishlist;

  Data({this.wishlist});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['wishlist'] != null) {
      wishlist = <Wishlist>[];
      json['wishlist'].forEach((v) {
        wishlist!.add(new Wishlist.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.wishlist != null) {
      data['wishlist'] = this.wishlist!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Wishlist {
  String? id;
  String? usersId;
  String? productId;
  String? productname;
  String? slug;
  String? image;
  int? price;
  int? minprice;
  int? maxprice;

  Wishlist(
      {this.id,
        this.usersId,
        this.productId,
        this.productname,
        this.slug,
        this.image,
        this.price,
        this.minprice,
        this.maxprice});

  Wishlist.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    usersId = json['users_id'];
    productId = json['product_id'];
    productname = json['productname'];
    slug = json['slug'];
    image = json['image'];
    price = json['price'];
    minprice = json['minprice'];
    maxprice = json['maxprice'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['users_id'] = this.usersId;
    data['product_id'] = this.productId;
    data['productname'] = this.productname;
    data['slug'] = this.slug;
    data['image'] = this.image;
    data['price'] = this.price;
    data['minprice'] = this.minprice;
    data['maxprice'] = this.maxprice;
    return data;
  }
}
