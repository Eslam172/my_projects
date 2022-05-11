import 'package:conditional_builder/conditional_builder.dart';
import 'package:first_app/layout/social_app/cubit/social_cubit.dart';
import 'package:first_app/layout/social_app/cubit/social_state.dart';
import 'package:first_app/models/social_app/social_user_model.dart';
import 'package:first_app/modules/social_app/chats/chats_dtails.dart';
import 'package:first_app/shared/components/components.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:full_screen_image/full_screen_image.dart';
import 'package:hexcolor/hexcolor.dart';

import '../../../models/social_app/recent_message.dart';

// class ChatsScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Builder(builder: (context) {
//       // SocialCubit.get(context)
//       //     .getFriends(SocialCubit.get(context).userModel.uId);
//       List<RecentMessagesModel> recentMessages =
//           SocialCubit.get(context).recentMessages;
//       SocialCubit.get(context)
//           .getRecentMessage(SocialCubit.get(context).userModel.uId);
//       return Scaffold(
//         appBar: AppBar(
//           systemOverlayStyle: SystemUiOverlayStyle(
//             statusBarColor: HexColor('#17202A'),
//           ),
//           backgroundColor: HexColor('#17202A'),
//           title: Text(
//             'Massage',
//             style: TextStyle(color: Colors.white, fontSize: 30.0),
//           ),
//         ),
//         backgroundColor: HexColor('#212F3D'),
//         body: BlocConsumer<SocialCubit, SocialStates>(
//           listener: (context, state) {},
//           builder: (context, state) {
//             return ConditionalBuilder(
//                 condition: recentMessages.length > 0,
//                 builder: (context) => ListView.separated(
//                     physics: BouncingScrollPhysics(),
//                     itemBuilder: (context, index) =>
//                         buildChatItem(recentMessages[index], context),
//                     separatorBuilder: (context, index) => myDivider(),
//                     itemCount: recentMessages.length),
//                 fallback: (context) => Center(
//                         child: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Text(
//                           'You don\’t have any messages yet',
//                           style: TextStyle(
//                               fontSize: 25.0, color: Colors.grey[500]),
//                         ),
//                         Text(
//                           'Start chatting with your friends',
//                           style: TextStyle(
//                               fontSize: 25.0, color: Colors.grey[500]),
//                         ),
//                         InkWell(
//                           onTap: () {
//                             SocialCubit.get(context).changeBottomNav(2);
//                           },
//                           child: Container(
//                             width: 60.0,
//                             height: 40.0,
//                             decoration: BoxDecoration(
//                                 borderRadius: BorderRadius.circular(15.0),
//                                 color: Colors.amber),
//                             child: Icon(
//                               Icons.arrow_forward,
//                               size: 30.0,
//                             ),
//                           ),
//                         ),
//                       ],
//                     )));
//           },
//         ),
//       );
//     });
//   }
//
//   Widget buildChatItem(RecentMessagesModel model, context) {
//     return InkWell(
//       onTap: () {
//         model.receiverId == SocialCubit.get(context).userModel.uId
//             ? SocialCubit.get(context)
//                 .readRecentMessage(recentMessageId: model.receiverId)
//             : SocialCubit.get(context)
//                 .readRecentMessage(recentMessageId: model.senderId);
//         model.receiverId == SocialCubit.get(context).userModel.uId
//             ? navigateTo(
//                 context,
//                 ChatsDetails(
//                   userUid: model.senderId,
//                 ))
//             : navigateTo(
//                 context,
//                 ChatsDetails(
//                   userUid: model.receiverId,
//                 ));
//       },
//       child: Padding(
//         padding: const EdgeInsets.all(15.0),
//         child: Row(
//           children: [
//             FullScreenWidget(
//               backgroundColor: HexColor('#212F3D'),
//               child: ClipRRect(
//                 // borderRadius: BorderRadius.circular(4.0),
//                 child: CircleAvatar(
//                   backgroundColor: Colors.amber,
//                   radius: 30.0,
//                   backgroundImage:
//                       model.receiverId == SocialCubit.get(context).userModel.uId
//                           ? NetworkImage('${model.senderProfilePic}')
//                           : NetworkImage('${model.receiverProfilePic}'),
//                 ),
//               ),
//             ),
//             SizedBox(
//               width: 10.0,
//             ),
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   Row(
//                     children: [
//                       Text(
//                         '${model.receiverId == SocialCubit.get(context).userModel.uId ? model.senderName : model.receiverName}',
//                         style:
//                             TextStyle(fontSize: 17.0, color: Colors.grey[300]),
//                       ),
//                       Spacer(),
//                       Text(
//                         '${model.time.toString()}',
//                         style: TextStyle(color: Colors.grey[600]),
//                       )
//                     ],
//                   ),
//                   model.recentMessageImage != null
//                       ? model.receiverId ==
//                               SocialCubit.get(context).userModel.uId
//                           ? model.read
//                               ? Text(
//                                   'photo',
//                                   style: TextStyle(
//                                       color: Colors.grey[400], fontSize: 15.0),
//                                 )
//                               : Text(
//                                   'photo',
//                                   style: TextStyle(
//                                       color: Colors.white, fontSize: 16.0),
//                                 )
//                           : Row(
//                               children: [
//                                 Text('you' + ":",
//                                     style: TextStyle(
//                                         color: Colors.grey[500],
//                                         fontSize: 15.0)),
//                                 SizedBox(
//                                   width: 4.0,
//                                 ),
//                                 Text(
//                                   'photo',
//                                   style: TextStyle(
//                                       color: Colors.grey[500], fontSize: 15.0),
//                                 )
//                               ],
//                             )
//                       : model.recentMessageText != null
//                           ? model.receiverId ==
//                                   SocialCubit.get(context).userModel.uId
//                               ? model.read
//                                   ? Text(
//                                       '${model.recentMessageText}',
//                                       style: TextStyle(
//                                           color: Colors.grey[400],
//                                           fontSize: 15.0),
//                                       maxLines: 1,
//                                       overflow: TextOverflow.ellipsis,
//                                     )
//                                   : Text(
//                                       '${model.recentMessageText}',
//                                       style: TextStyle(
//                                           color: Colors.white, fontSize: 16.0),
//                                       maxLines: 1,
//                                       overflow: TextOverflow.ellipsis,
//                                     )
//                               : Row(
//                                   children: [
//                                     Text('you' + ":",
//                                         style: TextStyle(
//                                             color: Colors.grey[500],
//                                             fontSize: 15.0)),
//                                     SizedBox(
//                                       width: 4.0,
//                                     ),
//                                     Text('${model.recentMessageText}',
//                                         style: TextStyle(
//                                             color: Colors.grey[500],
//                                             fontSize: 15.0),
//                                         maxLines: 1,
//                                         overflow: TextOverflow.ellipsis)
//                                   ],
//                                 )
//                           : Text(''),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
class ChatsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      SocialCubit.get(context)
          .getFriends(SocialCubit.get(context).userModel.uId);
      // List<RecentMessagesModel> recentMessages =
      //     SocialCubit.get(context).recentMessages;
      // SocialCubit.get(context)
      //     .getRecentMessage(myUid: SocialCubit.get(context).userModel.uId);
      return Scaffold(
        appBar: AppBar(
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: HexColor('#17202A'),
          ),
          backgroundColor: HexColor('#17202A'),
          title: Text(
            'Massage',
            style: TextStyle(color: Colors.white, fontSize: 30.0),
          ),
        ),
        backgroundColor: HexColor('#212F3D'),
        body: BlocConsumer<SocialCubit, SocialStates>(
          listener: (context, state) {},
          builder: (context, state) {
            return ConditionalBuilder(
                condition: SocialCubit.get(context).friends.length > 0,
                builder: (context) => ListView.separated(
                    physics: BouncingScrollPhysics(),
                    itemBuilder: (context, index) => buildChatItem(
                          SocialCubit.get(context).friends[index],
                          context,
                        ),
                    separatorBuilder: (context, index) => myDivider(),
                    itemCount: SocialCubit.get(context).friends.length),
                fallback: (context) => Center(
                        child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'You don\'t have friends yet',
                          style: TextStyle(
                              fontSize: 25.0, color: Colors.grey[500]),
                        ),
                        Text(
                          'invite some friends',
                          style: TextStyle(
                              fontSize: 25.0, color: Colors.grey[500]),
                        ),
                        InkWell(
                          onTap: () {
                            SocialCubit.get(context).changeBottomNav(2);
                          },
                          child: Container(
                            width: 60.0,
                            height: 40.0,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15.0),
                                color: Colors.amber),
                            child: Icon(
                              Icons.arrow_forward,
                              size: 30.0,
                            ),
                          ),
                        ),
                      ],
                    )));
          },
        ),
      );
    });
  }

  Widget buildChatItem(
    SocialUserModel model,
    context,
  ) =>
      InkWell(
        onTap: () {
          navigateTo(
              context,
              ChatsDetails(
                userModel: model,
              ));
        },
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Row(
            children: [
              FullScreenWidget(
                backgroundColor: HexColor('#212F3D'),
                child: ClipRRect(
                  // borderRadius: BorderRadius.circular(4.0),
                  child: CircleAvatar(
                    backgroundColor: Colors.amber,
                    radius: 30.0,
                    backgroundImage: NetworkImage('${model.image}'),
                  ),
                ),
              ),
              SizedBox(
                width: 10.0,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '${model.name}',
                      style: TextStyle(fontSize: 17.0, color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
}
