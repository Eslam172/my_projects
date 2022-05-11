import 'package:first_app/models/shop_app/login_model.dart';

abstract class ShopLoginStates {}

class ShopLoginInitialStates extends ShopLoginStates {}

class ShopLoginSuccessStates extends ShopLoginStates {
  final ShopLoginModel loginModel;

  ShopLoginSuccessStates(this.loginModel);
}

class ShopLoginLoadingStates extends ShopLoginStates {}

class ShopChangePasswordVisibilityStates extends ShopLoginStates {}

class ShopLoginErrorStates extends ShopLoginStates {
  final String error;
  ShopLoginErrorStates(this.error);
}
