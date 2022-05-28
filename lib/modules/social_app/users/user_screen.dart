import 'package:conditional_builder/conditional_builder.dart';
import 'package:first_app/layout/social_app/cubit/social_state.dart';
import 'package:first_app/modules/social_app/users/user_data.dart';
import 'package:first_app/shared/components/components.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:hexcolor/hexcolor.dart';

import '../../../layout/social_app/cubit/social_cubit.dart';
import '../../../models/social_app/social_user_model.dart';

String friendUid;

class UsersScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      // print(friendUid);
      SocialCubit.get(context).getFriendRequest();
      SocialCubit.get(context).getAllUser();
      SocialCubit.get(context)
          .getFriends(SocialCubit.get(context).userModel.uId);
      SocialCubit.get(context).checkFriends(friendUid);
      return BlocConsumer<SocialCubit, SocialStates>(
          builder: (context, state) {
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
                      systemOverlayStyle: SystemUiOverlayStyle(
                        statusBarColor: HexColor('#17202A'),
                      ),
                      backgroundColor: HexColor('#17202A'),
                      automaticallyImplyLeading: false,
                      title: Text(
                        'Invite Friends',
                        style: TextStyle(color: Colors.white, fontSize: 28.0),
                      ),
                    ),
                    body: RefreshIndicator(
                      onRefresh: () async {
                        await Future.delayed(Duration(seconds: 1))
                            .then((value) {
                          SocialCubit.get(context).friendRequests = [];
                          SocialCubit.get(context).getFriendRequest();
                          SocialCubit.get(context).users = [];
                          SocialCubit.get(context).getAllUser();
                          SocialCubit.get(context).friends = [];
                          SocialCubit.get(context).getFriends(
                              SocialCubit.get(context).userModel.uId);
                          SocialCubit.get(context).checkFriends(friendUid);
                        });
                      },
                      color: Colors.amber,
                      backgroundColor: HexColor('#17202A'),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Friend Request',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20.0),
                            ),
                            SizedBox(
                              height: 5.0,
                            ),
                            ConditionalBuilder(
                              condition: SocialCubit.get(context)
                                      .friendRequests
                                      .length >
                                  0,
                              builder: (context) => Expanded(
                                child: ListView.separated(
                                    physics: BouncingScrollPhysics(),
                                    scrollDirection: Axis.horizontal,
                                    itemBuilder: (context, index) =>
                                        buildFriendRequest(
                                            SocialCubit.get(context)
                                                .friendRequests[index],
                                            context),
                                    separatorBuilder: (context, index) =>
                                        SizedBox(
                                          width: 10.0,
                                        ),
                                    itemCount: SocialCubit.get(context)
                                        .friendRequests
                                        .length),
                              ),
                              fallback: (context) => Center(
                                child: Container(
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15.0),
                                    color: HexColor('#17202A'),
                                  ),
                                  child: Center(
                                    child: Text(
                                      'No friend requests',
                                      style: TextStyle(
                                          fontSize: 30.0, color: Colors.white),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 10.0,
                            ),
                            Text(
                              'People may be know',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20.0),
                            ),
                            SizedBox(
                              height: 5.0,
                            ),
                            ConditionalBuilder(
                              condition: SocialCubit.get(context).users != null,
                              builder: (context) => Expanded(
                                child: ListView.separated(
                                    // physics: NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    physics: BouncingScrollPhysics(),
                                    itemBuilder: (context, index) =>
                                        buildInviteFriends(
                                          SocialCubit.get(context).users[index],
                                          context,
                                        ),
                                    separatorBuilder: (context, index) =>
                                        SizedBox(
                                          height: 0.0,
                                        ),
                                    itemCount:
                                        SocialCubit.get(context).users.length),
                              ),
                              fallback: (context) => CircularProgressIndicator(
                                color: Colors.amber,
                              ),
                            ),
                          ],
                        ),
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
          listener: (context, state) {});
    });
  }

  Widget buildInviteFriends(
    SocialUserModel model,
    context,
  ) {
    friendUid = model.uId.toString();
    return InkWell(
      onTap: () {
        navigateTo(context, UserData(userModel: model));
      },
      child: Container(
        decoration: BoxDecoration(boxShadow: [
          BoxShadow(
            color: Colors.black26,

            blurRadius: 20.0, // soften the shadow

            spreadRadius: 0.0, //extend the shadow

            offset: Offset(
              10.0, // Move to right 10  horizontally

              10.0, // Move to bottom 10 Vertically
            ),
          )
        ]),
        child: Card(
          color: HexColor('#212F3D'),
          shadowColor: HexColor('#212F3D'),
          clipBehavior: Clip.antiAliasWithSaveLayer,
          // margin: EdgeInsets.symmetric(horizontal: 8.0),
          child: Row(
            children: [
              CircleAvatar(
                radius: 30.0,
                backgroundColor: Colors.amber,
                backgroundImage: NetworkImage('${model.image}'),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Text(
                  '${model.name}',
                  style: TextStyle(color: Colors.grey[300], fontSize: 20.0),
                ),
              ),
              Spacer(),
              IconButton(
                onPressed: () {
                  navigateTo(
                      context,
                      UserData(
                        userModel: model,
                      ));
                },
                icon: CircleAvatar(
                  child: Icon(
                    Icons.arrow_forward_ios,
                    size: 28.0,
                    color: Colors.black,
                  ),
                  backgroundColor: Colors.amber,
                ),
                iconSize: 30.0,
                color: Colors.amber,
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget buildFriendRequest(SocialUserModel friendModel, context) => InkWell(
        onTap: () {
          navigateTo(
              context,
              UserData(
                userModel: friendModel,
              ));
        },
        child: Container(
          height: 260.0,
          width: 250.0,
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.black26,

                blurRadius: 0.0, // soften the shadow

                spreadRadius: 0.0, //extend the shadow

                offset: Offset(
                  0.0, // Move to right 10  horizontally

                  0.0, // Move to bottom 10 Vertically
                ),
              )
            ],
            borderRadius: BorderRadius.circular(15.0),
            color: HexColor('#17202A'),
          ),
          child: Column(
            children: [
              Expanded(
                child: Image(
                  image: NetworkImage('${friendModel.image}'),
                  height: 180.0,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              Text('${friendModel.name}',
                  style: TextStyle(fontSize: 18.0, color: Colors.white)),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: () {
                          SocialCubit.get(context).addFriendTohim(
                              friendsUid: friendModel.uId,
                              friendName: friendModel.name,
                              friendImage: friendModel.image,
                              bio: friendModel.bio,
                              token: friendModel.token,
                              cover: friendModel.cover,
                              email: friendModel.email,
                              phone: friendModel.phone,
                              verify: friendModel.isEmailVerified);
                          SocialCubit.get(context)
                              .deleteFriendRequest(friendModel.uId);
                          showToast(
                              text: 'You have become friends',
                              state: ToastStates.SUCCESS);
                          SocialCubit.get(context).sendAppNotification(
                              content: 'accept the friend request',
                              contentId: SocialCubit.get(context).userModel.uId,
                              contentKey: 'friendRequestAccepted',
                              reseverId: friendModel.uId,
                              reseverName: friendModel.name);

                          SocialCubit.get(context).sendNotification(
                            token: friendModel.token,
                            senderName: SocialCubit.get(context).userModel.name,
                            messageText:
                                '${SocialCubit.get(context).userModel.name}' +
                                    ' accept the friend request',
                          );
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0),
                              color: Colors.amber),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              'add friend',
                              style: TextStyle(fontSize: 18.0),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 30.0,
                      ),
                      InkWell(
                        onTap: () {
                          SocialCubit.get(context)
                              .deleteFriendRequest(friendModel.uId);
                          SocialCubit.get(context).sendAppNotification(
                              content: 'Reject the friend request ',
                              contentId: SocialCubit.get(context).userModel.uId,
                              contentKey: 'friendRequestAccepted',
                              reseverId: friendModel.uId,
                              reseverName: friendModel.name);

                          SocialCubit.get(context).sendNotification(
                            token: friendModel.token,
                            senderName: SocialCubit.get(context).userModel.name,
                            messageText:
                                '${SocialCubit.get(context).userModel.name}' +
                                    ' Reject the friend request',
                          );
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0),
                              color: Colors.amber),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              'remove',
                              style: TextStyle(fontSize: 18.0),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      );
}
