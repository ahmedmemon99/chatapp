import 'package:flutter/material.dart';


class CustomRouteTransaction<T> extends MaterialPageRoute<T>{
  CustomRouteTransaction({
    WidgetBuilder? builder,
    RouteSettings? settings
  }) : super(builder: builder!,settings: settings);

  @override
  Widget buildTransitions(
      BuildContext context,
      Animation<double> animation,
      Animation<double> secondaryAnimation,
      Widget child) {
      return FadeTransition(opacity: animation,child: child,);
  }
}