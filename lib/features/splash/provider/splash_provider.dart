import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../auth/presentation/get_started_screen.dart';
import '../../home/presentation/home_screen.dart';

class SplashProvider extends ChangeNotifier{

  Alignment logoAlignment = Alignment.topCenter;
  Alignment handAlignment = const Alignment(-30, 0);


  Future <void> getData(BuildContext context) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var token = preferences.getString('token');
    await Future.delayed(Duration(seconds: 2));
    if (token == null) {
      context.goNamed(GetStartedScreen.route);
    }else{
      context.goNamed(Home.route);
    }

  }


}