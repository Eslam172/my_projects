// base url: https://newsapi.org/

// methode (url):v2/top-headlines?

// quires : country=eg&category=business&apiKey=1ebb0bd50a9841b292c6401de955fe3e

// search : https://newsapi.org/v2/everything?q=tesla&apiKey=1ebb0bd50a9841b292c6401de955fe3e

import 'package:first_app/layout/shop_app/cubit/cubit.dart';
import 'package:first_app/modules/shop_app/login/shop_login.dart';
import 'package:first_app/modules/social_app/start_screen/start_screen.dart';
import 'package:first_app/shared/Network/local/cache_helper.dart';

import 'components.dart';

void signOut(context) {
  CacheHelper.removeData(key: 'uId').then((value) {
    if (value) {
      navigateAndFinish(context, StartScreen());
    }
  });
}

String token = '';

String uId = '';
