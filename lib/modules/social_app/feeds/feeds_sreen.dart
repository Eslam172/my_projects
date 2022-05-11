import 'package:conditional_builder/conditional_builder.dart';
import 'package:first_app/layout/social_app/cubit/social_cubit.dart';
import 'package:first_app/layout/social_app/cubit/social_state.dart';
import 'package:first_app/models/social_app/post_model.dart';
import 'package:first_app/models/user/user_model.dart';
import 'package:first_app/modules/social_app/post/post_screen.dart';
import 'package:first_app/modules/social_app/profile/profile_screen.dart';
import 'package:first_app/modules/social_app/search/search_screen.dart';
import 'package:first_app/shared/components/components.dart';
import 'package:first_app/shared/style/colors.dart';
import 'package:first_app/shared/style/icon_broken.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:full_screen_image/full_screen_image.dart';
import 'package:hexcolor/hexcolor.dart';

import '../comment/comment_screen.dart';
import '../single_post/single_post.dart';

class FeedsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialCubit, SocialStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return ConditionalBuilder(
          condition: SocialCubit.get(context).userModel != null &&
              SocialCubit.get(context).posts.length > 0,
          builder: (context) => Scaffold(
            backgroundColor: HexColor('#212F3D'),
            appBar: AppBar(
              backgroundColor: HexColor('#212F3D'),
              automaticallyImplyLeading: false,
              title: Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        navigateTo(context, PostScreen());
                      },
                      child: Container(
                        // width: double.infinity,
                        height: 40.0,
                        decoration: BoxDecoration(
                          color: Colors.grey[800],
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15.0),
                          child: Align(
                            alignment: AlignmentDirectional.center,
                            child: Text(
                              'What is in your mind ?',
                              style: TextStyle(
                                  color: Colors.grey[400], fontSize: 16.0),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 0.0, left: 5.0),
                    child: InkWell(
                      onTap: () {
                        navigateTo(context, ProfileScreen());
                      },
                      child: CircleAvatar(
                        backgroundColor: Colors.amber,
                        radius: 20.0,
                        backgroundImage: NetworkImage(
                            SocialCubit.get(context).userModel.image),
                      ),
                    ),
                  ),
                ],
              ),
              actions: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: CircleAvatar(
                    child: InkWell(
                      onTap: () {
                        navigateTo(context, SearchScreen());
                      },
                      child: Icon(
                        Icons.search,
                        color: Colors.black,
                        size: 30.0,
                      ),
                    ),
                    backgroundColor: Colors.amber,
                    radius: 18.0,
                  ),
                ),
              ],
            ),
            body: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0, left: 12.0),
                    child: Text(
                      'Discover',
                      style: TextStyle(fontSize: 28.0, color: Colors.white),
                    ),
                  ),
                  ListView.separated(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemBuilder: (context, index) => buildPostItem(
                          SocialCubit.get(context).posts[index],
                          context,
                          index),
                      separatorBuilder: (context, index) => SizedBox(
                            height: 15.0,
                          ),
                      itemCount: SocialCubit.get(context).posts.length),
                ],
              ),
            ),
          ),
          fallback: (context) => Center(
              child: CircularProgressIndicator(
            color: Colors.amber,
          )),
        );
      },
    );
  }
}

Widget buildPostItem(PostModel model, context, index) => InkWell(
      onTap: () {
        navigateTo(
            context,
            SinglePost(
              index: index,
              postId: model.postId,
            ));
      },
      child: Padding(
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
                      SizedBox(
                        width: 15.0,
                      ),
                      IconButton(
                          color: Colors.grey[600],
                          onPressed: () {
                            showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                      backgroundColor: HexColor('#212F3D'),

                                      // alignment: AlignmentDirectional.bottomEnd,

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
                                                      .deletePost(
                                                          SocialCubit.get(
                                                                  context)
                                                              .postId[index],
                                                          model.uId);
                                                },
                                                child: Text(
                                                  'Delete this post',
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 20.0),
                                                ),
                                              ),
                                            ],
                                          ),
                                          alignment:
                                              AlignmentDirectional.topStart,
                                        )
                                      ],
                                    ));
                          },
                          icon: Icon(
                            Icons.more_horiz,
                            size: 20.0,
                          )),
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
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Container(
                      color: Colors.grey[600],
                      width: double.infinity,
                      height: 1.0,
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: InkWell(
                            child: Row(
                              children: [
                                CircleAvatar(
                                    backgroundColor: Colors.amber,
                                    radius: 18.0,
                                    backgroundImage: NetworkImage(
                                        '${SocialCubit.get(context).userModel.image}')),
                                SizedBox(
                                  width: 15.0,
                                ),
                                Text(
                                  'write a comment...',
                                  style: Theme.of(context)
                                      .textTheme
                                      .caption
                                      .copyWith(color: Colors.grey[400]),
                                )
                              ],
                            ),
                            onTap: () {
                              SocialCubit.get(context).getComment(
                                postId: SocialCubit.get(context).postId[index],
                              );

                              // print(SocialCubit.get(context).postModel.image);

                              navigateTo(
                                  context,
                                  CommentScreen(
                                    index,
                                    SocialCubit.get(context).posts[index],
                                  ));
                            }),
                      ),
                      InkWell(
                        child: Row(
                          children: [
                            Icon(
                              IconBroken.Heart,
                              size: 16.0,
                              color: Colors.amber,
                            ),
                            SizedBox(
                              width: 5.0,
                            ),
                            Text(
                              'Like',
                              style: Theme.of(context)
                                  .textTheme
                                  .caption
                                  .copyWith(color: Colors.white),
                            )
                          ],
                        ),
                        onTap: () {
                          SocialCubit.get(context).isLikePost(
                              SocialCubit.get(context).postId[index]);

                          if (SocialCubit.get(context).isLike == false) {
                            SocialCubit.get(context).likePost(
                                SocialCubit.get(context).postId[index]);
                          } else {
                            SocialCubit.get(context).dislikePost(
                                SocialCubit.get(context).postId[index]);
                          }
                        },
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