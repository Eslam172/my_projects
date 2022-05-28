import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:first_app/layout/social_app/cubit/social_state.dart';
import 'package:first_app/models/social_app/chat_model.dart';
import 'package:first_app/models/social_app/comment_model.dart';
import 'package:first_app/models/social_app/notification_model.dart';
import 'package:first_app/models/social_app/post_model.dart';
import 'package:first_app/models/social_app/recent_message.dart';
import 'package:first_app/models/social_app/social_user_model.dart';
import 'package:first_app/modules/social_app/chats/chats_screen.dart';
import 'package:first_app/modules/social_app/feeds/feeds_sreen.dart';
import 'package:first_app/modules/social_app/post/post_screen.dart';
import 'package:first_app/modules/social_app/settings/settings_screen.dart';
import 'package:first_app/modules/social_app/users/user_screen.dart';
import 'package:first_app/shared/Network/remote/dio_helper.dart';
import 'package:first_app/shared/components/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

import '../../../modules/social_app/notification/notification_screen.dart';
import '../../../modules/social_app/start_screen/start_screen.dart';
import '../../../shared/Network/local/cache_helper.dart';
import '../../../shared/components/components.dart';
import '../../../shared/style/icon_broken.dart';

class SocialCubit extends Cubit<SocialStates> {
  SocialCubit() : super(SocialInitialState());

  static SocialCubit get(context) => BlocProvider.of(context);
  SocialUserModel userModel;

  void getUserData() {
    uId = CacheHelper.getData(key: 'uId');
    FirebaseFirestore.instance.collection('users').doc(uId).get().then((value) {
      // print(value.data());
      userModel = SocialUserModel.fromJson(value.data());
      getUserToken();
      // print(userModel.uId);
      // print(userModel.image);
      emit(SocialGetUserSuccessState());
    }).catchError((error) {
      print(error.toString());
      emit(SocialGetUserErrorState(error.toString()));
    });
  }

  List<Widget> screens = [
    FeedsScreen(),
    ChatsScreen(),
    // PostScreen(),
    UsersScreen(),
    NotificationScreen(),
    SettingsScreen(),
  ];
  List<String> titles = [
    'Home',
    'Chats',
    // 'Post',
    'Users',
    'Settings',
  ];
  int currentIndex = 0;

  void changeBottomNav(int index) {
    if (index == 1) getRecentMessage(myUid: userModel.uId);
    // getFriends(userModel.uId);
    if (index == 0) {
      if (posts.length == 0) {
        getPosts();
        getComment();
      }
      getUserData();
    }
    if (index == 3) getNotification();
    currentIndex = index;
    emit(SocialChangeBottomNavStateState());
  }

  File profileImage;
  var picker = ImagePicker();

