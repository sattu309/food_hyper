class LoginTokenModel {
  dynamic? id;
  dynamic rememberToken;
  dynamic name;
  dynamic email;

  LoginTokenModel({this.id, this.rememberToken,this.name,this.email});

  LoginTokenModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    rememberToken = json['remember_token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['email'] = this.email;
    data['remember_token'] = this.rememberToken;
    return data;
  }
}

// class LoginTokenModel {
//   Data? data;
//
//   LoginTokenModel({this.data});
//
//   LoginTokenModel.fromJson(Map<String, dynamic> json) {
//     data = json['data'] != null ? new Data.fromJson(json['data']) : null;
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     if (this.data != null) {
//       data['data'] = this.data!.toJson();
//     }
//     return data;
//   }
// }
//
// class Data {
//   Login? login;
//
//   Data({this.login});
//
//   Data.fromJson(Map<String, dynamic> json) {
//     login = json['login'] != null ? new Login.fromJson(json['login']) : null;
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     if (this.login != null) {
//       data['login'] = this.login!.toJson();
//     }
//     return data;
//   }
// }
//
// class Login {
//   dynamic id;
//   dynamic name;
//   dynamic email;
//   dynamic lname;
//   dynamic mobile;
//   dynamic rememberToken;
//
//   Login(
//       {this.id,
//         this.name,
//         this.email,
//         this.lname,
//         this.mobile,
//         this.rememberToken});
//
//   Login.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     name = json['name'];
//     email = json['email'];
//     lname = json['lname'];
//     mobile = json['mobile'];
//     rememberToken = json['remember_token'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['id'] = this.id;
//     data['name'] = this.name;
//     data['email'] = this.email;
//     data['lname'] = this.lname;
//     data['mobile'] = this.mobile;
//     data['remember_token'] = this.rememberToken;
//     return data;
//   }
// }

