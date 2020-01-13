
import 'package:flutter/material.dart';
import '../pages/homepage.dart';

Map<String,WidgetBuilder> getApplicationRoutes(){
  return <String,WidgetBuilder>{
    '/':(BuildContext context)=>HomePage(),

  };
}
