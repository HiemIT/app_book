import 'package:app_book/route/route_name.dart';
import 'package:flutter/material.dart';

import '../modules/authentication/pages/login_screen.dart';
import '../modules/home/pages/home_screen.dart';

class Routes {
  static Route authorizedRoute(RouteSettings settings) {
    switch (settings.name) {
      case RouteName.home:
        return _buildRoute(settings, const HomeScreen());
      // case RouteName.order:
      //   final orderId = settings.arguments;
      //   if (orderId is ShoppingCart) {
      //     return _buildRoute(
      //       settings,
      //       BlocProvider(
      //         bloc: CheckoutBloc(orderId: orderId.orderId ?? ''),
      //         child: const CheckOutPage(),
      //       ),
      //     );
      //   }
      //   return _errorRoute();
      case RouteName.login:
        return _buildRoute(settings, const LoginScreen());
      case RouteName.register:
      // return _buildRoute(settings, RegisterScreen());
      case RouteName.splash:
      return _buildRoute(settings, Container());
      default:
        return _errorRoute();
    }
  }

  static Route unAuthorizedRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return _buildRoute(settings, const LoginScreen());

      default:
        return _errorRoute();
    }
  }

  static Route _errorRoute() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Coming soon'),
        ),
        body: const Center(
          child: Text('Page not found'),
        ),
      );
    });
  }

  static MaterialPageRoute _buildRoute(RouteSettings settings, Widget builder) {
    return MaterialPageRoute(
      settings: settings,
      builder: (BuildContext context) => builder,
    );
  }
}
