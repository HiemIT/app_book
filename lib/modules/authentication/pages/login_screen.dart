import 'package:app_book/blocs/app_state_bloc.dart';
import 'package:app_book/common/widgets/stateless/normal_button.dart';
import 'package:app_book/modules/authentication/bloc/authentication_bloc.dart';
import 'package:app_book/providers/bloc_provider.dart';
import 'package:flutter/material.dart';

import '../../../themes/app_style_text.dart';
import '../enum/login_state.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  AppStateBloc? get appStateBloc => BlocProvider.of<AppStateBloc>(context);

  AuthenticationBloc? get authenticationBloc =>
      BlocProvider.of<AuthenticationBloc>(context);

  final TextEditingController _txtPhoneController = TextEditingController();

  final TextEditingController _txtPassController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text('Đăng Nhập'),
        ),
        body: Container(
          color: Colors.white,
          alignment: Alignment.center,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(25),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Text('Login Screen', style: AppStyleText.title),
                  const SizedBox(height: 12),
                  const Text('Login to your account'),
                  const SizedBox(height: 30),
                  _buildPhoneField(),
                  const SizedBox(height: 30),
                  _buildPassField(),
                  const SizedBox(height: 30),
                  buildSignInButton(),
                ],
              ),
            ),
          ),
        ));
  }

  Widget _buildPhoneField() {
    return StreamBuilder<String>(
      stream: authenticationBloc?.phoneStream,
      initialData: null,
      builder: (context, snapshot) {
        return TextField(
          controller: _txtPhoneController,
          onChanged: (text) {
            authenticationBloc?.phoneSink.add(text);
          },
          cursorColor: Colors.black,
          keyboardType: TextInputType.phone,
          decoration: InputDecoration(
              icon: const Icon(
                Icons.phone,
                color: Colors.blue,
              ),
              hintText: '(+84) 973 901 789',
              errorText: snapshot.data,
              labelText: 'Phone',
              labelStyle: const TextStyle(color: Colors.blue)),
        );
      },
    );
  }

  Widget _buildPassField() {
    return StreamBuilder<String>(
        stream: authenticationBloc?.passStream,
        initialData: null,
        builder: (context, snapshot) {
          late String? data = snapshot.data;
          return TextField(
            controller: _txtPassController,
            onChanged: (text) {
              authenticationBloc?.passSink.add(text);
            },
            obscureText: true,
            cursorColor: Colors.black,
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
              icon: Icon(
                Icons.lock,
                color: Colors.blue,
              ),
              hintText: 'Password',
              errorText: data,
              labelText: 'Password',
              labelStyle: TextStyle(color: Colors.blue),
            ),
          );
        });
  }

  Widget buildSignInButton() {
    return StreamBuilder<bool>(
        stream: authenticationBloc?.btnStream,
        initialData: true,
        builder: (context, snapshot) {
          var enable = snapshot.data!;
          return NormalButton(
              onPressed: enable ? () => _changeAppState() : null,
              title: 'Sign In');
        });
  }

  void _changeAppState1() {
    debugPrint('LoginScreen: _changeAppState1');
    debugPrint(
        'LoginScreen: _changeAppState1: _txtPhoneController.text: ${_txtPhoneController.text}');
    debugPrint(
        'LoginScreen: _changeAppState1: _txtPassController.text: ${_txtPassController.text}');
  }

  void _changeAppState() async {
    final res = await authenticationBloc
        ?.signIn(
      _txtPhoneController.text,
      _txtPassController.text,
    )
        .then(
      (res) => appStateBloc?.changeAppState(AppState.authorized),
      onError: (e) {
        appStateBloc?.changeAppState(AppState.unAuthorized);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Đăng nhập thất bại'),
            backgroundColor: Colors.red,
          ),
        );
      },
    );
    // res != null
    //     ? appStateBloc?.changeAppState(AppState.authorized)
    //     : appStateBloc?.changeAppState(AppState.unAuthorized);
  }
}
