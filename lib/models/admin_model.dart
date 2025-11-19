class AdminModel {
  int? code;
  String? message;
  Admin? admin;

  AdminModel({this.code, this.message, this.admin});

  AdminModel.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    message = json['message'];
    admin = json['admin'] != null ? new Admin.fromJson(json['admin']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['message'] = this.message;
    if (this.admin != null) {
      data['admin'] = this.admin!.toJson();
    }
    return data;
  }
}

class Admin {
  String? email;
  String? role;

  Admin({this.email, this.role});

  Admin.fromJson(Map<String, dynamic> json) {
    email = json['email'];
    role = json['role'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['email'] = this.email;
    data['role'] = this.role;
    return data;
  }
}
