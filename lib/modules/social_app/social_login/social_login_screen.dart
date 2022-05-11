import 'package:conditional_builder/conditional_builder.dart';
import 'package:first_app/layout/social_app/cubit/social_cubit.dart';
import 'package:first_app/layout/social_app/social_layout.dart';
import 'package:first_app/modules/social_app/social_login/cubit/cubit.dart';
import 'package:first_app/modules/social_app/social_login/cubit/state.dart';
import 'package:first_app/shared/Network/local/cache_helper.dart';
import 'package:first_app/shared/components/components.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';

class SocialLoginScreen extends StatelessWidget {
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => SocialLoginCubit(),
      child: BlocConsumer<SocialLoginCubit, SocialLoginStates>(
        listener: (context, state) {
          if (state is SocialLoginErrorStates) {
            showToast(text: state.error, state: ToastStates.ERROR);
          }
          if (state is SocialLoginSuccessStates) {
            CacheHelper.saveData(key: 'uId', value: state.uId)
                .then((value) async {
              SocialCubit.get(context).getPosts();
              SocialCubit.get(context).getUserData();
              navigateAndFinish(context, SocialLayOut());
              showToast(text: 'Login Success', state: ToastStates.SUCCESS);
            });
          }
        },
        builder: (context, state) {
          return Scaffold(
            backgroundColor: HexColor('#212F3D'),
            appBar: AppBar(
              backgroundColor: HexColor('#212F3D'),
              iconTheme: IconThemeData(color: Colors.white),
            ),
            body: Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12.0),
                          child: Text(
                            'Welcome back',
                            style: Theme.of(context)
                                .textTheme
                                .headline4
                                .copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                          ),
                        ),
                        SizedBox(
                          height: 30.0,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12.0),
                          child: TextFormField(
                            decoration: InputDecoration(
                              fillColor: Colors.grey.withOpacity(0.3),
                              filled: true,
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.grey.withOpacity(0.3)),
                                  borderRadius: BorderRadius.circular(25.0)),
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 20.0, vertical: 5.0),
                              hintText: 'Email',
                              hoverColor: Colors.white,
                              hintStyle: TextStyle(color: Colors.grey[500]),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30.0),
                              ),
                            ),
                            cursorColor: Colors.white,
                            style: TextStyle(color: Colors.white),
                            controller: emailController,
                            keyboardType: TextInputType.emailAddress,
                            validator: (String value) {
                              if (value.isEmpty) {
                                return 'Please enter your email address';
                              } else {
                                return null;
                              }
                            },
                          ),
                        ),
                        SizedBox(
                          height: 15.0,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12.0),
                          child: TextFormField(
                            decoration: InputDecoration(
                              fillColor: Colors.grey.withOpacity(0.3),
                              filled: true,
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.grey.withOpacity(0.3)),
                                  borderRadius: BorderRadius.circular(25.0)),
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 20.0, vertical: 5.0),
                              hintText: 'Password',
                              hintStyle: TextStyle(color: Colors.grey[500]),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30.0),
                              ),
                            ),
                            onFieldSubmitted: (value) {
                              if (formKey.currentState.validate()) {
                                SocialLoginCubit.get(context).userLogin(
                                    email: emailController.text,
                                    password: passwordController.text);
                              }
                            },
                            cursorColor: Colors.white,
                            obscureText: true,
                            style: TextStyle(color: Colors.white),
                            controller: passwordController,
                            keyboardType: TextInputType.visiblePassword,
                            validator: (String value) {
                              if (value.isEmpty) {
                                return 'Please enter your password';
                              } else {
                                return null;
                              }
                            },
                          ),
                        ),
                        SizedBox(
                          height: 30.0,
                        ),
                        ConditionalBuilder(
                            condition: state is! SocialLoginLoadingStates,
                            builder: (context) => Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12.0),
                                  child: defaultButton(
                                      function: () {
                                        if (formKey.currentState.validate()) {
                                          SocialLoginCubit.get(context)
                                              .userLogin(
                                                  email: emailController.text,
                                                  password:
                                                      passwordController.text);
                                        }
                                      },
                                      text: 'Log In',
                                      isUpperCase: false,
                                      textStyle: TextStyle(
                                          color: Colors.black, fontSize: 18.0),
                                      background: Colors.amber,
                                      radius: 30.0),
                                ),
                            fallback: (context) => Center(
                                    child: CircularProgressIndicator(
                                  color: Colors.amber,
                                ))),
                        SizedBox(
                          height: 15.0,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
