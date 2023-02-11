import 'package:app_book/blocs/app_state_bloc.dart';
import 'package:app_book/modules/authentication/bloc/authentication_bloc.dart';
import 'package:app_book/providers/bloc_provider.dart';
import 'package:app_book/route/route_name.dart';
import 'package:app_book/route/routes.dart';
import 'package:flutter/material.dart';

class MyApp extends StatefulWidget {
  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey();

  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final appStateBloc = AppStateBloc();
  late AuthenticationBloc _authenticationBloc;
  static final GlobalKey<State> key = GlobalKey();

  @override
  void initState() {
    super.initState();
    _authenticationBloc = AuthenticationBloc();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      bloc: appStateBloc,
      child: StreamBuilder<AppState>(
          stream: appStateBloc.appState,
          initialData: appStateBloc.initState,
          builder: (context, snapshot) {
            if (snapshot.data == AppState.loading) {
              return MaterialApp(
                debugShowCheckedModeBanner: false,
                home: Container(
                  color: Colors.white,
                ),
              );
            }
            if (snapshot.data == AppState.unAuthorized) {
              return BlocProvider(
                bloc: _authenticationBloc,
                child: MaterialApp(
                  key: const ValueKey('UnAuthorized'),
                  themeMode: ThemeMode.light,
                  builder: _builder,
                  // initialRoute: RouteName.welcomePage,
                  onGenerateRoute: Routes.unAuthorizedRoute,
                  debugShowCheckedModeBanner: false,
                ),
              );
            }

            return MaterialApp(
              debugShowCheckedModeBanner: false,
              initialRoute: '/',
              onGenerateRoute: Routes.authorizedRoute,
              theme: ThemeData(
                primaryColor: const Color(0xfff54b64),
              ),
              key: key,
              builder: _builder,
              navigatorKey: MyApp.navigatorKey,
            );
          },),
    );
  }

  Widget _builder(BuildContext context, Widget? child) {
    // get the current media query
    final data = MediaQuery.of(context);
    // return a new media query with the same data, except with a text scale factor of 1
    return MediaQuery(
      data: data.copyWith(textScaleFactor: 1),
      child: child!,
    );
  }
}
