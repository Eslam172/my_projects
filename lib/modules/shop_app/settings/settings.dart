import 'package:conditional_builder/conditional_builder.dart';
import 'package:first_app/layout/shop_app/cubit/cubit.dart';
import 'package:first_app/layout/shop_app/cubit/states.dart';
import 'package:first_app/models/shop_app/login_model.dart';
import 'package:first_app/shared/components/components.dart';
import 'package:first_app/shared/components/constants.dart';
import 'package:first_app/shared/style/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SettingsScreen extends StatelessWidget {
  var formKey = GlobalKey<FormState>();
  var nameController = TextEditingController();
  var emailController = TextEditingController();
  var phoneController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopCubit, ShopStates>(
      listener: (context, state) {
        if (state is ShopSuccessUpdateUserState) {
          if (!state.loginModel.status) {
            showToast(
                text: ShopCubit.get(context).userModel.message,
                state: ToastStates.ERROR);
          } else {
            showToast(
                text: ShopCubit.get(context).userModel.message,
                state: ToastStates.SUCCESS);
          }
        }
      },
      builder: (context, state) {
        var model = ShopCubit.get(context).userModel;
        nameController.text = model.data.name;
        emailController.text = model.data.email;
        phoneController.text = model.data.phone;
        return ConditionalBuilder(
            condition: ShopCubit.get(context).userModel != null,
            builder: (context) => Scaffold(
                  backgroundColor: Colors.grey,
                  body: Center(
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Form(
                          key: formKey,
                          child: Column(
                            children: [
                              if (state is ShopLoadingUpdateUserState)
                                LinearProgressIndicator(),
                              SizedBox(
                                height: 20.0,
                              ),
                              defaultFormField(
                                textStyle: TextStyle(color: Colors.white),
                                colorLayout: defaultColor,
                                controller: nameController,
                                type: TextInputType.name,
                                validated: (String value) {
                                  if (value.isEmpty) {
                                    return 'Name must not be empty';
                                  } else {
                                    return null;
                                  }
                                },
                                prefix: Icons.person,
                                label: 'Name',
                              ),
                              SizedBox(
                                height: 20.0,
                              ),
                              defaultFormField(
                                textStyle: TextStyle(color: Colors.white),
                                colorLayout: defaultColor,
                                controller: emailController,
                                type: TextInputType.emailAddress,
                                validated: (String value) {
                                  if (value.isEmpty) {
                                    return 'Email must not be empty';
                                  } else {
                                    return null;
                                  }
                                },
                                prefix: Icons.email_outlined,
                                label: 'Email Address',
                              ),
                              SizedBox(
                                height: 20.0,
                              ),
                              defaultFormField(
                                textStyle: TextStyle(color: Colors.white),
                                colorLayout: defaultColor,
                                controller: phoneController,
                                type: TextInputType.phone,
                                validated: (String value) {
                                  if (value.isEmpty) {
                                    return 'Phone must not be empty';
                                  } else {
                                    return null;
                                  }
                                },
                                prefix: Icons.phone,
                                label: 'Phone',
                              ),
                              SizedBox(
                                height: 40.0,
                              ),
                              Row(
                                children: [
                                  defaultButton(
                                      background: defaultColor,
                                      width: 150.0,
                                      function: () {
                                        signOut(context);
                                      },
                                      text: 'logOut'),
                                  Spacer(),
                                  defaultButton(
                                      background: defaultColor,
                                      width: 150.0,
                                      function: () {
                                        if (formKey.currentState.validate()) {
                                          ShopCubit.get(context).updateUserData(
                                              name: nameController.text,
                                              email: emailController.text,
                                              phone: phoneController.text);
                                        }
                                      },
                                      text: 'UPDATE'),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
            fallback: (context) => Center(child: CircularProgressIndicator()));
      },
    );
  }
}
