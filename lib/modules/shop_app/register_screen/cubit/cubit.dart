import 'package:first_app/models/shop_app/login_model.dart';
import 'package:first_app/modules/shop_app/cubit/states.dart';
import 'package:first_app/modules/shop_app/register_screen/cubit/state.dart';
import 'package:first_app/shared/Network/end_points.dart';
import 'package:first_app/shared/Network/remote/dio_helper.dart';
import 'package:first_app/shared/components/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ShopRegisterCubit extends Cubit<ShopRegisterStates> {
  ShopRegisterCubit() : super(ShopRegisterInitialStates());
  static ShopRegisterCubit get(context) => BlocProvider.of(context);
  ShopLoginModel loginModel;

  void userRegister(
      {@required String email,
      @required String password,
      @required String name,
      @required String phone}) {
    emit(ShopRegisterLoadingStates());
    DioHelper.postData(
      url: REGiSTER,
      data: {
        'email': email,
        'password': password,
        'name': name,
        'phone': phone
      },
      token: token,
    ).then((value) {
      print(value.data);
      loginModel = ShopLoginModel.fromJson(value.data);
      token = loginModel.data.token;
      emit(ShopRegisterSuccessStates(loginModel));
    }).catchError((error) {
      emit(ShopRegisterErrorStates(error.toString()));
    });
  }

  bool isPassword = true;
  IconData suffix = Icons.visibility_outlined;
  void changePasswordVisibility() {
    isPassword = !isPassword;
    suffix =
        isPassword ? Icons.visibility_outlined : Icons.visibility_off_outlined;
    emit(ShopChangeRegisterPasswordVisibilityStates());
  }
}
