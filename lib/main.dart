import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:first_app/modules/bmi/bmi/bmi_screen.dart';
import 'package:first_app/modules/design/whats%20app/whatsapp_screen.dart';
import 'package:page_transition/page_transition.dart';
import 'package:bloc/bloc.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:first_app/layout/news_app/cubit/cubit.dart';
import 'package:first_app/layout/news_app/news_layout.dart';
import 'package:first_app/layout/shop_app/cubit/cubit.dart';
import 'package:first_app/layout/shop_app/shop_layout.dart';
import 'package:first_app/layout/social_app/cubit/social_cubit.dart';
import 'package:first_app/layout/social_app/social_layout.dart';
import 'package:first_app/layout/todo_app/todo_layout.dart';
import 'package:first_app/modules/shop_app/login/shop_login.dart';
import 'package:first_app/modules/social_app/social_login/social_login_screen.dart';
import 'package:first_app/modules/social_app/splash_screen/splash_screen.dart';
import 'package:first_app/modules/users/users_screen.dart';
import 'package:first_app/shared/Network/local/cache_helper.dart';
import 'package:first_app/shared/Network/remote/dio_helper.dart';
import 'package:first_app/shared/bloc_observer.dart';
import 'package:first_app/shared/components/components.dart';
import 'package:first_app/shared/components/constants.dart';
import 'package:first_app/shared/cubit/cubit.dart';
import 'package:first_app/shared/cubit/states.dart';
import 'package:first_app/shared/style/themes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'modules/counter/counter_screen.dart';
import 'lib.dart';
import 'modules/shop_app/on_boarding/on_boarding_screen.dart';
import 'modules/social_app/start_screen/start_screen.dart';

Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onMessage.listen((event) {});
  FirebaseMessaging.onMessageOpenedApp.listen((event) {});
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

  Bloc.observer = MyBlocObserver();
  // BlocOverrides.runZoned(
  //   () {
  //     // Use cubits...
  //   },
  //   blocObserver: MyBlocObserver(),
  // );
  DioHelper.init();
  await CacheHelper.init();
  Widget widget;
  bool isDark = CacheHelper.getData(key: 'isDark');
  // bool onBoarding = CacheHelper.getData(key: 'onBoarding');
  //  token = CacheHelper.getData(key: 'token');
  uId = CacheHelper.getData(key: 'uId');
  //print(token.toString());
  // if (onBoarding != null) {
  //   if (token != null)
  //     widget = ShopLayout();
  //   else {
  //     widget = ShopLoginScreen();
  //   }
  // } else {
  //   widget = OnBoardingScreen();
  // }
  if (uId != null) {
    widget = SocialLayOut();
  } else {
    widget = StartScreen();
  }
  runApp(MyApp(
    isDark: isDark,
    startWidget: widget,
  ));
}

class MyApp extends StatelessWidget {
  final bool isDark;
  final Widget startWidget;

  MyApp({this.isDark, this.startWidget});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (BuildContext context) => NewsCubit()..getBusiness(),
        ),
        BlocProvider(
          create: (BuildContext context) =>
              AppCubit()..changeAppMode(fromShared: isDark),
        ),
        BlocProvider(
          create: (BuildContext context) => ShopCubit()
            ..getHomeData()
            ..getCategories()
            ..getFavorites()
            ..getUserData(),
        ),
        BlocProvider(
            create: (BuildContext context) => SocialCubit()
              ..getUserData()
              ..getPosts()
              ..getComment()
              ..getAllUser()
              ..getUnReadNotificationsCount(uId)),
      ],
      child: BlocConsumer<AppCubit, AppStates>(
        listener: (context, state) {},
        builder: (context, state) {
          return MaterialApp(
            theme: lightTheme,
            darkTheme: darkTheme,
            themeMode:
                AppCubit.get(context).isDark ? ThemeMode.dark : ThemeMode.light,
            debugShowCheckedModeBanner: false,
            home: AnimatedSplashScreen(
              splash: SplashScreen(),
              nextScreen: startWidget,
              backgroundColor: HexColor('#212F3D'),
              splashTransition: SplashTransition.scaleTransition,
              animationDuration: Duration(milliseconds: 2000),
              pageTransitionType: PageTransitionType.topToBottom,
              duration: 3000,
            ),
          );
        },
      ),
    );
  }
}
