import 'dart:async';

import 'package:app_book/models/user_data.dart';
import 'package:app_book/modules/authentication/enum/login_state.dart';
import 'package:app_book/modules/authentication/repos/authentication_repo.dart';
import 'package:app_book/providers/bloc_provider.dart';
import 'package:app_book/utils/validation.dart';
import 'package:rxdart/rxdart.dart';

class AuthenticationBloc extends BlocBase {
  late AuthenticationRepo _authenticationRepo;
  final _phoneSubject = BehaviorSubject<String>();
  final _passSubject = BehaviorSubject<String>();
  final _btnSubject = BehaviorSubject<bool>.seeded(false);
  final _loginStateSubject = BehaviorSubject<LoginState>();

  AuthenticationBloc() {
    validateForm();
  }

  var phoneValidation = StreamTransformer<String, String>.fromHandlers(
    handleData: (phone, sink) {
      if (Validation.isPhoneValid(phone)) {
        sink.add('');
        return;
      } else {
        sink.add('Số điện thoại không hợp lệ');
      }
    },
  );

  var passValidation = StreamTransformer<String, String>.fromHandlers(
    handleData: (pass, sink) {
      if (Validation.isPasswordValid(pass)) {
        sink.add('');
        return;
      } else {
        sink.add('Mật khẩu không hợp lệ');
      }
    },
  );

  Stream<String> get phoneStream =>
      _phoneSubject.stream.transform(phoneValidation);

  Sink<String> get phoneSink => _phoneSubject.sink;

  Stream<String> get passStream =>
      _passSubject.stream.transform(passValidation);

  Sink<String> get passSink => _passSubject.sink;

  Stream<bool> get btnStream => _btnSubject.stream;

  Sink<bool> get btnSink => _btnSubject.sink;

  Stream<LoginState> get loginStateStream => _loginStateSubject.stream;

  Sink<LoginState> get loginStateSink => _loginStateSubject.sink;

  validateForm() {
    Rx.combineLatest2(
        _phoneSubject,
        _passSubject,
        (phone, pass) =>
            Validation.isPhoneValid(phone) &&
            Validation.isPasswordValid(pass)).listen((enable) {
      btnSink.add(enable);
    });
  }

  Future<UserData> signIn(String phone, String password) async {
    _authenticationRepo = AuthenticationRepo();
    btnSink.add(false); // khi bắt đầu call all thì nút login sẽ bị disable

    return await _authenticationRepo
        .signIn(phone, password)
        .then((userData) => userData, onError: (error) {
      btnSink.add(true); // khi call api xong thì nút login sẽ được enable
      loginStateSink.add(LoginState.fail);
    });
  }

  @override
  void dispose() {
    _phoneSubject.close();
    _passSubject.close();
    _btnSubject.close();
  }
}
