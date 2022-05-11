import 'package:conditional_builder/conditional_builder.dart';
import 'package:first_app/layout/social_app/social_layout.dart';
import 'package:first_app/modules/social_app/social_register/register_cubit/cubit.dart';
import 'package:first_app/modules/social_app/social_register/register_cubit/state.dart';
import 'package:first_app/shared/Network/local/cache_helper.dart';
import 'package:first_app/shared/components/components.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import '../../../layout/social_app/cubit/social_cubit.dart';
import '../../../shared/components/constants.dart';

class SocialRegisterScreen extends StatelessWidget {
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var nameController = TextEditingController();
  var phoneController = TextEditingController();
  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => SocialRegisterCubit(),
      child: BlocConsumer<SocialRegisterCubit, SocialRegisterStates>(
        listener: (context, state) {
          if (state is SocialCreateUserSuccessStates) {
            CacheHelper.saveData(key: 'uId', value: state.uId).then((value) {
              SocialCubit.get(context).getUserData();
              SocialCubit.get(context).getPosts();
              navigateAndFinish(context, SocialLayOut());
              showToast(
                  text: 'New account created successfully',
                  state: ToastStates.SUCCESS);
            });
          }
        },
        builder: (context, state) {
          return Scaffold(
            backgroundColor: HexColor('#212F3D'),
            appBar: AppBar(
              iconTheme: IconThemeData(color: Colors.white),
              backgroundColor: HexColor('#212F3D'),
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Form(
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Create Account',
                        style: Theme.of(context)
                            .textTheme
                            .headline4
                            .copyWith(color: Colors.white, fontSize: 30.0),
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
                            hintText: 'Username',
                            hintStyle: TextStyle(color: Colors.grey[500]),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                          ),
                          cursorColor: Colors.white,
                          style: TextStyle(color: Colors.white),
                          controller: nameController,
                          keyboardType: TextInputType.name,
                          validator: (String value) {
                            if (value.isEmpty) {
                              return 'Please enter your name';
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
                            hintText: 'Email',
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
                            hintText: 'Phone',
                            hintStyle: TextStyle(color: Colors.grey[500]),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                          ),
                          cursorColor: Colors.white,
                          style: TextStyle(color: Colors.white),
                          controller: phoneController,
                          keyboardType: TextInputType.phone,
                          validator: (String value) {
                            if (value.isEmpty) {
                              return 'Please enter your mobile phone';
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
                          obscureText: true,
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
                          cursorColor: Colors.white,
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
                        height: 45.0,
                      ),
                      ConditionalBuilder(
                          condition: state is! SocialRegisterLoadingStates,
                          builder: (context) => Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12.0),
                                child: defaultButton(
                                    function: () {
                                      if (formKey.currentState.validate()) {
                                        SocialRegisterCubit.get(context)
                                            .userRegister(
                                                name: nameController.text,
                                                phone: phoneController.text,
                                                email: emailController.text,
                                                password:
                                                    passwordController.text);
                                      }
                                    },
                                    text: 'Sign Up',
                                    isUpperCase: false,
                                    background: Colors.amber,
                                    textStyle: TextStyle(
                                        color: Colors.black, fontSize: 18.0),
                                    radius: 30.0),
                              ),
                          fallback: (context) => Center(
                                  child: CircularProgressIndicator(
                                color: Colors.amber,
                              ))),
                      SizedBox(
                        height: 25.0,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 35.0),
                        child: Text(
                          'By clicking Sign up you agree to the following',
                          style: TextStyle(
                              fontSize: 14.0, color: Colors.grey[600]),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 35.0, vertical: 5.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Terms and Conditions without',
                              style: TextStyle(
                                  fontSize: 14.0,
                                  color: Colors.grey[600],
                                  height: 1.0),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 0.0, vertical: 10.0),
                              child: Text(
                                'reservation',
                                style: TextStyle(
                                    fontSize: 14.0,
                                    color: Colors.grey[600],
                                    height: 1.0),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
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
