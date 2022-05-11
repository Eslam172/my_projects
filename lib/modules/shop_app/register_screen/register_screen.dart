import 'package:conditional_builder/conditional_builder.dart';
import 'package:first_app/layout/shop_app/shop_layout.dart';
import 'package:first_app/modules/shop_app/register_screen/cubit/cubit.dart';
import 'package:first_app/modules/shop_app/register_screen/cubit/state.dart';
import 'package:first_app/shared/Network/local/cache_helper.dart';
import 'package:first_app/shared/components/components.dart';
import 'package:first_app/shared/components/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RegisterScreen extends StatelessWidget {
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var nameController = TextEditingController();
  var phoneController = TextEditingController();
  var formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => ShopRegisterCubit(),
      child: BlocConsumer<ShopRegisterCubit, ShopRegisterStates>(
        listener: (context, state) {
          if (state is ShopRegisterSuccessStates) {
            if (state.loginModel.status) {
              CacheHelper.saveData(
                      key: token, value: state.loginModel.data.token)
                  .then((value) {
                token = state.loginModel.data.token;
                showToast(
                    text: state.loginModel.message, state: ToastStates.SUCCESS);
                navigateAndFinish(context, ShopLayout());
              });
            } else {
              showToast(
                  text: state.loginModel.message, state: ToastStates.ERROR);
            }
          }
        },
        builder: (context, state) {
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
                          'REGISTER',
                          style: Theme.of(context).textTheme.headline4.copyWith(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        Text(
                          'Register now to browse our hot offers',
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
                            controller: nameController,
                            type: TextInputType.name,
                            validated: (String value) {
                              if (value.isEmpty) {
                                return 'Please enter your name';
                              }
                            },
                            prefix: Icons.person,
                            label: 'Name'),
                        SizedBox(
                          height: 15.0,
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
                            // onSubmit: () {},
                            colorLayout: Colors.blue,
                            isPassword:
                                ShopRegisterCubit.get(context).isPassword,
                            controller: passwordController,
                            type: TextInputType.visiblePassword,
                            validated: (String value) {
                              if (value.isEmpty) {
                                return 'Password is too short';
                              }
                            },
                            suffixPressed: ShopRegisterCubit.get(context)
                                .changePasswordVisibility,
                            prefix: Icons.lock_outline,
                            suffix: ShopRegisterCubit.get(context).suffix,
                            label: 'Password'),
                        SizedBox(
                          height: 15.0,
                        ),
                        defaultFormField(
                            textStyle: TextStyle(color: Colors.white),
                            colorLayout: Colors.blue,
                            controller: phoneController,
                            type: TextInputType.phone,
                            validated: (String value) {
                              if (value.isEmpty) {
                                return 'Please enter your mobile phone';
                              }
                            },
                            prefix: Icons.phone,
                            label: 'Phone'),
                        SizedBox(
                          height: 30.0,
                        ),
                        ConditionalBuilder(
                            condition: state is! ShopRegisterLoadingStates,
                            builder: (context) => defaultButton(
                                function: () {
                                  if (formKey.currentState.validate()) {
                                    ShopRegisterCubit.get(context).userRegister(
                                        name: nameController.text,
                                        phone: phoneController.text,
                                        email: emailController.text,
                                        password: passwordController.text);
                                  }
                                },
                                text: 'REGISTER',
                                isUpperCase: true,
                                background: Colors.blue,
                                radius: 30.0),
                            fallback: (context) =>
                                Center(child: CircularProgressIndicator())),
                        // SizedBox(
                        //   height: 15.0,
                        // ),
                        // Row(
                        //   mainAxisAlignment: MainAxisAlignment.center,
                        //   children: [
                        //     Text('Don\'t have an account?'),
                        //     defaultTextButton(
                        //         function: () {
                        //           navigateTo(context, RegisterScreen());
                        //         },
                        //         text: 'register'),
                        //   ],
                        // ),
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
