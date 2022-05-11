import 'package:conditional_builder/conditional_builder.dart';
import 'package:first_app/layout/shop_app/cubit/cubit.dart';
import 'package:first_app/layout/shop_app/shop_layout.dart';
import 'package:first_app/modules/shop_app/cubit/cubit.dart';
import 'package:first_app/modules/shop_app/cubit/states.dart';
import 'package:first_app/modules/shop_app/register_screen/register_screen.dart';
import 'package:first_app/shared/Network/local/cache_helper.dart';
import 'package:first_app/shared/components/components.dart';
import 'package:first_app/shared/components/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ShopLoginScreen extends StatelessWidget {
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => ShopLoginCubit(),
      child: BlocConsumer<ShopLoginCubit, ShopLoginStates>(
        listener: (context, states) {
          if (states is ShopLoginSuccessStates) {
            if (states.loginModel.status) {
              print(states.loginModel.message);
              print(states.loginModel.data.token);
              showToast(
                  text: states.loginModel.message, state: ToastStates.SUCCESS);
              CacheHelper.saveData(
                      key: 'token', value: states.loginModel.data.token)
                  .then((value) {
                token = states.loginModel.data.token;
                ShopCubit.get(context).currentIndex = 0;
                navigateAndFinish(context, ShopLayout());
              });
            } else {
              print(states.loginModel.message);
              showToast(
                text: states.loginModel.message,
                state: ToastStates.ERROR,
              );
            }
          }
        },
        builder: (context, states) {
          return Scaffold(
            backgroundColor: Colors.grey,
            appBar: AppBar(
              backgroundColor: Colors.grey,
              systemOverlayStyle: SystemUiOverlayStyle(
                  statusBarColor: Colors.grey,
                  statusBarIconBrightness: Brightness.light),
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
                        Text(
                          'LOGIN',
                          style: Theme.of(context).textTheme.headline4.copyWith(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        Text(
                          'Login now to browse our hot offers',
                          style: Theme.of(context)
                              .textTheme
                              .bodyText1
                              .copyWith(color: Colors.black),
                        ),
                        SizedBox(
                          height: 30.0,
                        ),
                        defaultFormField(
                            textStyle: TextStyle(color: Colors.white),
                            colorLayout: Colors.blue,
                            controller: emailController,
                            type: TextInputType.emailAddress,
                            validated: (String value) {
                              if (value.isEmpty) {
                                return 'Please enter your email address';
                              }
                            },
                            prefix: Icons.email_outlined,
                            label: 'Email Address'),
                        SizedBox(
                          height: 15.0,
                        ),
                        defaultFormField(
                            textStyle: TextStyle(color: Colors.white),
                            onSubmit: (value) {
                              if (formKey.currentState.validate()) {
                                ShopLoginCubit.get(context).userLogin(
                                    email: emailController.text,
                                    password: passwordController.text);
                              }
                            },
                            colorLayout: Colors.blue,
                            isPassword: ShopLoginCubit.get(context).isPassword,
                            controller: passwordController,
                            type: TextInputType.visiblePassword,
                            validated: (String value) {
                              if (value.isEmpty) {
                                return 'Password is too short';
                              }
                            },
                            suffixPressed: ShopLoginCubit.get(context)
                                .changePasswordVisibility,
                            prefix: Icons.lock_outline,
                            suffix: ShopLoginCubit.get(context).suffix,
                            label: 'Password'),
                        SizedBox(
                          height: 30.0,
                        ),
                        ConditionalBuilder(
                            condition: states is! ShopLoginLoadingStates,
                            builder: (context) => defaultButton(
                                function: () {
                                  if (formKey.currentState.validate()) {
                                    ShopLoginCubit.get(context).userLogin(
                                        email: emailController.text,
                                        password: passwordController.text);
                                  }
                                },
                                text: 'Login',
                                isUpperCase: true,
                                background: Colors.blue,
                                radius: 30.0),
                            fallback: (context) =>
                                Center(child: CircularProgressIndicator())),
                        SizedBox(
                          height: 15.0,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Don\'t have an account?',
                              style: TextStyle(
                                  color: Colors.white, fontSize: 18.0),
                            ),
                            defaultTextButton(
                              function: () {
                                navigateTo(context, RegisterScreen());
                              },
                              text: 'register',
                            ),
                          ],
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
