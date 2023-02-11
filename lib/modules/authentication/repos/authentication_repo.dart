import 'dart:async';

import 'package:app_book/models/user_data.dart';
import 'package:app_book/modules/authentication/service/app_auth_service.dart';
import 'package:app_book/providers/api_provider.dart';
import 'package:dio/dio.dart';

class AuthenticationRepo {
  final apiProvider = ApiProvider();

  Future<UserData> signIn(String phone, String password) async {
    var c = Completer<UserData>();
    try {
      var response = await apiProvider.post('/user/sign-in', data: {
        'phone': phone,
        'password': password,
      });
      var userData = UserData.fromJson(response.data['data']);
      if (userData != null) {
        AppAuth().saveData(userData);
        c.complete(userData);
      }
    } on DioError {
      c.completeError('Đăng nhập thất bại');
    } catch (e) {
      c.completeError(e);
    }
    return c.future;
  }
}
