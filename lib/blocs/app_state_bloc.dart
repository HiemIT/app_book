import 'package:app_book/providers/bloc_provider.dart';
import 'package:app_book/providers/log_provider.dart';
import 'package:app_book/utils/prefs_key.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Tạo 1 bloc tổng để lắng nghe và điều phối cái app
// pushlish event (1 noi): Event Name & data (optional)
// lisner event (1 hoac n noi)

enum AppState { loading, unAuthorized, authorized }

class AppStateBloc extends BlocBase {
  final _appState = BehaviorSubject<AppState>.seeded(AppState.loading);

//  stream
  Stream<AppState> get appState => _appState.stream;

//  value
  AppState get appStateValue => _appState.stream.value;

  AppState get initState => AppState.loading;

  LogProvider get logger => const LogProvider('⚡️ AppStateBloc');

  // khi app khởi động lần đầu tiên thì sẽ gọi hàm này để lấy trạng thái của app
  AppStateBloc() {
    launchApp();
  }

  Future<void> launchApp() async {
    final prefs = await SharedPreferences.getInstance();
    final authorLevel = prefs.getInt(PrefsKey.authorLevel) ?? 0;
    logger.log('launchApp: $authorLevel');

    switch (authorLevel) {
      case 2:
        await changeAppState(AppState.authorized);
        break;
      default:
        await changeAppState(AppState.unAuthorized);
        break;
    }
  }

  Future<void> changeAppState(AppState state) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(PrefsKey.authorLevel, state.index);
    logger.log('changeAppState: $state');

    _appState.sink.add(state);
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(PrefsKey.authorLevel, 0);
    logger.log('logout');

    _appState.sink.add(AppState.unAuthorized);
  }

  @override
  void dispose() {
    _appState.close();
  }
}
