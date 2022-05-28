import 'package:conditional_builder/conditional_builder.dart';
import 'package:first_app/layout/social_app/cubit/social_cubit.dart';
import 'package:first_app/layout/social_app/cubit/social_state.dart';
import 'package:first_app/models/social_app/chat_model.dart';
import 'package:first_app/models/social_app/social_user_model.dart';
import 'package:first_app/modules/social_app/users/user_data.dart';
import 'package:first_app/shared/components/components.dart';
import 'package:first_app/shared/style/icon_broken.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:full_screen_image/full_screen_image.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

// var userState;
//
// class ChatsDetails extends StatelessWidget {
//   SocialUserModel userModel;
//   final ScrollController controller = ScrollController();
//   var uuid = Uuid();
//
//   ChatsDetails({this.userModel});
//
//   var chatController = TextEditingController();
//   var formKey = GlobalKey<FormState>();
//
//   @override
//   Widget build(BuildContext context) {
//     return Builder(builder: (BuildContext context) {
//       SocialCubit.get(context).getMessage(recieverId: userModel.uId);
//       SocialCubit.get(context).getUser(userModel.uId);
//       // SocialCubit.get(context).scrollDown(controller);
//
//       return BlocConsumer<SocialCubit, SocialStates>(
//         listener: (context, state) {
//           userState = state;
//         },
//         builder: (context, state) {
//           // SocialUserModel user = SocialCubit.get(context).user;
//           WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
//             scrollDown();
//           });
//           return Scaffold(
//             backgroundColor: HexColor('#212F3D'),
//             appBar: AppBar(
//               systemOverlayStyle: SystemUiOverlayStyle(
//                 statusBarColor: HexColor('#17202A'),
//               ),
//               backgroundColor: HexColor('#17202A'),
//               leading: Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 10.0),
//                 child: IconButton(
//                   color: Colors.white,
//                   icon: Icon(
//                     Icons.arrow_back,
//                     size: 28.0,
//                   ),
//                   onPressed: () {
//                     Navigator.pop(context);
//                   },
//                 ),
//               ),
//               title: Center(
//                 child: Text(
//                   '${userModel.name}',
//                   style: TextStyle(fontSize: 20.0, color: Colors.white),
//                 ),
//               ),
//               actions: [
//                 Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 20.0),
//                   child: CircleAvatar(
//                     backgroundColor: Colors.amber,
//                     backgroundImage: NetworkImage('${userModel.image}'),
//                   ),
//                 )
//               ],
//             ),
//             body: ConditionalBuilder(
//                 condition: SocialCubit.get(context).chats.length > 0,
//                 builder: (context) => Padding(
//                       padding: const EdgeInsets.all(20.0),
//                       child: Form(
//                         key: formKey,
//                         child: Column(
//                           children: [
//                             Expanded(
//                               child: SingleChildScrollView(
//                                 physics: BouncingScrollPhysics(),
//                                 controller: controller,
//                                 child: Column(
//                                   children: [
//                                     ListView.separated(
//                                         physics: NeverScrollableScrollPhysics(),
//                                         shrinkWrap: true,
//                                         reverse: true,
//                                         // controller: controller,
//
//                                         itemBuilder: (context, index) {
//                                           var chats = SocialCubit.get(context)
//                                               .chats[index];
//                                           if (SocialCubit.get(context)
//                                                   .userModel
//                                                   .uId ==
//                                               chats.senderId) {
//                                             return chatMe(chats, context);
//                                           }
//                                           return chatFriend(chats, context);
//                                         },
//                                         separatorBuilder: (context, index) =>
//                                             SizedBox(
//                                               height: 20.0,
//                                             ),
//                                         itemCount: SocialCubit.get(context)
//                                             .chats
//                                             .length),
//                                   ],
//                                 ),
//                               ),
//                             ),
//                             SizedBox(
//                               height: 10.0,
//                             ),
//                             Row(
//                               children: [
//                                 Expanded(
//                                   child: TextFormField(
//                                     controller: chatController,
//                                     minLines: 1,
//                                     maxLines: 2,
//                                     style: TextStyle(color: Colors.white),
//                                     keyboardType: TextInputType.multiline,
//                                     textInputAction: TextInputAction.newline,
//                                     validator: (String value) {
//                                       if (value.isEmpty) {
//                                         return 'chat text must not be empty';
//                                       } else {
//                                         return null;
//                                       }
//                                     },
//                                     decoration: InputDecoration(
//                                       suffixIcon: IconButton(
//                                         color: Colors.amber,
//                                         icon: Icon(IconBroken.Image),
//                                         onPressed: () {
//                                           SocialCubit.get(context).getChatImage(
//                                               messageuId: uuid.v4(),
//                                               text: chatController.text,
//                                               dateTime:
//                                                   DateTime.now().toString(),
//                                               recieverId: userModel.uId);
//                                           if (SocialCubit.get(context)
//                                                   .chatImageUrl !=
//                                               '')
//                                             SocialCubit.get(context)
//                                                 .sendAppNotification(
//                                                     content:
//                                                         ' send a picture to you',
//                                                     contentId: userModel.uId,
//                                                     contentKey: 'chat',
//                                                     reseverId: userModel.uId,
//                                                     reseverName:
//                                                         userModel.name);
//                                           if (SocialCubit.get(context)
//                                                   .chatImageUrl !=
//                                               '')
//                                             SocialCubit.get(context)
//                                                 .sendNotification(
//                                                     token: userModel.token,
//                                                     senderName:
//                                                         SocialCubit.get(
//                                                                 context)
//                                                             .userModel
//                                                             .name,
//                                                     messageText:
//                                                         '${SocialCubit.get(context).userModel.name}' +
//                                                             ' send a picture to you',
//                                                     messageImage:
//                                                         SocialCubit.get(context)
//                                                             .chatImageUrl);
//                                           // SocialCubit.get(context)
//                                           //     .setRecentMessage(
//                                           //   reciverId: userModel.uId,
//                                           //   reciverImage: userModel.image,
//                                           //   reciverName: userModel.name,
//                                           //   recentMessageImage:
//                                           //       SocialCubit.get(context)
//                                           //           .chatImageUrl,
//                                           //   time: DateTime.now().toString(),
//                                           // );
//                                           SocialCubit.get(context)
//                                               .chatImageUrl = '';
//                                         },
//                                       ),
//                                       fillColor: Colors.grey.withOpacity(0.3),
//                                       filled: true,
//                                       focusedBorder: OutlineInputBorder(
//                                           borderSide: BorderSide(
//                                               color:
//                                                   Colors.grey.withOpacity(0.3)),
//                                           borderRadius:
//                                               BorderRadius.circular(50.0)),
//                                       contentPadding:
//                                           const EdgeInsets.symmetric(
//                                               horizontal: 25.0, vertical: 5.0),
//                                       hintText: 'Write a message...',
//                                       hintStyle:
//                                           TextStyle(color: Colors.grey[500]),
//                                       border: OutlineInputBorder(
//                                         borderRadius:
//                                             BorderRadius.circular(50.0),
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                                 SizedBox(
//                                   width: 10.0,
//                                 ),
//                                 CircleAvatar(
//                                   backgroundColor: Colors.amber,
//                                   radius: 20.0,
//                                   child: IconButton(
//                                     onPressed: () {
//                                       if (chatController != null) if (formKey
//                                           .currentState
//                                           .validate()) {
//                                         SocialCubit.get(context).sendMessage(
//                                           messageuId: uuid.v4(),
//                                           text: chatController.text,
//                                           dateTime: DateTime.now().toString(),
//                                           recieverId: userModel.uId,
//                                         );
//                                         SocialCubit.get(context)
//                                             .sendAppNotification(
//                                                 content:
//                                                     ' send a message to you',
//                                                 contentId: userModel.uId,
//                                                 contentKey: 'chat',
//                                                 reseverId: userModel.uId,
//                                                 reseverName: userModel.name);
//
//                                         SocialCubit.get(context)
//                                             .sendNotification(
//                                           token: userModel.token,
//                                           senderName: SocialCubit.get(context)
//                                               .userModel
//                                               .name,
//                                           messageText: chatController.text,
//                                         );
//                                         // SocialCubit.get(context)
//                                         //     .setRecentMessage(
//                                         //   reciverId: userModel.uId,
//                                         //   reciverImage: userModel.image,
//                                         //   reciverName: userModel.name,
//                                         //   recentMessageText:
//                                         //       chatController.text,
//                                         //   time: DateTime.now().toString(),
//                                         // );
//                                         chatController.text = '';
//                                       }
//                                     },
//                                     icon: Icon(
//                                       Icons.send_rounded,
//                                       size: 25.0,
//                                       color: Colors.black,
//                                     ),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                 fallback: (context) {
//                   return Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Expanded(
//                         child: Column(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             Container(
//                               decoration: BoxDecoration(
//                                   borderRadius: BorderRadius.circular(20.0),
//                                   color: Colors.amber),
//                               child: Padding(
//                                 padding: const EdgeInsets.all(25.0),
//                                 child: Text(
//                                   'No messages here yet...',
//                                   style: TextStyle(
//                                       fontSize: 25.0,
//                                       fontWeight: FontWeight.bold),
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                       Padding(
//                         padding: const EdgeInsets.symmetric(horizontal: 20.0),
//                         child: Row(
//                           children: [
//                             Expanded(
//                               child: TextFormField(
//                                   controller: chatController,
//                                   minLines: 1,
//                                   maxLines: 2,
//                                   style: TextStyle(color: Colors.white),
//                                   keyboardType: TextInputType.multiline,
//                                   textInputAction: TextInputAction.newline,
//                                   validator: (String value) {
//                                     if (value.isEmpty) {
//                                       return 'chat text must not be empty';
//                                     } else {
//                                       return null;
//                                     }
//                                   },
//                                   decoration: InputDecoration(
//                                     fillColor: Colors.grey.withOpacity(0.3),
//                                     filled: true,
//                                     focusedBorder: OutlineInputBorder(
//                                         borderSide: BorderSide(
//                                             color:
//                                                 Colors.grey.withOpacity(0.3)),
//                                         borderRadius:
//                                             BorderRadius.circular(50.0)),
//                                     contentPadding: const EdgeInsets.symmetric(
//                                         horizontal: 25.0, vertical: 5.0),
//                                     hintText: 'Write a message...',
//                                     hintStyle:
//                                         TextStyle(color: Colors.grey[500]),
//                                     border: OutlineInputBorder(
//                                       borderRadius: BorderRadius.circular(50.0),
//                                     ),
//                                   )),
//                             ),
//                             SizedBox(
//                               width: 10.0,
//                             ),
//                             CircleAvatar(
//                               backgroundColor: Colors.amber,
//                               radius: 20.0,
//                               child: IconButton(
//                                 onPressed: () {
//                                   SocialCubit.get(context).sendMessage(
//                                     messageuId: uuid.v4(),
//                                     text: chatController.text,
//                                     dateTime: DateTime.now().toString(),
//                                     recieverId: userModel.uId,
//                                     // imageChat:
//                                     //     SocialCubit.get(context).chatImageUrl
//                                   );
//                                   SocialCubit.get(context).sendAppNotification(
//                                       content: ' send a message to you',
//                                       contentId: userModel.uId,
//                                       contentKey: 'chat',
//                                       reseverId: userModel.uId,
//                                       reseverName: userModel.name);
//
//                                   SocialCubit.get(context).sendNotification(
//                                     token: userModel.token,
//                                     senderName:
//                                         SocialCubit.get(context).userModel.name,
//                                     messageText: chatController.text,
//                                   );
//                                   chatController.text = '';
//                                 },
//                                 icon: Icon(
//                                   Icons.send_rounded,
//                                   size: 25.0,
//                                   color: Colors.black,
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                       SizedBox(
//                         height: 20.0,
//                       ),
//                     ],
//                   );
//                 }),
//           );
//         },
//       );
//     });
//   }
//
//   void scrollDown() async {
//     await Future.delayed(Duration(
//       microseconds: 0,
//     ));
//     controller.jumpTo(
//       controller.position.maxScrollExtent,
//     );
//   }
//
//   Widget chatFriend(ChatModel model, context) {
//     if (model.imageChat == '') {
//       return Align(
//         alignment: AlignmentDirectional.centerStart,
//         child: Container(
//           decoration: BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadiusDirectional.only(
//               bottomEnd: Radius.circular(15.0),
//               topEnd: Radius.circular(15.0),
//               topStart: Radius.circular(15.0),
//             ),
//           ),
//           constraints: BoxConstraints(maxWidth: 300.0),
//           padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
//           child: Text(
//             model.text,
//             style: TextStyle(fontSize: 18.0, height: 1.3),
//           ),
//         ),
//       );
//     }
//     return userState == CreateChatImageLoadingState
//         ? Align(
//             alignment: AlignmentDirectional.centerStart,
//             child: Container(
//               height: 230.0,
//               width: 300.0,
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(20.0),
//               ),
//               child: CircularProgressIndicator(
//                 color: HexColor('#212F3D'),
//               ),
//             ),
//           )
//         : Align(
//             alignment: AlignmentDirectional.centerStart,
//             child: FullScreenWidget(
//               backgroundColor: HexColor('#17202A'),
//               child: ClipRRect(
//                 child: Container(
//                   height: 230.0,
//                   width: 300.0,
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.circular(20.0),
//                     image: DecorationImage(
//                         image: NetworkImage('${model.imageChat}'),
//                         fit: BoxFit.cover),
//                   ),
//                 ),
//               ),
//             ),
//           );
//   }
//
//   Widget chatMe(ChatModel model, context) {
//     if (model.imageChat == '') {
//       return InkWell(
//         onLongPress: () {
//           return showDialog(
//               context: context,
//               builder: (context) => AlertDialog(
//                     backgroundColor: HexColor('#212F3D'),
//                     actions: [
//                       Align(
//                         child: Row(
//                           children: [
//                             Icon(
//                               Icons.delete,
//                               color: Colors.grey,
//                             ),
//                             SizedBox(
//                               width: 15.0,
//                             ),
//                             InkWell(
//                               onTap: () {
//                                 Navigator.of(context, rootNavigator: true)
//                                     .pop();
//                                 SocialCubit.get(context).deleteForEveryone(
//                                     messageId: model.messageId,
//                                     receiverId: model.recieverId);
//                               },
//                               child: Text(
//                                 'Delete For Every One',
//                                 style: TextStyle(
//                                     color: Colors.white, fontSize: 20.0),
//                               ),
//                             ),
//                           ],
//                         ),
//                         alignment: AlignmentDirectional.topStart,
//                       ),
//                       Align(
//                         child: Row(
//                           children: [
//                             Icon(
//                               Icons.delete,
//                               color: Colors.grey,
//                             ),
//                             SizedBox(
//                               width: 15.0,
//                             ),
//                             InkWell(
//                               onTap: () {
//                                 Navigator.of(context, rootNavigator: true)
//                                     .pop();
//                                 SocialCubit.get(context).deleteForMe(
//                                     messageId: model.messageId,
//                                     receiverId: model.recieverId);
//                               },
//                               child: Text(
//                                 'Delete For me',
//                                 style: TextStyle(
//                                     color: Colors.white, fontSize: 20.0),
//                               ),
//                             ),
//                           ],
//                         ),
//                         alignment: AlignmentDirectional.topStart,
//                       ),
//                     ],
//                   ));
//         },
//         child: Align(
//           alignment: AlignmentDirectional.centerEnd,
//           child: Container(
//             decoration: BoxDecoration(
//               color: Colors.amber,
//               borderRadius: BorderRadiusDirectional.only(
//                 bottomStart: Radius.circular(15.0),
//                 topEnd: Radius.circular(15.0),
//                 topStart: Radius.circular(15.0),
//               ),
//             ),
//             constraints: BoxConstraints(maxWidth: 300.0),
//             padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
//             child: Text(
//               model.text,
//               style: TextStyle(fontSize: 18.0, height: 1.3),
//             ),
//           ),
//         ),
//       );
//     }
//     return InkWell(
//       onLongPress: () {
//         return showDialog(
//             context: context,
//             builder: (context) => AlertDialog(
//                   backgroundColor: HexColor('#212F3D'),
//                   actions: [
//                     Align(
//                       child: Row(
//                         children: [
//                           Icon(
//                             Icons.delete,
//                             color: Colors.grey,
//                           ),
//                           SizedBox(
//                             width: 15.0,
//                           ),
//                           InkWell(
//                             onTap: () {
//                               SocialCubit.get(context).deleteForEveryone(
//                                   messageId: model.messageId,
//                                   receiverId: model.recieverId);
//                             },
//                             child: Text(
//                               'Delete For Every One',
//                               style: TextStyle(
//                                   color: Colors.white, fontSize: 20.0),
//                             ),
//                           ),
//                         ],
//                       ),
//                       alignment: AlignmentDirectional.topStart,
//                     ),
//                     Align(
//                       child: Row(
//                         children: [
//                           Icon(
//                             Icons.delete,
//                             color: Colors.grey,
//                           ),
//                           SizedBox(
//                             width: 15.0,
//                           ),
//                           InkWell(
//                             onTap: () {
//                               SocialCubit.get(context).deleteForMe(
//                                   messageId: model.messageId,
//                                   receiverId: model.recieverId);
//                             },
//                             child: Text(
//                               'Delete For me',
//                               style: TextStyle(
//                                   color: Colors.white, fontSize: 20.0),
//                             ),
//                           ),
//                         ],
//                       ),
//                       alignment: AlignmentDirectional.topStart,
//                     ),
//                   ],
//                 ));
//       },
//       child: userState == CreateChatImageLoadingState
//           ? Align(
//               alignment: AlignmentDirectional.centerStart,
//               child: Container(
//                 height: 230.0,
//                 width: 300.0,
//                 decoration: BoxDecoration(
//                   color: Colors.amber,
//                   borderRadius: BorderRadius.circular(20.0),
//                 ),
//                 child: CircularProgressIndicator(
//                   color: HexColor('#212F3D'),
//                 ),
//               ),
//             )
//           : Align(
//               alignment: AlignmentDirectional.centerEnd,
//               child: FullScreenWidget(
//                 backgroundColor: HexColor('#17202A'),
//                 child: ClipRRect(
//                   child: Container(
//                     height: 230.0,
//                     width: 300.0,
//                     decoration: BoxDecoration(
//                       color: Colors.amber,
//                       borderRadius: BorderRadius.circular(20.0),
//                       image: DecorationImage(
//                           image: NetworkImage('${model.imageChat}'),
//                           fit: BoxFit.cover),
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//     );
//   }
//
//   Widget chatImageFriend(ChatModel model) => Align(
//         alignment: AlignmentDirectional.centerStart,
//         child: Container(
//           height: 230.0,
//           width: 300.0,
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(20.0),
//             image: DecorationImage(
//                 image: NetworkImage('${model.imageChat}'), fit: BoxFit.cover),
//           ),
//         ),
//       );
//
//   Widget chatImageMe(ChatModel model) => Align(
//         alignment: AlignmentDirectional.centerEnd,
//         child: Container(
//           height: 230.0,
//           width: 300.0,
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(20.0),
//             image: DecorationImage(
//                 image: NetworkImage('${model.imageChat}'), fit: BoxFit.cover),
//           ),
//         ),
//       );
// }
var userState;

class ChatsDetails extends StatelessWidget {
  var userUid;
  var username;
  var userimage;
  final ScrollController controller = ScrollController();
  var uuid = Uuid();

  ChatsDetails({this.userUid, this.username, this.userimage});

  var chatController = TextEditingController();
  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (BuildContext context) {
      SocialCubit.get(context).getMessage(recieverId: userUid);
      SocialCubit.get(context).getUser(userUid);
      SocialUserModel user = SocialCubit.get(context).user;
      // SocialCubit.get(context).scrollDown(controller);

      return BlocConsumer<SocialCubit, SocialStates>(
        listener: (context, state) {
          userState = state;
        },
        builder: (context, state) {
          SocialUserModel user = SocialCubit.get(context).user;
          WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
            scrollDown();
          });
          return Scaffold(
            backgroundColor: HexColor('#212F3D'),
            appBar: AppBar(
              systemOverlayStyle: SystemUiOverlayStyle(
                statusBarColor: HexColor('#17202A'),
              ),
              backgroundColor: HexColor('#17202A'),
              leading: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: IconButton(
                  color: Colors.white,
                  icon: Icon(
                    Icons.arrow_back,
                    size: 28.0,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
              title: Center(
                child: Text(
                  '$username',
                  style: TextStyle(fontSize: 20.0, color: Colors.white),
                ),
              ),
              actions: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: CircleAvatar(
                    backgroundColor: Colors.amber,
                    backgroundImage: NetworkImage('$userimage'),
                  ),
                )
              ],
            ),
            body: ConditionalBuilder(
                condition: SocialCubit.get(context).chats.length > 0,
                builder: (context) => Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Form(
                        key: formKey,
                        child: Column(
                          children: [
                            Expanded(
                              child: SingleChildScrollView(
                                physics: BouncingScrollPhysics(),
                                controller: controller,
                                child: Column(
                                  children: [
                                    ListView.separated(
                                        physics: NeverScrollableScrollPhysics(),
                                        shrinkWrap: true,
                                        reverse: true,
                                        // controller: controller,

                                        itemBuilder: (context, index) {
                                          var chats = SocialCubit.get(context)
                                              .chats[index];
                                          if (SocialCubit.get(context)
                                                  .userModel
                                                  .uId ==
                                              chats.senderId) {
                                            return chatMe(chats, context);
                                          }
                                          return chatFriend(chats, context);
                                        },
                                        separatorBuilder: (context, index) =>
                                            SizedBox(
                                              height: 20.0,
                                            ),
                                        itemCount: SocialCubit.get(context)
                                            .chats
                                            .length),
                                  ],
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
                                    controller: chatController,
                                    minLines: 1,
                                    maxLines: 2,
                                    style: TextStyle(color: Colors.white),
                                    keyboardType: TextInputType.multiline,
                                    textInputAction: TextInputAction.newline,
                                    validator: (String value) {
                                      if (value.isEmpty) {
                                        return 'chat text must not be empty';
                                      } else {
                                        return null;
                                      }
                                    },
                                    decoration: InputDecoration(
                                      suffixIcon: IconButton(
                                        color: Colors.amber,
                                        icon: Icon(IconBroken.Image),
                                        onPressed: () {
                                          SocialCubit.get(context).getChatImage(
                                              messageuId: uuid.v4(),
                                              text: chatController.text,
                                              dateTime:
                                                  DateTime.now().toString(),
                                              recieverId: userUid);
                                          // if (SocialCubit.get(context)
                                          //         .chatImageUrl !=
                                          //     '')
                                          //   SocialCubit.get(context)
                                          //       .sendAppNotification(
                                          //           content:
                                          //               ' send a picture to you',
                                          //           contentId: userUid,
                                          //           contentKey: 'chat',
                                          //           reseverId: userUid,
                                          //           reseverName: username);
                                          if (SocialCubit.get(context)
                                                  .chatImageUrl !=
                                              '')
                                            SocialCubit.get(context)
                                                .sendNotification(
                                                    token: user.token,
                                                    senderName:
                                                        SocialCubit.get(
                                                                context)
                                                            .userModel
                                                            .name,
                                                    messageText:
                                                        '${SocialCubit.get(context).userModel.name}' +
                                                            ' send a picture to you',
                                                    messageImage:
                                                        SocialCubit.get(context)
                                                            .chatImageUrl);
                                          SocialCubit.get(context)
                                              .setRecentMessage(
                                            reciverId: userUid,
                                            reciverImage: userimage,
                                            reciverName: username,
                                            recentMessageImage:
                                                SocialCubit.get(context)
                                                    .chatImageUrl,
                                            time: DateFormat('hh:mm a')
                                                .format(DateTime.now())
                                                .toString(),
                                          );
                                          SocialCubit.get(context)
                                              .chatImageUrl = '';
                                        },
                                      ),
                                      fillColor: Colors.grey.withOpacity(0.3),
                                      filled: true,
                                      focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color:
                                                  Colors.grey.withOpacity(0.3)),
                                          borderRadius:
                                              BorderRadius.circular(50.0)),
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              horizontal: 25.0, vertical: 5.0),
                                      hintText: 'Write a message...',
                                      hintStyle:
                                          TextStyle(color: Colors.grey[500]),
                                      border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(50.0),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 10.0,
                                ),
                                CircleAvatar(
                                  backgroundColor: Colors.amber,
                                  radius: 20.0,
                                  child: IconButton(
                                    onPressed: () {
                                      if (chatController != null) if (formKey
                                          .currentState
                                          .validate()) {
                                        SocialCubit.get(context).sendMessage(
                                          messageuId: uuid.v4(),
                                          text: chatController.text,
                                          dateTime: DateTime.now().toString(),
                                          recieverId: userUid,
                                        );
                                        // SocialCubit.get(context)
                                        //     .sendAppNotification(
                                        //         content:
                                        //             ' send a message to you',
                                        //         contentId: userUid,
                                        //         contentKey: 'chat',
                                        //         reseverId: userUid,
                                        //         reseverName: username);

                                        SocialCubit.get(context)
                                            .sendNotification(
                                          token: user.token,
                                          senderName: SocialCubit.get(context)
                                              .userModel
                                              .name,
                                          messageText: chatController.text,
                                        );
                                        SocialCubit.get(context)
                                            .setRecentMessage(
                                          reciverId: userUid,
                                          reciverImage: userimage,
                                          reciverName: username,
                                          recentMessageText:
                                              chatController.text,
                                          time: DateFormat('hh:mm a')
                                              .format(DateTime.now())
                                              .toString(),
                                        );
                                        chatController.text = '';
                                      }
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
                          ],
                        ),
                      ),
                    ),
                fallback: (context) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20.0),
                                  color: Colors.amber),
                              child: Padding(
                                padding: const EdgeInsets.all(25.0),
                                child: Text(
                                  'No messages here yet...',
                                  style: TextStyle(
                                      fontSize: 25.0,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                  controller: chatController,
                                  minLines: 1,
                                  maxLines: 2,
                                  style: TextStyle(color: Colors.white),
                                  keyboardType: TextInputType.multiline,
                                  textInputAction: TextInputAction.newline,
                                  validator: (String value) {
                                    if (value.isEmpty) {
                                      return 'chat text must not be empty';
                                    } else {
                                      return null;
                                    }
                                  },
                                  decoration: InputDecoration(
                                    fillColor: Colors.grey.withOpacity(0.3),
                                    filled: true,
                                    focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color:
                                                Colors.grey.withOpacity(0.3)),
                                        borderRadius:
                                            BorderRadius.circular(50.0)),
                                    contentPadding: const EdgeInsets.symmetric(
                                        horizontal: 25.0, vertical: 5.0),
                                    hintText: 'Write a message...',
                                    hintStyle:
                                        TextStyle(color: Colors.grey[500]),
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
                                  SocialCubit.get(context).sendMessage(
                                    messageuId: uuid.v4(),
                                    text: chatController.text,
                                    dateTime: DateTime.now().toString(),
                                    recieverId: userUid,
                                    // imageChat:
                                    //     SocialCubit.get(context).chatImageUrl
                                  );
                                  // SocialCubit.get(context).sendAppNotification(
                                  //     content: ' send a message to you',
                                  //     contentId: userUid,
                                  //     contentKey: 'chat',
                                  //     reseverId: userUid,
                                  //     reseverName: username);

                                  SocialCubit.get(context).sendNotification(
                                    token: user.token,
                                    senderName:
                                        SocialCubit.get(context).userModel.name,
                                    messageText: chatController.text,
                                  );
                                  SocialCubit.get(context).setRecentMessage(
                                    reciverId: userUid,
                                    reciverImage: userimage,
                                    reciverName: username,
                                    recentMessageText: chatController.text,
                                    time: DateFormat('hh:mm a')
                                        .format(DateTime.now())
                                        .toString(),
                                  );
                                  chatController.text = '';
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
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                    ],
                  );
                }),
          );
        },
      );
    });
  }

  void scrollDown() async {
    await Future.delayed(Duration(
      microseconds: 0,
    ));
    controller.jumpTo(
      controller.position.maxScrollExtent,
    );
  }

  Widget chatFriend(ChatModel model, context) {
    if (model.imageChat == '') {
      return Align(
        alignment: AlignmentDirectional.centerStart,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadiusDirectional.only(
              bottomEnd: Radius.circular(15.0),
              topEnd: Radius.circular(15.0),
              topStart: Radius.circular(15.0),
            ),
          ),
          constraints: BoxConstraints(maxWidth: 300.0),
          padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
          child: Text(
            model.text,
            style: TextStyle(fontSize: 18.0, height: 1.3),
          ),
        ),
      );
    }
    return userState == CreateChatImageLoadingState
        ? Align(
            alignment: AlignmentDirectional.centerStart,
            child: Container(
              height: 230.0,
              width: 300.0,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: CircularProgressIndicator(
                color: HexColor('#212F3D'),
              ),
            ),
          )
        : Align(
            alignment: AlignmentDirectional.centerStart,
            child: FullScreenWidget(
              backgroundColor: HexColor('#17202A'),
              child: ClipRRect(
                child: Container(
                  height: 230.0,
                  width: 300.0,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20.0),
                    image: DecorationImage(
                        image: NetworkImage('${model.imageChat}'),
                        fit: BoxFit.cover),
                  ),
                ),
              ),
            ),
          );
  }

  Widget chatMe(ChatModel model, context) {
    if (model.imageChat == '') {
      return InkWell(
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
                                Navigator.of(context, rootNavigator: true)
                                    .pop();
                                SocialCubit.get(context).deleteForEveryone(
                                    messageId: model.messageId,
                                    receiverId: model.recieverId);
                              },
                              child: Text(
                                'Delete For Every One',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 20.0),
                              ),
                            ),
                          ],
                        ),
                        alignment: AlignmentDirectional.topStart,
                      ),
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
                                Navigator.of(context, rootNavigator: true)
                                    .pop();
                                SocialCubit.get(context).deleteForMe(
                                    messageId: model.messageId,
                                    receiverId: model.recieverId);
                              },
                              child: Text(
                                'Delete For me',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 20.0),
                              ),
                            ),
                          ],
                        ),
                        alignment: AlignmentDirectional.topStart,
                      ),
                    ],
                  ));
        },
        child: Align(
          alignment: AlignmentDirectional.centerEnd,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.amber,
              borderRadius: BorderRadiusDirectional.only(
                bottomStart: Radius.circular(15.0),
                topEnd: Radius.circular(15.0),
                topStart: Radius.circular(15.0),
              ),
            ),
            constraints: BoxConstraints(maxWidth: 300.0),
            padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
            child: Text(
              model.text,
              style: TextStyle(fontSize: 18.0, height: 1.3),
            ),
          ),
        ),
      );
    }
    return InkWell(
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
                              SocialCubit.get(context).deleteForEveryone(
                                  messageId: model.messageId,
                                  receiverId: model.recieverId);
                            },
                            child: Text(
                              'Delete For Every One',
                              style: TextStyle(
                                  color: Colors.white, fontSize: 20.0),
                            ),
                          ),
                        ],
                      ),
                      alignment: AlignmentDirectional.topStart,
                    ),
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
                              SocialCubit.get(context).deleteForMe(
                                  messageId: model.messageId,
                                  receiverId: model.recieverId);
                            },
                            child: Text(
                              'Delete For me',
                              style: TextStyle(
                                  color: Colors.white, fontSize: 20.0),
                            ),
                          ),
                        ],
                      ),
                      alignment: AlignmentDirectional.topStart,
                    ),
                  ],
                ));
      },
      child: userState == CreateChatImageLoadingState
          ? Align(
              alignment: AlignmentDirectional.centerStart,
              child: Container(
                height: 230.0,
                width: 300.0,
                decoration: BoxDecoration(
                  color: Colors.amber,
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: CircularProgressIndicator(
                  color: HexColor('#212F3D'),
                ),
              ),
            )
          : Align(
              alignment: AlignmentDirectional.centerEnd,
              child: FullScreenWidget(
                backgroundColor: HexColor('#17202A'),
                child: ClipRRect(
                  child: Container(
                    height: 230.0,
                    width: 300.0,
                    decoration: BoxDecoration(
                      color: Colors.amber,
                      borderRadius: BorderRadius.circular(20.0),
                      image: DecorationImage(
                          image: NetworkImage('${model.imageChat}'),
                          fit: BoxFit.cover),
                    ),
                  ),
                ),
              ),
            ),
    );
  }

  Widget chatImageFriend(ChatModel model) => Align(
        alignment: AlignmentDirectional.centerStart,
        child: Container(
          height: 230.0,
          width: 300.0,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.0),
            image: DecorationImage(
                image: NetworkImage('${model.imageChat}'), fit: BoxFit.cover),
          ),
        ),
      );

  Widget chatImageMe(ChatModel model) => Align(
        alignment: AlignmentDirectional.centerEnd,
        child: Container(
          height: 230.0,
          width: 300.0,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.0),
            image: DecorationImage(
                image: NetworkImage('${model.imageChat}'), fit: BoxFit.cover),
          ),
        ),
      );
}
