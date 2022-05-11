import 'package:conditional_builder/conditional_builder.dart';
import 'package:first_app/layout/social_app/cubit/social_cubit.dart';
import 'package:first_app/layout/social_app/cubit/social_state.dart';
import 'package:first_app/layout/social_app/social_layout.dart';
import 'package:first_app/models/social_app/notification_model.dart';
import 'package:first_app/models/social_app/social_user_model.dart';
import 'package:first_app/modules/social_app/chats/chats_dtails.dart';
import 'package:first_app/modules/social_app/single_post/single_post.dart';
import 'package:first_app/shared/components/components.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';

import '../search/friend_profile.dart';

class NotificationScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      SocialCubit.get(context).getNotification();
      return BlocConsumer<SocialCubit, SocialStates>(
          builder: (context, state) {
            List<NotificationModel> notifications =
                SocialCubit.get(context).notificationModel;
            return Scaffold(
              appBar: AppBar(
                backgroundColor: HexColor('#212F3D'),
                title: Text(
                  'Notification',
                  style: TextStyle(color: Colors.white, fontSize: 30.0),
                ),
              ),
              body: ConditionalBuilder(
                condition: notifications.length > 0,
                builder: (context) => ListView.builder(
                  physics: BouncingScrollPhysics(),
                  itemBuilder: (context, index) {
                    SocialUserModel user = SocialCubit.get(context).user;
                    if (user == null)
                      SocialCubit.get(context)
                          .getUser(notifications[index].senderId);
                    return buildNotification(
                        notifications[index], context, index, user);
                  },
                  itemCount: notifications.length,
                ),
                fallback: (context) => Center(
                    child: Text(
                  'No notifications yet',
                  style: TextStyle(color: Colors.grey[500], fontSize: 20.0),
                )),
              ),
            );
          },
          listener: (context, state) {});
    });
  }

  Widget buildNotification(
      NotificationModel notification, context, index, SocialUserModel user) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
      child: Container(
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: Colors.amber,
              backgroundImage: NetworkImage('${notification.senderProfile}'),
              radius: 30.0,
            ),
            SizedBox(
              width: 20.0,
            ),
            Expanded(
              child: InkWell(
                onLongPress: () {
                  return showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                            backgroundColor: HexColor('#212F3D'),
                            actions: [
                              Align(
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.delete,
                                      color: Colors.grey,
                                    ),
                                    SizedBox(
                                      width: 15.0,
                                    ),
                                    InkWell(
                                      onTap: () {
                                        SocialCubit.get(context)
                                            .deleteNotification(
                                                notification.notificationId);
                                      },
                                      child: Text(
                                        'Delete this notification',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 20.0),
                                      ),
                                    ),
                                  ],
                                ),
                                alignment: AlignmentDirectional.topStart,
                              )
                            ],
                          ));
                },
                onTap: () {
                  if (notification.contentKey == 'commentPost') {
                    SocialCubit.get(context)
                        .readNotification(notification.notificationId);
                    SocialCubit.get(context).changeBottomNav(0);
                  } else if (notification.contentKey == 'chat') {
                    SocialCubit.get(context)
                        .readNotification(notification.notificationId);
                    navigateTo(
                        context,
                        ChatsDetails(
                          userModel: user,
                        ));
                    // showToast(text: '${user.name}', state: ToastStates.SUCCESS);
                  } else if (notification.contentKey ==
                      'friendRequestAccepted') {
                    SocialCubit.get(context)
                        .readNotification(notification.notificationId);
                    navigateTo(
                        context,
                        FriendProfile(
                          userUid: notification.senderId,
                        ));
                  } else if (notification.contentKey == 'friendRequest') {
                    SocialCubit.get(context)
                        .readNotification(notification.notificationId);
                    SocialCubit.get(context).changeBottomNav(2);
                  }
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '${notification.senderName}',
                      style: TextStyle(
                          color: notification.read
                              ? Colors.grey[300]
                              : Colors.white,
                          fontSize: 18.0),
                    ),
                    Text(
                      '${notification.senderName}${notification.content}',
                      style: TextStyle(
                          color: notification.read
                              ? Colors.grey[400]
                              : Colors.white,
                          fontSize: 15.0),
                    ),
                    SizedBox(
                      height: 15.0,
                    ),
                    Container(
                      height: 0.7,
                      decoration: BoxDecoration(boxShadow: [
                        BoxShadow(
                          color: Colors.black,

                          blurRadius: 0.5, // soften the shadow

                          spreadRadius: 0.0, //extend the shadow

                          offset: Offset(
                            0.0, // Move to right 10  horizontally

                            0.0, // Move to bottom 10 Vertically
                          ),
                        )
                      ]),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
