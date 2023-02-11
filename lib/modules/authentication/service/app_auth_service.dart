import 'package:app_book/models/user_data.dart';

import '../../../providers/api_provider.dart';
import '../../../resource/token_manager.dart';

class AppAuth {
  Future<void> saveData(UserData login) async {
    final tm = TokenManager()..accessToken = login.token;
    tm.save();
  }
}
