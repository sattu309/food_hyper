class LoginTokenModel {
  dynamic id;
  dynamic authToken;
  dynamic username;
  dynamic email;
  dynamic firstName;
  dynamic lastName;

  LoginTokenModel({this.id, this.authToken,this.username,this.email,this.firstName,this.lastName});

  LoginTokenModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    username = json['username'];
    email = json['email'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    authToken = json['authToken'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['username'] = this.username;
    data['email'] = this.email;
    data['firstName'] = this.firstName;
    data['lastName'] = this.lastName;
    data['authToken'] = this.authToken;
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
//   dynamic username;
//   dynamic email;
//   dynamic lusername;
//   dynamic mobile;
//   dynamic rememberToken;
//
//   Login(
//       {this.id,
//         this.username,
//         this.email,
//         this.lusername,
//         this.mobile,
//         this.rememberToken});
//
//   Login.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     username = json['username'];
//     email = json['email'];
//     lusername = json['lusername'];
//     mobile = json['mobile'];
//     rememberToken = json['remember_token'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['id'] = this.id;
//     data['username'] = this.username;
//     data['email'] = this.email;
//     data['lusername'] = this.lusername;
//     data['mobile'] = this.mobile;
//     data['remember_token'] = this.rememberToken;
//     return data;
//   }
// }

