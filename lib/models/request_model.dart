class RequestModel {
  int? code;
  List<Requests>? requests;

  RequestModel({this.code, this.requests});

  RequestModel.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    if (json['requests'] != null) {
      requests = <Requests>[];
      json['requests'].forEach((v) {
        requests!.add(new Requests.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    if (this.requests != null) {
      data['requests'] = this.requests!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Requests {
  String? id;
  String? userId;
  String? email;
  String? createdAt;
  String? role;

  Requests({this.id, this.userId, this.email, this.createdAt, this.role});

  Requests.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    email = json['email'];
    createdAt = json['created_at'];
    role = json['role'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['email'] = this.email;
    data['created_at'] = this.createdAt;
    data['role'] = this.role;
    return data;
  }
}
