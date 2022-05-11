import 'package:first_app/layout/social_app/cubit/social_cubit.dart';
import 'package:first_app/layout/social_app/cubit/social_state.dart';
import 'package:first_app/modules/social_app/feeds/feeds_sreen.dart';
import 'package:first_app/shared/components/components.dart';
import 'package:first_app/shared/style/icon_broken.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:full_screen_image/full_screen_image.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';

class PostScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var postController = TextEditingController();
    var formKey = GlobalKey<FormState>();
    return BlocConsumer<SocialCubit, SocialStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return Scaffold(
          appBar: defaultAppBar(
            color: HexColor('#212F3D'),
            iconColor: Colors.white,
            textColor: Colors.white,
            context: context,
            title: 'Create Post',
            actions: [
              IconButton(
                  onPressed: () {
                    var now = DateFormat('yyyy-MM-dd - kk:mm:a')
                        .format(DateTime.now());
                    // DateTime.now();
                    if (postController.text != '') {
                      if (SocialCubit.get(context).postImage == null) {
                        SocialCubit.get(context).createPost(
                            context: context,
                            text: postController.text,
                            dateTime: now.toString());
                        Navigator.pop(context);
                      } else {
                        SocialCubit.get(context).uploadPostImage(
                            context: context,
                            text: postController.text,
                            dateTime: now.toString());
                      }
                    }
                    if (SocialCubit.get(context).postImage != null) {
                      if (postController.text == '') {
                        SocialCubit.get(context).uploadPostImage(
                            context: context,
                            text: postController.text,
                            dateTime: now.toString());
                      }
                    }
                    // if (SocialCubit.get(context).postImage == null &&
                    //     postController.text == '') {

                    // }
                  },
                  icon: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      child: Icon(Icons.done))),
              SizedBox(
                width: 10.0,
              ),
            ],
          ),
          body: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  if (state is CreatePostLoadingState)
                    LinearProgressIndicator(
                      color: Colors.amber,
                    ),
                  if (state is CreatePostLoadingState)
                    SizedBox(
                      height: 10.0,
                    ),
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 27.0,
                        backgroundColor: Colors.amber,
                        backgroundImage: NetworkImage(
                            '${SocialCubit.get(context).userModel.image}'),
                      ),
                      SizedBox(
                        width: 15.0,
                      ),
                      Expanded(
                        child: Text(
                          '${SocialCubit.get(context).userModel.name}',
                          style: TextStyle(
                              height: 1.4, fontSize: 15.0, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                  Expanded(
                    child: TextFormField(
                      validator: (String value) {
                        if (value.isEmpty) {
                          return 'The post should not be empty';
                        } else {
                          return null;
                        }
                      },
                      style: TextStyle(color: Colors.white),
                      controller: postController,
                      decoration: InputDecoration(
                          hintText: 'what is in your mind....',
                          hintStyle: TextStyle(color: Colors.grey),
                          border: InputBorder.none),
                    ),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  if (SocialCubit.get(context).postImage != null)
                    Expanded(
                      child: Stack(
                        alignment: AlignmentDirectional.topEnd,
                        children: [
                          FullScreenWidget(
                            backgroundColor: HexColor('#212F3D'),
                            child: Center(
                              child: Hero(
                                tag: 'custom back ground',
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(4.0),
                                  child: Container(
                                    height: 200.0,
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(4.0),
                                      image: DecorationImage(
                                        image: FileImage(
                                            SocialCubit.get(context).postImage),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          IconButton(
                              onPressed: () {
                                SocialCubit.get(context).removePostImage();
                              },
                              icon: CircleAvatar(
                                  backgroundColor: Colors.amber,
                                  radius: 20.0,
                                  child: Icon(
                                    Icons.close,
                                    color: Colors.black,
                                    size: 20.0,
                                  ))),
                        ],
                      ),
                    ),
                  SizedBox(
                    height: 20.0,
                  ),
                  // TextButton(
                  //   onPressed: () {
                  //
                  //   },
                  //   child: Row(
                  //     mainAxisAlignment: MainAxisAlignment.center,
                  //     children: [
                  //       Icon(IconBroken.Image),
                  //       SizedBox(
                  //         width: 5.0,
                  //       ),
                  //       Text('add photo'),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30.0),
                    child: InkWell(
                      onTap: () {
                        SocialCubit.get(context).getPostImage();
                      },
                      child: Container(
                        height: 40.0,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20.0),
                          color: Colors.grey[600],
                        ),
                        child: Row(
                          // crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.image,
                              color: Colors.white,
                            ),
                            SizedBox(
                              width: 10.0,
                            ),
                            Text(
                              'Add photo',
                              style: TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              )),
        );
      },
    );
  }
}
