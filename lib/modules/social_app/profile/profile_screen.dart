import 'package:conditional_builder/conditional_builder.dart';
import 'package:first_app/modules/social_app/edit_profile/edit_profile_screen.dart';
import 'package:first_app/shared/components/components.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:full_screen_image/full_screen_image.dart';
import 'package:hexcolor/hexcolor.dart';
import '../../../layout/social_app/cubit/social_cubit.dart';
import '../../../layout/social_app/cubit/social_state.dart';
import '../../../models/social_app/post_model.dart';

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: Colors.transparent));
    return Builder(builder: (context) {
      var userModel = SocialCubit.get(context).userModel;
      SocialCubit.get(context).getUserData();
      SocialCubit.get(context)
          .getUserPosts(SocialCubit.get(context).userModel.uId);
      SocialCubit.get(context)
          .getFriends(SocialCubit.get(context).userModel.uId);
      SocialCubit.get(context).getPosts();
      return BlocConsumer<SocialCubit, SocialStates>(
          listener: (context, state) {},
          builder: (context, state) {
            // SocialCubit.get(context).getUserData();
            return ConditionalBuilder(
                condition: SocialCubit.get(context).userModel != null,
                builder: (context) => AnnotatedRegion<SystemUiOverlayStyle>(
                      value: SystemUiOverlayStyle(
                        statusBarColor: Colors.transparent,
                      ),
                      child: Scaffold(
                          extendBodyBehindAppBar: true,
                          body: RefreshIndicator(
                            onRefresh: () async {
                              await Future.delayed(Duration(seconds: 1))
                                  .then((value) {
                                SocialCubit.get(context).getUserData();
                                SocialCubit.get(context).userPosts = [];
                                SocialCubit.get(context).getUserPosts(
                                    SocialCubit.get(context).userModel.uId);
                                SocialCubit.get(context).friends = [];
                                SocialCubit.get(context).getFriends(
                                    SocialCubit.get(context).userModel.uId);
                                SocialCubit.get(context).posts = [];
                                SocialCubit.get(context).getPosts();
                              });
                            },
                            color: Colors.amber,
                            backgroundColor: HexColor('#17202A'),
                            child: SingleChildScrollView(
                              physics: BouncingScrollPhysics(),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    height: 250.0,
                                    child: Stack(
                                      alignment:
                                          AlignmentDirectional.bottomCenter,
                                      children: [
                                        Stack(
                                          // clipBehavior: Clip.antiAliasWithSaveLayer,
                                          children: [
                                            Align(
                                              alignment: AlignmentDirectional
                                                  .topCenter,
                                              child: FullScreenWidget(
                                                backgroundColor:
                                                    HexColor('#212F3D'),
                                                child: Hero(
                                                  tag: 'FullScreen',
                                                  child: ClipRRect(
                                                    child: Container(
                                                      height: 210.0,
                                                      width: double.infinity,
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius.only(
                                                          topLeft:
                                                              Radius.circular(
                                                                  5.0),
                                                          topRight:
                                                              Radius.circular(
                                                                  5.0),
                                                        ),
                                                        image: DecorationImage(
                                                          image: NetworkImage(
                                                              '${SocialCubit.get(context).userModel.cover}'),
                                                          fit: BoxFit.cover,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            IconButton(
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 50.0),
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                              icon: Container(
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          4.0),
                                                  color: Colors.white,
                                                ),
                                                child: Icon(
                                                  Icons.arrow_back,
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ),
                                            Align(
                                              alignment:
                                                  AlignmentDirectional.topEnd,
                                              child: IconButton(
                                                padding: EdgeInsets.symmetric(
                                                    vertical: 50.0),
                                                onPressed: () {
                                                  navigateTo(context,
                                                      EditProfileScreen());
                                                },
                                                icon: Container(
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            4.0),
                                                    color: Colors.white,
                                                  ),
                                                  child: Icon(
                                                    Icons.edit,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        CircleAvatar(
                                          backgroundColor: Colors.amber,
                                          radius: 60.0,
                                          child: FullScreenWidget(
                                            backgroundColor:
                                                HexColor('#212F3D'),
                                            child: Hero(
                                              tag: 'FullScreenProfile',
                                              child: ClipRRect(
                                                child: CircleAvatar(
                                                  backgroundColor: Colors.amber,
                                                  radius: 57.0,
                                                  backgroundImage: NetworkImage(
                                                      '${SocialCubit.get(context).userModel.image}'),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: 5.0,
                                  ),
                                  Center(
                                    child: Text(
                                      '${SocialCubit.get(context).userModel.name}',
                                      textAlign: TextAlign.center,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyText1
                                          .copyWith(
                                              color: Colors.grey[300],
                                              fontSize: 25.0),
                                    ),
                                  ),
                                  Center(
                                    child: Text(
                                      '${SocialCubit.get(context).userModel.bio}',
                                      style: Theme.of(context)
                                          .textTheme
                                          .caption
                                          .copyWith(
                                              color: Colors.grey[500],
                                              fontSize: 18.0),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 30.0),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: Colors.grey,
                                              borderRadius:
                                                  BorderRadius.circular(20.0),
                                            ),
                                            child: Column(
                                              children: [
                                                Text(
                                                  '${SocialCubit.get(context).userPosts.length}',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .subtitle2
                                                      .copyWith(
                                                          fontSize: 17.0,
                                                          color: Colors.black),
                                                ),
                                                Text(
                                                  'Posts',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .caption
                                                      .copyWith(
                                                          color: Colors.black),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 60.0,
                                        ),
                                        Expanded(
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: Colors.grey,
                                              borderRadius:
                                                  BorderRadius.circular(20.0),
                                            ),
                                            child: Column(
                                              children: [
                                                Text(
                                                  '${SocialCubit.get(context).friends.length}',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .subtitle2
                                                      .copyWith(
                                                          fontSize: 17.0,
                                                          color: Colors.black),
                                                ),
                                                Text(
                                                  'Followers',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .caption
                                                      .copyWith(
                                                          color: Colors.black),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 15.0),
                                    child: Text(
                                      'My Posts',
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                          color: Colors.grey[400],
                                          fontSize: 20.0),
                                    ),
                                  ),
                                  if (SocialCubit.get(context)
                                          .userPosts
                                          .length ==
                                      0)
                                    Align(
                                      alignment: AlignmentDirectional.center,
                                      child: Text(
                                        'No post\’s yet',
                                        style: TextStyle(
                                            color: Colors.grey[500],
                                            fontSize: 25.0),
                                      ),
                                    ),
                                  ListView.separated(
                                      physics: NeverScrollableScrollPhysics(),
                                      shrinkWrap: true,
                                      itemBuilder: (context, index) =>
                                          buildPostItem(
                                              SocialCubit.get(context)
                                                  .userPosts[index],
                                              context,
                                              index),
                                      separatorBuilder: (context, index) =>
                                          SizedBox(
                                            height: 15.0,
                                          ),
                                      itemCount: SocialCubit.get(context)
                                          .userPosts
                                          .length),
                                ],
                              ),
                            ),
                          )),
                    ));
          });
    });
  }

  Widget buildPostItem(PostModel model, context, index) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4.0),
        child: Container(
          decoration: BoxDecoration(boxShadow: [
            BoxShadow(
              color: Colors.black,

              blurRadius: 10.0, // soften the shadow

              spreadRadius: 0.0, //extend the shadow

              offset: Offset(
                0.0, // Move to right 10  horizontally

                0.0, // Move to bottom 10 Vertically
              ),
            )
          ]),
          child: Card(
            color: HexColor('#212F3D'),
            shadowColor: HexColor('#212F3D'),
            clipBehavior: Clip.antiAliasWithSaveLayer,
            margin: EdgeInsets.symmetric(horizontal: 8.0),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.amber,
                        radius: 27.0,
                        backgroundImage: NetworkImage('${model.image}'),
                      ),
                      SizedBox(
                        width: 15.0,
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  '${model.name}',
                                  style: TextStyle(
                                      height: 1.4,
                                      fontSize: 15.0,
                                      color: Colors.white),
                                ),
                                SizedBox(
                                  width: 5.0,
                                ),
                                Icon(
                                  Icons.check_circle,
                                  color: Colors.amber,
                                  size: 17.0,
                                )
                              ],
                            ),
                            Text(
                              '${model.dateTime}',
                              style: Theme.of(context)
                                  .textTheme
                                  .caption
                                  .copyWith(
                                      height: 1.4, color: Colors.grey[600]),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12.0),
                    child: Container(
                      color: Colors.grey[600],
                      height: 1.0,
                      width: double.infinity,
                    ),
                  ),
                  if (model.text != '')
                    Text(
                      '${model.text}',
                      style: Theme.of(context)
                          .textTheme
                          .subtitle1
                          .copyWith(fontSize: 16.0, color: Colors.white),
                    ),
                  if (model.imagePost != '')
                    Padding(
                      padding: const EdgeInsets.only(top: 15.0),
                      child: FullScreenWidget(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(4.0),
                          child: Container(
                            height: 165.0,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4.0),
                              image: DecorationImage(
                                image: NetworkImage('${model.imagePost}'),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 5.0, horizontal: 10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Icon(
                                Icons.favorite,
                                size: 20.0,
                                color: Colors.amber,
                              ),
                              SizedBox(
                                width: 5.0,
                              ),
                              Text(
                                '${model.like}',
                                style: Theme.of(context)
                                    .textTheme
                                    .caption
                                    .copyWith(
                                        color: Colors.white, fontSize: 13.0),
                              )
                            ],
                          ),
                        ),
                        SizedBox(
                          width: 20.0,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Icon(
                                Icons.chat_outlined,
                                size: 20.0,
                                color: Colors.white,
                              ),
                              SizedBox(
                                width: 5.0,
                              ),
                              Text(
                                '${model.comment}',
                                style: Theme.of(context)
                                    .textTheme
                                    .caption
                                    .copyWith(
                                        color: Colors.white, fontSize: 13.0),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    color: Colors.grey[600],
                    width: double.infinity,
                    height: 1.0,
                  ),
                  // Row(
                  //   children: [
                  //     Expanded(
                  //       child: InkWell(
                  //           child: Row(
                  //             children: [
                  //               CircleAvatar(
                  //                   backgroundColor: Colors.amber,
                  //                   radius: 18.0,
                  //                   backgroundImage: NetworkImage(
                  //                       '${SocialCubit.get(context).userModel.image}')),
                  //               SizedBox(
                  //                 width: 15.0,
                  //               ),
                  //               Text(
                  //                 'write a comment...',
                  //                 style: Theme.of(context)
                  //                     .textTheme
                  //                     .caption
                  //                     .copyWith(color: Colors.grey[400]),
                  //               )
                  //             ],
                  //           ),
                  //           onTap: () {
                  //             SocialCubit.get(context).getComment(
                  //                 postId:
                  //                     SocialCubit.get(context).postId[index]);
                  //             // print(SocialCubit.get(context).postModel.image);
                  //
                  //             navigateTo(
                  //                 context,
                  //                 CommentScreen(index,
                  //                     SocialCubit.get(context).posts[index]));
                  //           }),
                  //     ),
                  //     InkWell(
                  //       child: Row(
                  //         children: [
                  //           Icon(
                  //             IconBroken.Heart,
                  //             size: 16.0,
                  //             color: Colors.amber,
                  //           ),
                  //           SizedBox(
                  //             width: 5.0,
                  //           ),
                  //           Text(
                  //             'Like',
                  //             style: Theme.of(context)
                  //                 .textTheme
                  //                 .caption
                  //                 .copyWith(color: Colors.white),
                  //           )
                  //         ],
                  //       ),
                  //       onTap: () {
                  //         SocialCubit.get(context).isLikePost(
                  //             SocialCubit.get(context).postId[index]);
                  //         if (SocialCubit.get(context).isLike == false) {
                  //           SocialCubit.get(context).likePost(
                  //               SocialCubit.get(context).postId[index]);
                  //         } else {
                  //           SocialCubit.get(context).dislikePost(
                  //               SocialCubit.get(context).postId[index]);
                  //         }
                  //       },
                  //     ),
                  //   ],
                  // ),
                ],
              ),
            ),
          ),
        ),
      );
}
