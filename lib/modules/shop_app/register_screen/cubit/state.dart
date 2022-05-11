import 'package:first_app/models/shop_app/login_model.dart';

abstract class ShopRegisterStates {}

class ShopRegisterInitialStates extends ShopRegisterStates {}

class ShopRegisterSuccessStates extends ShopRegisterStates {
  final ShopLoginModel loginModel;

  ShopRegisterSuccessStates(this.loginModel);
}

class ShopRegisterLoadingStates extends ShopRegisterStates {}

class ShopChangeRegisterPasswordVisibilityStates extends ShopRegisterStates {}

class ShopRegisterErrorStates extends ShopRegisterStates {
  final String error;
  ShopRegisterErrorStates(this.error);
}
