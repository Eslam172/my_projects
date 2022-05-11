import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:first_app/models/social_app/social_user_model.dart';
import 'package:first_app/modules/social_app/social_register/register_cubit/state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SocialRegisterCubit extends Cubit<SocialRegisterStates> {
  SocialRegisterCubit() : super(SocialRegisterInitialStates());
  static SocialRegisterCubit get(context) => BlocProvider.of(context);
  void userRegister(
      {@required String email,
      @required String password,
      @required String name,
      @required String phone}) {
    emit(SocialRegisterLoadingStates());
    FirebaseAuth.instance
        .createUserWithEmailAndPassword(
      email: email,
      password: password,
    )
        .then((value) {
      userCreate(email: email, name: name, phone: phone, uId: value.user.uid);
      // print(value.user.email);
      // print(value.user.uid);
      // emit(SocialRegisterSuccessStates());
    }).catchError((error) {
      print(error.toString());
      emit(SocialRegisterErrorStates(error.toString()));
    });
  }

  void userCreate(
      {@required String email,
      @required String name,
      @required String phone,
      @required String uId}) {
    SocialUserModel model = SocialUserModel(
      name: name,
      email: email,
      phone: phone,
      uId: uId,
      image:
          'https://img.freepik.com/free-photo/close-up-male-hands-using-smartphone_1262-16914.jpg?w=740',
      isEmailVerified: false,
      bio: 'write your bio...',
      cover:
          'https://img.freepik.com/free-photo/social-media-instagram-digital-marketing-concept-3d-rendering_106244-1717.jpg?w=740',
    );
    FirebaseFirestore.instance
        .collection('users')
        .doc(uId)
        .set(model.toMap())
        .then((value) {
      emit(SocialCreateUserSuccessStates(uId));
    }).catchError((error) {
      print(error.toString());
      emit(SocialCreateUserErrorStates(error.toString()));
    });
  }

  bool isPassword = true;
  IconData suffix = Icons.visibility_outlined;
  void changePasswordVisibility() {
    isPassword = !isPassword;
    suffix =
        isPassword ? Icons.visibility_outlined : Icons.visibility_off_outlined;
    emit(SocialChangeRegisterPasswordVisibilityStates());
  }
}
