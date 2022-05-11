import 'dart:ffi';

import 'package:conditional_builder/conditional_builder.dart';
import 'package:first_app/layout/social_app/cubit/social_cubit.dart';
import 'package:first_app/layout/social_app/cubit/social_state.dart';
import 'package:first_app/models/social_app/social_user_model.dart';
import 'package:first_app/shared/components/components.dart';
import 'package:first_app/shared/style/icon_broken.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';

import '../../../models/social_app/comment_model.dart';
import '../../../models/social_app/post_model.dart';

class CommentScreen extends StatelessWidget {
  var commentController = TextEditingController();
  int postIndex;
  PostModel postModel;

  CommentScreen(
    this.postIndex,
    this.postModel,
  );

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      SocialCubit.get(context).getUser(postModel.uId);
      return BlocConsumer<SocialCubit, SocialStates>(
        listener: (context, state) {},
        builder: (context, state) {
          return Scaffold(
            backgroundColor: HexColor('#212F3D'),
            body: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 40.0),
                    child: Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: Colors.amber,
                          radius: 30.0,
                          backgroundImage: NetworkImage('${postModel.image}'),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                '${postModel.name}',
                                style: TextStyle(
                                    height: 1.0,
                                    fontSize: 16.0,
                                    color: Colors.white),
                              ),
                              Text(
                                '${postModel.dateTime}',
                                style: TextStyle(color: Colors.grey[400]),
                              )
                            ],
                          ),
                        ),
                        Spacer(),
                        InkWell(
                          child: Stack(
                            alignment: AlignmentDirectional.center,
                            children: [
                              CircleAvatar(
                                radius: 13.0,
                                backgroundColor: Colors.white,
                              ),
                              Icon(
                                Icons.close_outlined,
                                size: 27.0,
                              ),
                            ],
                          ),
                          onTap: () {
                            Navigator.pop(context);
                          },
                        ),
                        SizedBox(
                          width: 10.0,
                        ),
                      ],
                    ),
                  ),
                  ConditionalBuilder(
                      condition: SocialCubit.get(context).comments.length > 0,
                      builder: (context) => commentItem(
                          context,
                          SocialCubit.get(context).comments,
                          SocialCubit.get(context).postId[postIndex],
                          SocialCubit.get(context).user),
                      fallback: (context) => Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'There are no comments yet',
                                  style: TextStyle(
                                      color: Colors.grey[500], fontSize: 20.0),
                                ),
                                Text(
                                  'be the first to comment',
                                  style: TextStyle(
                                      color: Colors.grey[500], fontSize: 19.0),
                                ),
                                Spacer(),
                                Row(
                                  children: [
                                    Expanded(
                                      child: TextFormField(
                                          controller: commentController,
                                          minLines: 1,
                                          maxLines: 2,
                                          style: TextStyle(color: Colors.white),
                                          keyboardType: TextInputType.multiline,
                                          textInputAction:
                                              TextInputAction.newline,
                                          validator: (String value) {
                                            if (value.isEmpty) {
                                              return 'Comment text must not be empty';
                                            } else {
                                              return null;
                                            }
                                          },
                                          decoration: InputDecoration(
                                            fillColor:
                                                Colors.grey.withOpacity(0.3),
                                            filled: true,
                                            focusedBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Colors.grey
                                                        .withOpacity(0.3)),
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        50.0)),
                                            contentPadding:
                                                const EdgeInsets.symmetric(
                                                    horizontal: 25.0,
                                                    vertical: 5.0),
                                            hintText: 'Write a comment...',
                                            hintStyle: TextStyle(
                                                color: Colors.grey[500]),
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(50.0),
                                            ),
                                          )),
                                    ),
                                    SizedBox(
                                      width: 10.0,
                                    ),
                                    CircleAvatar(
                                      backgroundColor: Colors.amber,
                                      radius: 20.0,
                                      child: IconButton(
                                        onPressed: () {
                                          if (commentController.text != '')
                                            SocialCubit.get(context).addComment(
                                              postId: SocialCubit.get(context)
                                                  .postId[postIndex],
                                              comment: commentController.text,
                                            );
                                          if (postModel.uId ==
                                              SocialCubit.get(context).user.uId)
                                            SocialCubit.get(context)
                                                .sendAppNotification(
                                                    content:
                                                        'commented on a post you shared',
                                                    contentId: postModel.uId,
                                                    contentKey: 'commentPost',
                                                    reseverId: postModel.uId,
                                                    reseverName:
                                                        postModel.name);
                                          if (postModel.uId ==
                                              SocialCubit.get(context).user.uId)
                                            SocialCubit.get(context)
                                                .sendNotification(
                                              token: SocialCubit.get(context)
                                                  .user
                                                  .token,
                                              senderName:
                                                  SocialCubit.get(context)
                                                      .userModel
                                                      .name,
                                              messageText:
                                                  '${SocialCubit.get(context).userModel.name}' +
                                                      ' commented on a post you shared',
                                            );
                                          commentController.clear();
                                        },
                                        icon: Icon(
                                          Icons.send_rounded,
                                          size: 25.0,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          )),
                ],
              ),
            ),
            // ConditionalBuilder(
            //   condition: SocialCubit.get(context).commentModel.length > 0,
            //   builder: (context) => ,
            //   fallback: (context) => Center(
            //       child: Text(
            //     'There are no comments yet, be the first to comment',
            //   )),
            // ),
          );
        },
      );
    });
  }

  Widget commentItem(context, List<CommentModel> comments, String index,
      SocialUserModel user) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: ListView.separated(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemBuilder: (context, index) => Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(30.0)),
                    ),
                    color: Colors.black.withOpacity(.4),
                    child: Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: Row(
                        children: [
                          CircleAvatar(
                            backgroundColor: Colors.amber,
                            radius: 27.0,
                            backgroundImage:
                                NetworkImage(comments[index].image),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 10.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${comments[index].name}',
                                  style: TextStyle(
                                      height: 2.0, color: Colors.grey[400]),
                                ),
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width - 130,
                                  child: Text(
                                    comments[index].textComment,
                                    style: TextStyle(
                                        fontSize: 17.0,
                                        height: 1.5,
                                        color: Colors.white),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                // if (SocialCubit.get(context).commentImage !=
                                //     null)
                                //   Column(
                                //     children: [
                                //       Container(
                                //         width: 300.0,
                                //         height: 160.0,
                                //         decoration: BoxDecoration(
                                //             image: DecorationImage(
                                //                 image: NetworkImage(
                                //                   '${comments[index].imageComment}',
                                //                 ),
                                //                 fit: BoxFit.cover),
                                //             borderRadius:
                                //                 BorderRadius.circular(10.0)),
                                //       ),
                                //       Text(comments[index].textComment,
                                //           style: TextStyle(
                                //               fontSize: 17.0,
                                //               height: 1.5,
                                //               color: Colors.white))
                                //     ],
                                //   ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  separatorBuilder: (context, index) => SizedBox(
                    height: 8.0,
                  ),
                  itemCount: SocialCubit.get(context).comments.length,
                ),
              ),
            ),
          ),
          SizedBox(
            height: 10.0,
          ),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                    controller: commentController,
                    minLines: 1,
                    maxLines: 2,
                    style: TextStyle(color: Colors.white),
                    keyboardType: TextInputType.multiline,
                    textInputAction: TextInputAction.newline,
                    validator: (String value) {
                      if (value.isEmpty) {
                        return 'Comment text must not be empty';
                      } else {
                        return null;
                      }
                    },
                    decoration: InputDecoration(
                      fillColor: Colors.grey.withOpacity(0.3),
                      filled: true,
                      focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.grey.withOpacity(0.3)),
                          borderRadius: BorderRadius.circular(50.0)),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 25.0, vertical: 5.0),
                      hintText: 'Write a comment...',
                      hintStyle: TextStyle(color: Colors.grey[500]),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(50.0),
                      ),
                    )),
              ),
              SizedBox(
                width: 10.0,
              ),
              CircleAvatar(
                backgroundColor: Colors.amber,
                radius: 20.0,
                child: IconButton(
                  onPressed: () {
                    if (commentController.text != '')
                      SocialCubit.get(context).addComment(
                        postId: index,
                        comment: commentController.text,
                      );
                    if (postModel.uId == user.uId)
                      SocialCubit.get(context).sendAppNotification(
                          content: 'commented on a post you shared',
                          contentId: postModel.uId,
                          contentKey: 'commentPost',
                          reseverId: postModel.uId,
                          reseverName: postModel.name);
                    if (postModel.uId == user.uId)
                      SocialCubit.get(context).sendNotification(
                        token: user.token,
                        senderName: SocialCubit.get(context).userModel.name,
                        messageText:
                            '${SocialCubit.get(context).userModel.name}' +
                                ' commented on a post you shared',
                      );
                    commentController.clear();
                  },
                  icon: Icon(
                    Icons.send_rounded,
                    size: 25.0,
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 13.0,
          ),
        ],
      ),
    );
  }
}
