import 'package:first_app/models/shop_app/login_model.dart';
import 'package:first_app/modules/shop_app/cubit/states.dart';
import 'package:first_app/shared/Network/end_points.dart';
import 'package:first_app/shared/Network/remote/dio_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ShopLoginCubit extends Cubit<ShopLoginStates> {
  ShopLoginCubit() : super(ShopLoginInitialStates());
  static ShopLoginCubit get(context) => BlocProvider.of(context);
  ShopLoginModel loginModel;

  void userLogin({@required String email, @required String password}) {
    emit(ShopLoginLoadingStates());
    DioHelper.postData(url: LOGIN, data: {'email': email, 'password': password})
        .then((value) {
      print(value.data);
      loginModel = ShopLoginModel.fromJson(value.data);
      emit(ShopLoginSuccessStates(loginModel));
    }).catchError((error) {
      emit(ShopLoginErrorStates(error.toString()));
    });
  }

  bool isPassword = true;
  IconData suffix = Icons.visibility_outlined;
  void changePasswordVisibility() {
    isPassword = !isPassword;
    suffix =
        isPassword ? Icons.visibility_outlined : Icons.visibility_off_outlined;
    emit(ShopChangePasswordVisibilityStates());
  }
}
