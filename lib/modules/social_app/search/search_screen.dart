import 'package:conditional_builder/conditional_builder.dart';
import 'package:first_app/layout/social_app/cubit/social_cubit.dart';
import 'package:first_app/layout/social_app/cubit/social_state.dart';
import 'package:first_app/modules/social_app/profile/profile_screen.dart';
import 'package:first_app/modules/social_app/search/friend_profile.dart';
import 'package:first_app/modules/social_app/users/user_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';

import '../../../models/social_app/social_user_model.dart';
import '../../../shared/components/components.dart';
import '../../../shared/style/icon_broken.dart';

class SearchScreen extends StatelessWidget {
  var searchController = TextEditingController();
  dynamic text;
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialCubit, SocialStates>(
      listener: (context, state) {},
      builder: (context, state) => Scaffold(
        appBar: AppBar(
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: HexColor('#17202A'),
          ),
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: CircleAvatar(
              radius: 18.0,
              child: Icon(
                Icons.close_outlined,
                color: Colors.black,
              ),
              backgroundColor: Colors.amber,
            ),
          ),
          backgroundColor: HexColor('#17202A'),
          title: Center(
            child: Text(
              'SEARCH',
              style: TextStyle(color: Colors.white, fontSize: 30.0),
            ),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: InkWell(
                onTap: () {
                  navigateTo(context, ProfileScreen());
                },
                child: CircleAvatar(
                  backgroundColor: Colors.amber,
                  radius: 25.0,
                  backgroundImage: NetworkImage(
                      '${SocialCubit.get(context).userModel.image}'),
                ),
              ),
            )
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 15.0),
          child: Column(
            children: [
              defaultFormField(
                  onSubmit: (value) {
                    SocialCubit.get(context).searchUser(value);
                    text = value;
                  },
                  colorBorder: Colors.amber,
                  labelStyle: TextStyle(color: Colors.white),
                  colorPrefix: Colors.grey[500],
                  colorLayout: Colors.amber,
                  controller: searchController,
                  type: TextInputType.text,
                  validated: (String value) {
                    if (value.isEmpty) {
                      return 'Search must not be empty';
                    } else {
                      return null;
                    }
                  },
                  prefix: IconBroken.Search,
                  textStyle: TextStyle(color: Colors.grey[300]),
                  label: 'Search'),
              SizedBox(
                height: 20.0,
              ),
              ConditionalBuilder(
                condition: SocialCubit.get(context).search != null,
                builder: (context) => buildSearch(
                  SocialCubit.get(context).search,
                  context,
                ),
                fallback: (context) => Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20.0),
                            color: Colors.amber),
                        height: 113.0,
                        child: Padding(
                          padding: const EdgeInsets.all(25.0),
                          child: Text(
                            'You can search for your friends here',
                            // 'Sorry, we could not find the person you wanted',
                            style: TextStyle(
                                fontSize: 20.0, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildSearch(
    Map<String, dynamic> model,
    context,
  ) {
    if (model['image'] != null &&
        model['name'] != null &&
        model['name'] == text) {
      return InkWell(
        onTap: () {
          navigateTo(
              context,
              FriendProfile(
                userUid: model['uId'],
              ));
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
                  backgroundImage: NetworkImage('${model['image']}'),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Text(
                    '${model['name']}',
                    style: TextStyle(color: Colors.grey[300], fontSize: 20.0),
                  ),
                ),
                Spacer(),
                IconButton(
                  onPressed: () {
                    navigateTo(
                        context,
                        FriendProfile(
                          userUid: model['uId'],
                        ));
                  },
                  icon: CircleAvatar(
                    child: Icon(
                      Icons.arrow_forward,
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
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.0), color: Colors.amber),
            height: 118.0,
            child: Padding(
              padding: const EdgeInsets.all(25.0),
              child: Text(
                // 'You can search for your friends here',
                'Sorry, we could not find the person you wanted',
                style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
