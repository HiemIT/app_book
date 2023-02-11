import 'package:app_book/models/user_data.dart';

class Login {
  final int? code;
  final UserData? data;

  Login({this.code, this.data});

  factory Login.fromJSON(Map<String, dynamic> json) {
    final int? code = json['code'];
    UserData? data;
    if (code == 200) {
      data = UserData.fromJson(json['data']);
    }
    return Login(code: code, data: data);
  }
}
