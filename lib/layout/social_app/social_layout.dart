import 'package:badges/badges.dart';
import 'package:conditional_builder/conditional_builder.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:first_app/layout/social_app/cubit/social_cubit.dart';
import 'package:first_app/layout/social_app/cubit/social_state.dart';
import 'package:first_app/modules/social_app/post/post_screen.dart';
import 'package:first_app/shared/components/components.dart';
import 'package:first_app/shared/components/constants.dart';
import 'package:first_app/shared/style/icon_broken.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';

import '../../shared/Network/local/cache_helper.dart';

class SocialLayOut extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      // SocialCubit.get(context).getUnReadNotificationsCount();
      return BlocConsumer<SocialCubit, SocialStates>(
        listener: (context, state) {
          if (state is SocialPostState) {
            navigateTo(context, PostScreen());
          }
        },
        builder: (context, state) {
          var cubit = SocialCubit.get(context);
          return Scaffold(
            // appBar: AppBar(
            //   backgroundColor: HexColor('#212F3D'),
            //   title: Text(
            //     cubit.titles[cubit.currentIndex],
            //     style: TextStyle(
            //         fontWeight: FontWeight.bold,
            //         fontSize: 25.0,
            //         color: Colors.white),
            //   ),
            //   actions: [
            //     Padding(
            //       padding: const EdgeInsets.all(8.0),
            //       child: InkWell(
            //         onTap: () {},
            //         child: CircleAvatar(
            //           backgroundColor: Colors.amber,
            //           radius: 30.0,
            //           backgroundImage:
            //               NetworkImage(SocialCubit.get(context).userModel.image),
            //         ),
            //       ),
            //     ),
            //   ],
            // ),
            body: cubit.screens[cubit.currentIndex],
            bottomNavigationBar: BottomNavigationBar(
              backgroundColor: HexColor('#17202A'),
              currentIndex: cubit.currentIndex,
              onTap: (index) {
                cubit.changeBottomNav(index);
              },
              items: [
                BottomNavigationBarItem(
                    icon: Icon(Icons.local_fire_department_outlined),
                    label: 'Home'),
                BottomNavigationBarItem(
                    icon: SocialCubit.get(context).unReadRecentMessageCount != 0
                        ? Badge(
                            badgeContent: Text(
                              '${SocialCubit.get(context).unReadRecentMessageCount.toString()}',
                              style: TextStyle(color: Colors.white),
                            ),
                            child: Icon(Icons.chat_sharp),
                            animationType: BadgeAnimationType.scale,
                            position: BadgePosition.topEnd(top: -15, end: -10),
                            animationDuration: Duration(milliseconds: 300),
                          )
                        : Icon(Icons.chat_sharp),
                    label: 'Chats'),
                BottomNavigationBarItem(
                    icon: Icon(IconBroken.Location), label: 'Users'),
                BottomNavigationBarItem(
                    icon: SocialCubit.get(context).unReadNotificationsCount != 0
                        ? Badge(
                            badgeContent: Text(
                              '${SocialCubit.get(context).unReadNotificationsCount.toString()}',
                              style: TextStyle(color: Colors.white),
                            ),
                            child: Icon(Icons.notifications_rounded),
                            animationType: BadgeAnimationType.scale,
                            position: BadgePosition.topEnd(top: -15, end: -10),
                            animationDuration: Duration(milliseconds: 300),
                          )
                        : Icon(Icons.notifications_rounded),
                    label: 'Notification'),
                BottomNavigationBarItem(
                    icon: Icon(IconBroken.Setting), label: 'Settings'),
              ],
            ),
          );
        },
      );
    });
  }
}
