import 'dart:io';

import 'package:first_app/layout/social_app/cubit/social_cubit.dart';
import 'package:first_app/layout/social_app/cubit/social_state.dart';
import 'package:first_app/shared/components/components.dart';
import 'package:first_app/shared/style/colors.dart';
import 'package:first_app/shared/style/icon_broken.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:image_picker/image_picker.dart';

class EditProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialCubit, SocialStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var userModel = SocialCubit.get(context).userModel;
        var nameController = TextEditingController();
        var bioController = TextEditingController();
        var phoneController = TextEditingController();
        var profileImage = SocialCubit.get(context).profileImage;
        var coverImage = SocialCubit.get(context).coverImage;
        nameController.text = userModel.name;
        bioController.text = userModel.bio;
        phoneController.text = userModel.phone;

        return Scaffold(
          appBar: defaultAppBar(
              context: context,
              color: HexColor('#212F3D'),
              iconColor: Colors.white,
              textColor: Colors.white,
              title: 'Edit Profile',
              actions: [
                defaultTextButton(
                    function: () {
                      SocialCubit.get(context).updateUser(
                          name: nameController.text,
                          phone: phoneController.text,
                          bio: bioController.text);
                      // SocialCubit.get(context).getUserData();
                    },
                    text: 'Update',
                    colorText: Colors.grey[300]),
                SizedBox(
                  width: 15.0,
                ),
              ]),
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  if (state is SocialUserUpdateLoadingState ||
                      state is SocialUserUpdateImageLoadingState ||
                      state is SocialUserUpdateCoverLoadingState)
                    LinearProgressIndicator(
                      color: Colors.amber,
                    ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Container(
                    height: 190.0,
                    child: Stack(
                      alignment: AlignmentDirectional.bottomCenter,
                      children: [
                        Align(
                          alignment: AlignmentDirectional.topCenter,
                          child: Stack(
                            alignment: AlignmentDirectional.topEnd,
                            children: [
                              Container(
                                height: 150.0,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(5.0),
                                    topRight: Radius.circular(5.0),
                                  ),
                                  image: DecorationImage(
                                    image: coverImage == null
                                        ? NetworkImage('${userModel.cover}')
                                        : FileImage(coverImage),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              IconButton(
                                  onPressed: () {
                                    SocialCubit.get(context).getCoverImage();
                                  },
                                  icon: CircleAvatar(
                                      backgroundColor: Colors.amber,
                                      radius: 20.0,
                                      child: Icon(
                                        IconBroken.Camera,
                                        color: Colors.black,
                                        size: 20.0,
                                      ))),
                            ],
                          ),
                        ),
                        Stack(
                          alignment: AlignmentDirectional.bottomEnd,
                          children: [
                            CircleAvatar(
                              backgroundColor: Colors.amber,
                              radius: 64.0,
                              child: CircleAvatar(
                                backgroundColor: Colors.amber,
                                radius: 60.0,
                                backgroundImage: profileImage == null
                                    ? NetworkImage('${userModel.image}')
                                    : FileImage(profileImage),
                              ),
                            ),
                            IconButton(
                                onPressed: () {
                                  SocialCubit.get(context).getProfileImage();
                                },
                                icon: CircleAvatar(
                                    backgroundColor: Colors.amber,
                                    radius: 20.0,
                                    child: Icon(
                                      IconBroken.Camera,
                                      color: Colors.black,
                                      size: 20.0,
                                    ))),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  if (SocialCubit.get(context).profileImage != null ||
                      SocialCubit.get(context).coverImage != null)
                    Row(
                      children: [
                        if (SocialCubit.get(context).profileImage != null)
                          Expanded(
                            child: Column(
                              children: [
                                defaultButton(
                                    function: () {
                                      SocialCubit.get(context)
                                          .uploadProfileImage(
                                              name: nameController.text,
                                              phone: phoneController.text,
                                              bio: bioController.text);
                                      SocialCubit.get(context).profileImage =
                                          null;
                                    },
                                    text: 'Upload Profile',
                                    colorText: Colors.black,
                                    background: Colors.amber),
                                if (state is SocialUserUpdateImageLoadingState)
                                  SizedBox(
                                    height: 5.0,
                                  ),
                                if (state is SocialUserUpdateImageLoadingState)
                                  LinearProgressIndicator(
                                    color: Colors.amber,
                                  ),
                              ],
                            ),
                          ),
                        SizedBox(
                          width: 5.0,
                        ),
                        if (SocialCubit.get(context).coverImage != null)
                          Expanded(
                            child: Column(
                              children: [
                                defaultButton(
                                    function: () {
                                      SocialCubit.get(context).uploadCoverImage(
                                          name: nameController.text,
                                          phone: phoneController.text,
                                          bio: bioController.text);
                                      SocialCubit.get(context).coverImage =
                                          null;
                                    },
                                    text: 'Upload Cover',
                                    colorText: Colors.black,
                                    background: Colors.amber),
                                if (state is SocialUserUpdateCoverLoadingState)
                                  SizedBox(
                                    height: 5.0,
                                  ),
                                if (state is SocialUserUpdateCoverLoadingState)
                                  LinearProgressIndicator(
                                    color: Colors.amber,
                                  ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  if (SocialCubit.get(context).profileImage != null ||
                      SocialCubit.get(context).coverImage != null)
                    SizedBox(
                      height: 20.0,
                    ),
                  defaultFormField(
                      colorBorder: Colors.amber,
                      labelStyle: TextStyle(color: Colors.white),
                      colorPrefix: Colors.grey[500],
                      colorLayout: Colors.amber,
                      controller: nameController,
                      type: TextInputType.name,
                      validated: (String value) {
                        if (value.isEmpty) {
                          return 'name must not be empty';
                        } else {
                          return null;
                        }
                      },
                      prefix: IconBroken.User,
                      textStyle: TextStyle(color: Colors.grey[300]),
                      label: 'name'),
                  SizedBox(
                    height: 15.0,
                  ),
                  defaultFormField(
                      colorBorder: Colors.amber,
                      labelStyle: TextStyle(color: Colors.white),
                      colorPrefix: Colors.grey[500],
                      colorLayout: Colors.amber,
                      controller: bioController,
                      type: TextInputType.text,
                      validated: (String value) {
                        if (value.isEmpty) {
                          return 'bio must not be empty';
                        } else {
                          return null;
                        }
                      },
                      prefix: IconBroken.Info_Circle,
                      textStyle: TextStyle(color: Colors.grey[300]),
                      label: 'bio'),
                  SizedBox(
                    height: 15.0,
                  ),
                  defaultFormField(
                      colorBorder: Colors.amber,
                      labelStyle: TextStyle(color: Colors.white),
                      colorPrefix: Colors.grey[500],
                      colorLayout: Colors.amber,
                      controller: phoneController,
                      type: TextInputType.phone,
                      validated: (String value) {
                        if (value.isEmpty) {
                          return 'phone must not be empty';
                        } else {
                          return null;
                        }
                      },
                      prefix: IconBroken.Call,
                      textStyle: TextStyle(color: Colors.grey[300]),
                      label: 'phone'),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
