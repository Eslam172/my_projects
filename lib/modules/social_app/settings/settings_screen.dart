import 'package:conditional_builder/conditional_builder.dart';
import 'package:first_app/layout/social_app/cubit/social_cubit.dart';
import 'package:first_app/layout/social_app/cubit/social_state.dart';
import 'package:first_app/modules/social_app/edit_profile/edit_profile_screen.dart';
import 'package:first_app/modules/social_app/profile/profile_screen.dart';
import 'package:first_app/shared/components/components.dart';
import 'package:first_app/shared/components/constants.dart';
import 'package:first_app/shared/style/icon_broken.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:hexcolor/hexcolor.dart';

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialCubit, SocialStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var userModel = SocialCubit.get(context).userModel;
        return ConditionalBuilder(
          condition: userModel != null,
          builder: (context) {
            return OfflineBuilder(
              connectivityBuilder: (
                BuildContext context,
                ConnectivityResult connectivity,
                Widget child,
              ) {
                final bool connected = connectivity != ConnectivityResult.none;
                if (connected) {
                  return Scaffold(
                    appBar: AppBar(
                      backgroundColor: HexColor('#212F3D'),
                      title: Text(
                        'Setting',
                        style: TextStyle(color: Colors.white, fontSize: 30.0),
                      ),
                    ),
                    body: Padding(
                      padding: const EdgeInsets.all(30.0),
                      child: Column(
                        children: [
                          CircleAvatar(
                            backgroundColor: Colors.amber,
                            radius: 83.0,
                            child: CircleAvatar(
                              backgroundColor: Colors.amber,
                              radius: 80.0,
                              backgroundImage:
                                  NetworkImage('${userModel.image}'),
                            ),
                          ),
                          SizedBox(
                            height: 5.0,
                          ),
                          Text(
                            '${userModel.name}',
                            style: Theme.of(context)
                                .textTheme
                                .bodyText1
                                .copyWith(
                                    color: Colors.grey[400], fontSize: 25.0),
                          ),
                          SizedBox(
                            height: 20.0,
                          ),
                          InkWell(
                            onTap: () {
                              navigateTo(context, ProfileScreen());
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.grey[600],
                                borderRadius: BorderRadius.circular(25.0),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20.0),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        'Profile',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 25.0,
                                        ),
                                      ),
                                    ),
                                    Icon(
                                      IconBroken.User,
                                      color: Colors.grey[350],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 30.0,
                          ),
                          InkWell(
                            onTap: () {
                              SocialCubit.get(context).signOut(context);
                            },
                            child: Container(
                              // foregroundDecoration: ,
                              decoration: BoxDecoration(
                                color: Colors.grey[600],
                                borderRadius: BorderRadius.circular(25.0),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20.0),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        'Log out',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 25.0,
                                        ),
                                      ),
                                    ),
                                    Icon(
                                      IconBroken.Logout,
                                      color: Colors.grey[350],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 30.0,
                          ),
                          InkWell(
                            onTap: () {
                              SocialCubit.get(context).deleteAccount(context);
                            },
                            child: Container(
                              // foregroundDecoration: ,
                              decoration: BoxDecoration(
                                color: Colors.grey[600],
                                borderRadius: BorderRadius.circular(25.0),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20.0),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        'Delete account',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 25.0,
                                        ),
                                      ),
                                    ),
                                    Icon(
                                      IconBroken.Delete,
                                      color: Colors.grey[350],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                } else {
                  return buildNoInternet();
                }
              },
              child: Center(
                  child: CircularProgressIndicator(
                color: Colors.amber,
              )),
            );
          },
          fallback: (context) => Center(
              child: CircularProgressIndicator(
            color: Colors.amber,
          )),
        );
      },
    );
  }
}