  Future<void> getProfileImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      profileImage = File(pickedFile.path);
      // print(profileImage.path);
      emit(SocialProfileImageSuccess());
    } else {
      print('No image selected.');
      emit(SocialProfileImageError());
    }
  }

  File coverImage;

  Future<void> getCoverImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      coverImage = File(pickedFile.path);
      emit(SocialCoverImageSuccess());
    } else {
      print('No image selected.');
      emit(SocialCoverImageError());
    }
  }

  void uploadProfileImage({
    @required String name,
    @required String phone,
    @required String bio,
  }) {
    emit(SocialUserUpdateImageLoadingState());
    firebase_storage.FirebaseStorage.instance
        .ref()
        .child('users/${Uri.file(profileImage.path).pathSegments.last}')
        .putFile(profileImage)
        .then((value) {
      value.ref.getDownloadURL().then((value) {
        print(value);
        // emit(SocialUploadProfileImageSuccess());
        updateUser(
          name: name,
          phone: phone,
          bio: bio,
          image: value,
        );
        emit(SocialUploadProfileImageSuccess());
      }).catchError((error) {
        emit(SocialUploadProfileImageError());
      });
    }).catchError((error) {
      emit(SocialUploadProfileImageError());
    });
  }

  void uploadCoverImage({
    @required String name,
    @required String phone,
    @required String bio,
  }) {
    emit(SocialUserUpdateCoverLoadingState());
    firebase_storage.FirebaseStorage.instance
        .ref()
        .child('users/${Uri.file(coverImage.path).pathSegments.last}')
        .putFile(coverImage)
        .then((value) {
      value.ref.getDownloadURL().then((value) {
        print(value);
        updateUser(name: name, phone: phone, bio: bio, cover: value);
        // emit(SocialUploadCoverImageSuccess());
      }).catchError((error) {
        emit(SocialUploadCoverImageError());
      });
    }).catchError((error) {
      emit(SocialUploadCoverImageError());
    });
  }

  void updateUser({
    @required String name,
    @required String phone,
    @required String bio,
    String cover,
    String image,
  }) {
    emit(SocialUserUpdateLoadingState());
    SocialUserModel model = SocialUserModel(
      name: name,
      phone: phone,
      cover: cover ?? userModel.cover,
      bio: bio,
      image: image ?? userModel.image,
      isEmailVerified: false,
      uId: userModel.uId,
      email: userModel.email,
    );
    FirebaseFirestore.instance
        .collection('users')
        .doc(userModel.uId)
        .update(model.toMap())
        .then((value) {
      getUserData();
      updatePost();
      updateComment();
    }).catchError((error) {
      emit(SocialUpdateErrorState());
    });
  }

  void updatePost() {
    FirebaseFirestore.instance.collection('posts').snapshots().listen((event) {
      event.docs.forEach((element) {
        if (element.data()['uId'] == userModel.uId) {
          element.reference.update({
            'name': userModel.name,
            'image': userModel.image,
          });
        }
      });
      emit(SocialUpdatePostSuccessState());
    });
  }

  void updateComment() {
    FirebaseFirestore.instance.collection('posts').snapshots().listen((event) {
      event.docs.forEach((element) async {
        await element.reference
            .collection('comments')
            .snapshots()
            .listen((event) {
          event.docs.forEach((element) {
            if (element.data()['uId'] == userModel.uId)
              element.reference
                  .update({'name': userModel.name, 'image': userModel.image});
          });
        });
      });
    });
  }

  File postImage;

  Future<void> getPostImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      postImage = File(pickedFile.path);
      emit(SocialPostImageSuccess());
    } else {
      print('No image selected.');
      emit(SocialPostImageError());
    }
  }

  void uploadPostImage(
      {@required String text, @required String dateTime, @required context}) {
    emit(CreatePostLoadingState());
    firebase_storage.FirebaseStorage.instance
        .ref()
        .child('posts/${Uri.file(postImage.path).pathSegments.last}')
        .putFile(postImage)
        .then((value) {
      value.ref.getDownloadURL().then((value) {
        emit(CreatePostSuccessState());
        createPost(
          text: text,
          dateTime: dateTime,
          imagePost: value,
          context: context,
        );
        removePostImage();
        Navigator.pop(context);
      }).catchError((error) {
        emit(CreatePostErrorState());
      });
    }).catchError((error) {
      emit(CreatePostErrorState());
    });
  }

  PostModel postModel;

  void createPost(
      {@required String text,
      @required String dateTime,
      @required context,
      String imagePost}) {
    emit(CreatePostLoadingState());
    PostModel postModel = PostModel(
      image: userModel.image,
      name: userModel.name,
      uId: userModel.uId,
      text: text,
      dateTime: dateTime,
      imagePost: imagePost ?? '',
      like: 0,
      comment: 0,
    );
    FirebaseFirestore.instance
        .collection('posts')
        .add(postModel.toMap())
        .then((value) {
      // posts = [];
      // getPosts();
      emit(CreatePostSuccessState());
      comments = [];
      getComment();
    }).catchError((error) {
      emit(CreatePostErrorState());
    });
  }

  void removePostImage() {
    postImage = null;
    emit(SocialRemovePostImage());
  }

  List<PostModel> posts = [];
  List<String> postId = [];
  List<int> likes = [];

  void getPosts() {
    FirebaseFirestore.instance
        .collection('posts')
        .orderBy('dateTime', descending: true)
        .snapshots()
        .listen((event) async {
      posts = [];
      event.docs.forEach((element) async {
        posts.add(PostModel.fromJson(element.data()));
        postModel = PostModel.fromJson(element.data());
        postId.add(element.id);
        var likes = await element.reference.collection('likes').get();
        var comments = await element.reference.collection('comments').get();
        await FirebaseFirestore.instance
            .collection('posts')
            .doc(element.id)
            .update({
          'like': likes.docs.length,
          'comment': comments.docs.length,
          'postId': element.id
        });
      });
      // print(isLike);
      // getComment();
      emit(SocialGetPostsSuccessState());
    });
  }

  bool isLikedByMe;
  Future<bool> likedByMe({String postId, PostModel postModel, context}) async {
    emit(LikedByMeCheckedLoadingState());
    isLikedByMe = false;
    FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .get()
        .then((event) async {
      var likes = await event.reference.collection('likes').get();
      likes.docs.forEach((element) {
        if (element.id == userModel.uId) {
          isLikedByMe = true;
          dislikePost(postId);
        }
      });
      if (isLikedByMe == false) likePost(postId, postModel, context);
      print(isLikedByMe);
      emit(LikedByMeCheckedSuccessState());
    });
    return isLikedByMe;
  }

  // void isLikePost(String postId) {
  //   FirebaseFirestore.instance
  //       .collection('posts')
  //       .doc(postId)
  //       .collection('likes')
  //       .get()
  //       .then((value) {
  //     value.docs.forEach((element) {
  //       if (element.id == userModel.uId) {
  //         isLike = true;
  //       } else {
  //         isLike = false;
  //       }
  //       return isLike;
  //     });
  //   });
  // }

  void likePost(String postId, PostModel postModel, context) {
    // isLike = false;
    FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .collection('likes')
        .doc(userModel.uId)
        .set({'like': true}).then((value) {
      // isLike = true;
      getPosts();
      if (postModel.uId != userModel.uId) {
        SocialCubit.get(context).sendAppNotification(
            reseverName: postModel.name,
            content: 'likes a post you shared',
            reseverId: postModel.uId,
            postId: postId,
            contentId: postModel.postId,
            contentKey: 'likePost');
        SocialCubit.get(context).sendNotification(
          token: userModel.token,
          senderName: SocialCubit.get(context).userModel.name,
          messageText: '${SocialCubit.get(context).userModel.name} ' +
              ' likes a post you shared',
        );
      }
      emit(SocialLikePostSuccessState());
    }).catchError((error) {
      emit(SocialLikePostErrorState(error.toString()));
    });
  }

  void dislikePost(String postId) {
    // isLike = true;
    FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .collection('likes')
        .doc(userModel.uId)
        .delete()
        .then((value) {
      // isLike = false;
      getPosts();
      emit(SocialDisLikePostSuccessState());
    }).catchError((error) {
      emit(SocialLikePostErrorState(error.toString()));
    });
  }

  CommentModel comment;
  List<CommentModel> comments = [];

  void getComment({
    String postId,
  }) {
    // comments = [];
    emit(SocialGetCommentLoadingState());
    FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .collection('comments')
        .snapshots()
        .listen((event) {
      comments.clear();
      event.docs.forEach((element) {
        comments.add(CommentModel.fromJson(element.data()));
        // getPosts();
        emit(SocialGetCommentSuccessState());
      });
    });
  }

  void addComment({String postId, String comment, String imageComment}) {
    FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .collection('comments')
        .doc()
        .set({
      'image': userModel.image,
      'name': userModel.name,
      'textComment': comment,
      'imageComment': imageComment ?? '',
      'uId': userModel.uId,
    }).then((value) {
      emit(SocialCommentPostSuccessState());
      getComment(postId: postId);
      getPosts();
      getSinglePost(postId);
    }).catchError((error) {
      emit(SocialCommentPostErrorState(error.toString()));
    });
  }

  List<SocialUserModel> users = [];

  void getAllUser() {
    emit(SocialGetAllUserLoadingState());
    if (users.length == 0)
      FirebaseFirestore.instance.collection('users').get().then((value) {
        value.docs.forEach((element) {
          if (element.data()['uId'] != userModel.uId)
            users.add(SocialUserModel.fromJson(element.data()));
          emit(SocialGetAllUserSuccessState());
        });
      }).catchError((error) {
        emit(SocialGetAllUserErrorState());
      });
  }

  void sendMessage({
    @required String text,
    @required String dateTime,
    @required String recieverId,
    @required String messageuId,
    String imageChat,
  }) {
    ChatModel model = ChatModel(
        senderId: userModel.uId,
        text: text,
        dateTime: dateTime,
        recieverId: recieverId,
        imageChat: imageChat ?? '',
        messageId: messageuId);
    FirebaseFirestore.instance
        .collection('users')
        .doc(userModel.uId)
        .collection('chats')
        .doc(recieverId)
        .collection('message')
        .add(model.toMap())
        .then((value) {
      emit(SocialSendMessageSuccessState());
      if (chatImage != null) {
        chatImage = null;
        // chatImageUrl = null;
        emit(RemoveImageChatState());
      }
      print('image Chate is $imageChat');
    }).catchError((error) {
      emit(SocialSendMessageErrorState());
    });
    FirebaseFirestore.instance
        .collection('users')
        .doc(recieverId)
        .collection('chats')
        .doc(userModel.uId)
        .collection('message')
        .add(model.toMap())
        .then((value) {
      emit(SocialSendMessageSuccessState());
    }).catchError((error) {
      emit(SocialSendMessageErrorState());
    });
  }

  List<ChatModel> chats = [];

  void getMessage({@required String recieverId}) {
    FirebaseFirestore.instance
        .collection('users')
        .doc(userModel.uId)
        .collection('chats')
        .doc(recieverId)
        .collection('message')
        .orderBy('dateTime', descending: true)
        .snapshots()
        .listen((event) {
      chats = [];
      event.docs.forEach((element) {
        chats.add(ChatModel.fromJson(element.data()));
      });
      emit(SocialGetMessageSuccessState());
    });
  }

  File chatImage;

  String chatImageUrl = '';
  var chatPicker = ImagePicker();

  Future<void> getChatImage({
    @required String text,
    @required String dateTime,
    @required String recieverId,
    @required String messageuId,
    String imageChat,
  }) async {
    final pickedFile = await chatPicker.getImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      chatImage = File(pickedFile.path);
      // print(chatImage.path);
      emit(SocialChatImageSuccess());
      uploadChatImage(
          text: text,
          dateTime: dateTime,
          recieverId: recieverId,
          imageChat: imageChat,
          messageuId: messageuId);
    } else {
      print('No image selected.');
      emit(SocialChatImageError());
    }
  }

  void uploadChatImage({
    @required String text,
    @required String dateTime,
    @required String recieverId,
    @required String messageuId,
    String imageChat,
  }) {
    emit(CreateChatImageLoadingState());
    firebase_storage.FirebaseStorage.instance
        .ref()
        .child('chats/${Uri.file(chatImage.path).pathSegments.last}')
        .putFile(chatImage)
        .then((value) {
      value.ref.getDownloadURL().then((value) {
        // emit(CreateChatImageSuccessState());
        chatImageUrl = value;
        sendMessage(
            text: text,
            dateTime: dateTime,
            recieverId: recieverId,
            imageChat: value,
            messageuId: messageuId);
        print(imageChat);
      }).catchError((error) {
        emit(CreateChatImageErrorState());
      });
    }).catchError((error) {
      emit(CreateChatImageErrorState());
    });
  }

  void setRecentMessage({
    @required String reciverId,
    @required String reciverName,
    @required String reciverImage,
    String recentMessageImage,
    String recentMessageText,
    @required String time,
  }) {
    RecentMessagesModel reciverRecentMessage = RecentMessagesModel(
      read: false,
      senderId: userModel.uId,
      senderName: userModel.name,
      receiverId: reciverId,
      receiverName: reciverName,
      senderProfilePic: userModel.image,
      receiverProfilePic: reciverImage,
      recentMessageImage: recentMessageImage,
      recentMessageText: recentMessageText,
      dateTime: FieldValue.serverTimestamp(),
      time: time,
    );
    RecentMessagesModel senderRecentMessage = RecentMessagesModel(
      read: true,
      senderId: userModel.uId,
      senderName: userModel.name,
      receiverId: reciverId,
      receiverName: reciverName,
      senderProfilePic: userModel.image,
      receiverProfilePic: reciverImage,
      recentMessageImage: recentMessageImage,
      recentMessageText: recentMessageText,
      dateTime: FieldValue.serverTimestamp(),
      time: time,
    );
    FirebaseFirestore.instance
        .collection('users')
        .doc(userModel.uId)
        .collection('recentMessage')
        .doc(reciverId)
        .set(senderRecentMessage.toMap())
        .then((value) {
      emit(SetSenderRecentMessageSuccess());
    }).catchError((error) {
      emit(SetSenderRecentMessageError());
    });
    FirebaseFirestore.instance
        .collection('users')
        .doc(reciverId)
        .collection('recentMessage')
        .doc(userModel.uId)
        .set(reciverRecentMessage.toMap())
        .then((value) {
      emit(SetReciverRecentMessageSuccess());
    }).catchError((error) {
      emit(SetReciverRecentMessageError());
    });
  }

  List<RecentMessagesModel> recentMessages = [];

  void getRecentMessage({myUid}) {
    FirebaseFirestore.instance
        .collection('users')
        .doc(myUid)
        .collection('recentMessage')
        .orderBy('dateTime', descending: true)
        .snapshots()
        .listen((event) {
      recentMessages = [];
      event.docs.forEach((element) {
        recentMessages.add(RecentMessagesModel.fromJson(element.data()));
      });
      emit(GetRecentMessageSuccess());
    });
  }

  void readRecentMessage({@required String recentMessageId}) {
    FirebaseFirestore.instance
        .collection('users')
        .doc(userModel.uId)
        .collection('recentMessage')
        .doc(recentMessageId)
        .update({'read': true}).then((value) {
      emit(ReadRecentMessage());
    });
  }

  int unReadRecentMessageCount = 0;

  Future<int> unReadRecentMessage(myUid) async {
    FirebaseFirestore.instance
        .collection('users')
        .doc(myUid)
        .collection('recentMessage')
        .snapshots()
        .listen((event) {
      unReadRecentMessageCount = 0;
      for (int i = 0; i < event.docs.length; i++) {
        if (event.docs[i]['read'] == false) unReadRecentMessageCount++;
      }
      emit(UnReadRecentMessage());
    });
    return unReadRecentMessageCount;
  }

  void signOut(context) {
    FirebaseAuth.instance.signOut().then((value) async {
      friends = [];
      userPosts = [];
      users = [];
      friendRequests = [];
      postId = [];
      posts = [];
      likes = [];
      comments = [];
      chats = [];
      uId = '';
      CacheHelper.removeData(key: 'uId');
      await FirebaseMessaging.instance.deleteToken();
      await FirebaseFirestore.instance.collection('users').get().then((value) {
        value.docs.forEach((element) {
          if (element.id == userModel.uId)
            element.reference.update({'token': null});
        });
      });
      navigateAndFinish(context, StartScreen());

      currentIndex = 0;
      emit(SignOut());
    }).catchError((error) {
      emit(SignOutError());
    });
    // CacheHelper.removeData(key: 'uId').then((value) {
    //   if (value) {
    //     navigateAndFinish(context, StartScreen());
    //     emit(SignOut());
    //   }
    // }
    // );
  }

  void scrollDown(ScrollController controller) {
    controller.jumpTo(controller.position.maxScrollExtent);
  }

  List<SocialUserModel> searchUserModel;
  Map<String, dynamic> search;

  void searchUser(String searchText) {
    emit(SocialSearchUserLoadingState());
    FirebaseFirestore.instance
        .collection('users')
        .where('name', isEqualTo: searchText)
        .get()
        .then((value) {
      // value.docs.forEach((element) {
      //   if (element.data()['uId'] != userModel.uId)
      //     searchUserModel.add(SocialUserModel.fromJson(element.data()));
      //   search = value.docs[0].data();
      //   emit(SocialSearchUserSuccessState());
      // });
      search = value.docs[0].data();
      emit(SocialSearchUserSuccessState());
      // searchUserModel = SocialUserModel.fromJson(value.da)
    }).catchError((error) {
      emit(SocialSearchUserErrorState());
    });
  }

  SocialUserModel friendsProfile;

  void getFriendsProfile(String friendsUid) {
    emit(GetFriendProfileLoadingState());
    FirebaseFirestore.instance.collection('users').snapshots().listen((value) {
      value.docs.forEach((element) {
        if (element.data()['uId'] == friendsUid)
          friendsProfile = SocialUserModel.fromJson(element.data());
      });
      emit(GetFriendProfileSuccessState());
    });
  }

  void deletePost(String postId, String userPostId) {
    if (userModel.uId == userPostId) {
      FirebaseFirestore.instance
          .collection('posts')
          .doc(postId)
          .delete()
          .then((value) {
        showToast(text: 'Post Deleted', state: ToastStates.SUCCESS);
        emit(DeletePostSuccessState());
      });
    } else {
      showToast(text: 'You do not have permission', state: ToastStates.ERROR);
    }
  }

  void addFriendTohim(
      {@required String friendsUid,
      @required String friendName,
      @required bool verify,
      @required String phone,
      @required String cover,
      @required String bio,
      @required String email,
      @required String token,
      @required String friendImage}) {
    emit(AddFriendLoadingState());
    SocialUserModel myFriendModel = SocialUserModel(
        image: friendImage,
        name: friendName,
        uId: friendsUid,
        phone: phone,
        isEmailVerified: verify,
        email: email,
        cover: cover,
        token: token,
        bio: bio);
    SocialUserModel myModel = SocialUserModel(
        uId: userModel.uId,
        name: userModel.name,
        image: userModel.image,
        phone: userModel.phone,
        email: userModel.email,
        cover: userModel.cover,
        bio: userModel.bio,
        token: userModel.token,
        isEmailVerified: userModel.isEmailVerified);
    FirebaseFirestore.instance
        .collection('users')
        .doc(userModel.uId)
        .collection('friends')
        .doc(friendsUid)
        .set(myFriendModel.toMap())
        .then((value) {
      emit(AddFriendSuccessState());
    }).catchError((error) {
      print(error.toString());
      emit(AddFriendErrorState());
    });
    // FirebaseFirestore.instance
    //     .collection('users')
    //     .doc(friendsUid)
    //     .collection('friends')
    //     .doc(userModel.uId)
    //     .set(myModel.toMap())
    //     .then((value) {
    //   emit(AddFriendSuccessState());
    // }).catchError((error) {
    //   print(error.toString());
    //   emit(AddFriendErrorState());
    // });
  }

  void addFriendToMe(
      {@required String friendsUid,
      @required String friendName,
      @required bool verify,
      @required String phone,
      @required String cover,
      @required String bio,
      @required String token,
      @required String email,
      @required String friendImage}) {
    emit(AddFriendLoadingState());
    SocialUserModel myFriendModel = SocialUserModel(
      image: friendImage,
      name: friendName,
      uId: friendsUid,
      phone: phone,
      isEmailVerified: verify,
      email: email,
      cover: cover,
      bio: bio,
      token: token,
    );
    SocialUserModel myModel = SocialUserModel(
        uId: userModel.uId,
        name: userModel.name,
        image: userModel.image,
        phone: userModel.phone,
        email: userModel.email,
        cover: userModel.cover,
        bio: userModel.bio,
        token: userModel.token,
        isEmailVerified: userModel.isEmailVerified);
    FirebaseFirestore.instance
        .collection('users')
        .doc(userModel.uId)
        .collection('friends')
        .doc(friendsUid)
        .set(myFriendModel.toMap())
        .then((value) {
      emit(AddFriendSuccessState());
    }).catchError((error) {
      print(error.toString());
      emit(AddFriendErrorState());
    });
    // FirebaseFirestore.instance
    //     .collection('users')
    //     .doc(friendsUid)
    //     .collection('friends')
    //     .doc(userModel.uId)
    //     .set(myModel.toMap())
    //     .then((value) {
    //   emit(AddFriendSuccessState());
    // }).catchError((error) {
    //   print(error.toString());
    //   emit(AddFriendErrorState());
    // });
  }

  List<SocialUserModel> friends = [];

  void getFriends(String userUid) {
    emit(GetFriendLoadingState());
    FirebaseFirestore.instance
        .collection('users')
        .doc(userUid)
        .collection('friends')
        .snapshots()
        .listen((value) {
      friends = [];
      value.docs.forEach((element) {
        friends.add(SocialUserModel.fromJson(element.data()));
      });
      emit(GetFriendSuccessState());
    });
  }

  bool isFriend = false;

  bool checkFriends(String friendUid) {
    FirebaseFirestore.instance
        .collection('users')
        .doc(userModel.uId)
        .collection('friends')
        .snapshots()
        .listen((value) {
      isFriend = false;
      value.docs.forEach((element) {
        if (friendUid == element.id) isFriend = true;
      });
      emit(CheckFriendState());
    });
    return isFriend;
  }

  void unFriend(String friendsUid) {
    emit(UnFriendLoadingState());
    FirebaseFirestore.instance
        .collection('users')
        .doc(userModel.uId)
        .collection('friends')
        .doc(friendsUid)
        .delete()
        .then((value) {
      emit(UnFriendSuccessState());
    }).catchError((error) {
      emit(UnFriendErrorState());
      print(error.toString());
    });
    FirebaseFirestore.instance
        .collection('users')
        .doc(friendsUid)
        .collection('friends')
        .doc(userModel.uId)
        .delete()
        .then((value) {
      emit(UnFriendSuccessState());
    }).catchError((error) {
      emit(UnFriendErrorState());
      print(error.toString());
    });
  }

  void sendFriendRequest(
      {@required String friendsUid,
      @required String friendName,
      @required String friendImage}) {
    emit(FriendRequestLoadingState());
    SocialUserModel friendRequestModel = SocialUserModel(
        uId: userModel.uId,
        name: userModel.name,
        image: userModel.image,
        bio: userModel.bio,
        cover: userModel.cover,
        email: userModel.email,
        token: userModel.token,
        isEmailVerified: userModel.isEmailVerified,
        phone: userModel.phone);
    FirebaseFirestore.instance
        .collection('users')
        .doc(friendsUid)
        .collection('friendRequests')
        .doc(userModel.uId)
        .set(friendRequestModel.toMap())
        .then((value) {
      emit(FriendRequestSuccessState());
    }).catchError((error) {
      print(error.toString());
      emit(FriendRequestErrorState());
    });
  }

  List<SocialUserModel> friendRequests = [];

  void getFriendRequest() {
    emit(GetFriendLoadingState());
    FirebaseFirestore.instance
        .collection('users')
        .doc(userModel.uId)
        .collection('friendRequests')
        .snapshots()
        .listen((value) {
      friendRequests = [];
      value.docs.forEach((element) {
        friendRequests.add(SocialUserModel.fromJson(element.data()));
        emit(GetFriendSuccessState());
      });
    });
  }

  bool request = false;

  bool checkFriendRequest(String friendUid) {
    FirebaseFirestore.instance
        .collection('users')
        .doc(friendUid)
        .collection('friendRequests')
        .get()
        .then((value) {
      value.docs.forEach((element) {
        if (element.data()['uId'] == userModel.uId)
          request = true;
        else
          request = false;
      });
      emit(CheckFriendRequestState());
    });
    return request;
  }

  void deleteFriendRequest(String friendsUid) {
    emit(DeleteFriendRequestLoadingState());
    FirebaseFirestore.instance
        .collection('users')
        .doc(userModel.uId)
        .collection('friendRequests')
        .doc(friendsUid)
        .delete()
        .then((value) {
      emit(DeleteFriendRequestSuccessState());
    }).catchError((error) {
      emit(DeleteFriendRequestErrorState());
      print(error.toString());
    });
  }

  List<PostModel> userPosts = [];

  void getUserPosts(String userId) {
    FirebaseFirestore.instance
        .collection('posts')
        .orderBy('dateTime')
        .snapshots()
        .listen((event) {
      userPosts = [];
      event.docs.forEach((element) {
        if (element.data()['uId'] == userId) {
          userPosts.add(PostModel.fromJson(element.data()));
        }
      });
      emit(GetUserPostSuccessState());
    });
  }

  void deleteAccount(context) async {
    await FirebaseAuth.instance.currentUser.delete().then((value) async {
      await FirebaseFirestore.instance.collection('users').doc(uId).delete();
      CacheHelper.removeData(key: 'uId');
      await FirebaseMessaging.instance.deleteToken();
      showToast(
          text: 'The account has been deleted successfully',
          state: ToastStates.SUCCESS);
      navigateAndFinish(context, StartScreen());
      emit(DeleteAccount());
    }).catchError((error) {
      emit(DeleteAccountError());
    });
  }

  void getUserToken() async {
    emit(GetTokenLoadingState());
    var token = await FirebaseMessaging.instance.getToken();
    print('my token is $token');
    await FirebaseFirestore.instance
        .collection('users')
        .doc(userModel.uId)
        .update({'token': token}).then((value) {
      emit(GetTokenSuccessState());
    });
  }

  void sendNotification(
      {@required String token,
      @required String senderName,
      String messageText,
      String messageImage}) {
    DioHelper.postSocialData(data: {
      "to": "$token",
      "notification": {
        "title": "$senderName",
        "body":
            "${messageText != null ? messageText : messageImage != null ? messageImage : 'ERROR 404'}",
        "sound": "default"
      },
      "android": {
        "Priority": "HIGH",
        "notification": {
          "notification_Priority": "PRIORITY_MAX",
          "sound": "default",
          "default_sound": true,
          "default_vibrate_timings": true,
          "default_light_settings": true
        }
      },
      "data": {
        "type": "order",
        "id": "87",
        "click_action": "FLUTTER_NOTIFICATION_CLICK",
        "navigation": "chatDetails"
      }
    });
    emit(SendNotificationSuccessState());
  }

  void sendAppNotification({
    String content,
    String contentId,
    String contentKey,
    String notificationId,
    String reseverId,
    String postId,
    String reseverName,
  }) {
    emit(SendAppNotificationLoadingState());
    NotificationModel notificationModel = NotificationModel(
        content: content,
        contentId: contentId,
        contentKey: contentKey,
        notificationId: notificationId,
        reseverid: reseverId,
        reseverName: reseverName,
        postid: postId,
        senderId: userModel.uId,
        senderName: userModel.name,
        senderProfile: userModel.image,
        serverTimeStamp: FieldValue.serverTimestamp(),
        read: false,
        dateTime: Timestamp.now());
    FirebaseFirestore.instance
        .collection('users')
        .doc(reseverId)
        .collection('notification')
        .add(notificationModel.toMap())
        .then((value) async {
      await setNotificationId();
      emit(SendAppNotificationSuccessState());
    }).catchError((error) {
      emit(SendAppNotificationErrorState());
    });
  }

  void setNotificationId() async {
    await FirebaseFirestore.instance.collection('users').get().then((value) {
      value.docs.forEach((element) async {
        var notifications =
            await element.reference.collection('notification').get();
        notifications.docs.forEach((notificationsElement) async {
          await notificationsElement.reference
              .update({'notificationId': notificationsElement.id});
        });
      });
      emit(SetNotificationIdSuccessState());
    });
  }

  List<NotificationModel> notificationModel = [];

  void getNotification() {
    emit(GetNotificationIdLoadingState());
    FirebaseFirestore.instance
        .collection('users')
        .doc(userModel.uId)
        .collection('notification')
        .orderBy('serverTimeStamp', descending: true)
        .snapshots()
        .listen((event) {
      notificationModel = [];
      event.docs.forEach((element) {
        if (element.data()['reseverid'] == userModel.uId) {
          if (element.data()['senderId'] != userModel.uId)
            notificationModel.add(NotificationModel.fromjson(element.data()));
        }
      });
      emit(GetNotificationIdSuccessState());
    });
  }

  int unReadNotificationsCount = 0;

  Future<int> getUnReadNotificationsCount(String uId) async {
    FirebaseFirestore.instance
        .collection('users')
        .doc(uId)
        .collection('notification')
        .snapshots()
        .listen((event) {
      unReadNotificationsCount = 0;
      for (int i = 0; i < event.docs.length; i++) {
        if (event.docs[i]['read'] == false) unReadNotificationsCount++;
      }
      emit(UnReadNotificationSuccessState());
      print("UnRead: " + '$unReadNotificationsCount');
    });

    return unReadNotificationsCount;
  }

  Future readNotification(String notificationId) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(userModel.uId)
        .collection('notification')
        .doc(notificationId)
        .update({'read': true}).then((value) {
      emit(ReadNotificationSuccessState());
    });
  }

  void deleteNotification(String notificationId) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(userModel.uId)
        .collection('notification')
        .doc(notificationId)
        .delete()
        .then((value) {
      emit(DeleteNotificationSuccessState());
    });
  }

  String notificationContent(String contentKey) {
    if (contentKey == 'likePost')
      return 'likePost';
    else if (contentKey == 'commentPost')
      return 'commentPost';
    else if (contentKey == 'friendRequest')
      return 'friendRequest';
    else if (contentKey == 'friendRequestAccepted')
      return 'friendRequestAccepted';
    else if (contentKey == 'chat')
      return 'chat';
    else
      return 'friendRequestNotify';
  }

  IconData notificationContentIcon(String contentKey) {
    if (contentKey == 'likePost')
      return IconBroken.Heart;
    else if (contentKey == 'commentPost')
      return IconBroken.Chat;
    else if (contentKey == 'friendRequestAccepted')
      return Icons.person;
    else if (contentKey == 'chat')
      return Icons.person;
    else
      return Icons.person;
  }

  SocialUserModel user;

  void getUser(String uid) {
    emit(UserLoadingState());
    FirebaseFirestore.instance.collection('users').doc(uid).get().then((value) {
      user = SocialUserModel.fromJson(value.data());
      emit(UserSuccessState());
    }).catchError((error) {
      emit(UserErrorState());
    });
  }

  PostModel singlePost;

  void getSinglePost(String postId) async {
    emit(GetPostLoadingState());
    await FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .get()
        .then((value) async {
      singlePost = PostModel.fromJson(value.data());
      emit(GetSinglePostSuccessState());
    }).catchError((error) {
      emit(GetPostErrorState());
    });
  }

  void deleteForEveryone(
      {@required String messageId, @required String receiverId}) async {
    var myDocument = await FirebaseFirestore.instance
        .collection('users')
        .doc(userModel.uId)
        .collection('chats')
        .doc(receiverId)
        .collection('message')
        .limit(1)
        .where('messageId', isEqualTo: messageId)
        .get();
    myDocument.docs[0].reference.delete();

    var hisDocument = await FirebaseFirestore.instance
        .collection('users')
        .doc(receiverId)
        .collection('chats')
        .doc(userModel.uId)
        .collection('message')
        .limit(1)
        .where('messageId', isEqualTo: messageId)
        .get();
    hisDocument.docs[0].reference.delete().then((value) {
      emit(deleteForeveryOneSuccess());
    });
  }

  void deleteForMe(
      {@required String messageId, @required String receiverId}) async {
    var myDocument = await FirebaseFirestore.instance
        .collection('users')
        .doc(userModel.uId)
        .collection('chats')
        .doc(receiverId)
        .collection('message')
        .limit(1)
        .where('messageId', isEqualTo: messageId)
        .get();
    myDocument.docs[0].reference.delete().then((value) {
      emit(deleteForMeSuccess());
    });
  }
}
