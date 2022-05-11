abstract class SocialStates {}

class SocialInitialState extends SocialStates {}

// GET USER
class SocialGetUserLoadingState extends SocialStates {}

class SocialGetUserSuccessState extends SocialStates {}

class SocialGetUserErrorState extends SocialStates {
  final String error;

  SocialGetUserErrorState(this.error);
}

// BOTTOM NAV BAR
class SocialChangeBottomNavStateState extends SocialStates {}

// IMAGE & COVER
class SocialProfileImageSuccess extends SocialStates {}

class SocialProfileImageError extends SocialStates {}

class SocialCoverImageSuccess extends SocialStates {}

class SocialCoverImageError extends SocialStates {}

//UPLOAD IMAGE & COVER
class SocialUploadProfileImageSuccess extends SocialStates {}

class SocialUploadProfileImageError extends SocialStates {}

class SocialUploadCoverImageSuccess extends SocialStates {}

class SocialUploadCoverImageError extends SocialStates {}

// UPDATE
class SocialUpdateErrorState extends SocialStates {}

class SocialUserUpdateLoadingState extends SocialStates {}

class SocialUserUpdateImageLoadingState extends SocialStates {}

class SocialUserUpdateCoverLoadingState extends SocialStates {}

// POST
class SocialPostState extends SocialStates {}

class CreatePostLoadingState extends SocialStates {}

class CreatePostSuccessState extends SocialStates {}

class CreatePostErrorState extends SocialStates {}

class SocialPostImageSuccess extends SocialStates {}

class SocialPostImageError extends SocialStates {}

class SocialRemovePostImage extends SocialStates {}

class SocialGetPostsLoadingState extends SocialStates {}

class SocialGetPostsSuccessState extends SocialStates {}

class GetUserPostSuccessState extends SocialStates {}

class GetPhotoPostSuccessState extends SocialStates {}

class DeletePostSuccessState extends SocialStates {}

class SocialGetPostsErrorState extends SocialStates {
  final String error;

  SocialGetPostsErrorState(this.error);
}

//Like
class SocialLikePostSuccessState extends SocialStates {}

class SocialDisLikePostSuccessState extends SocialStates {}

class SocialLikePostSuccess extends SocialStates {}

class SocialLikePostErrorState extends SocialStates {
  final String error;

  SocialLikePostErrorState(this.error);
}

// Comment
class SocialCommentPostLoadingState extends SocialStates {}

class SocialCommentPostSuccessState extends SocialStates {}

class SocialCommentPostErrorState extends SocialStates {
  final String error;

  SocialCommentPostErrorState(this.error);
}

class SocialGetCommentLoadingState extends SocialStates {}

class SocialGetCommentSuccessState extends SocialStates {}

class SocialGetCommentErrorState extends SocialStates {
  final String error;

  SocialGetCommentErrorState(this.error);
}

class SocialCommentImageSuccess extends SocialStates {}

class SocialCommentImageError extends SocialStates {}

class SocialCommentImageLoadingState extends SocialStates {}

class SocialCommentImageSuccessState extends SocialStates {}

class SocialCommentImageErrorState extends SocialStates {}

//get all user
class SocialGetAllUserLoadingState extends SocialStates {}

class SocialGetAllUserSuccessState extends SocialStates {}

class SocialGetAllUserErrorState extends SocialStates {}

// chats
class SocialSendMessageSuccessState extends SocialStates {}

class SocialSendMessageErrorState extends SocialStates {}

class SocialGetMessageSuccessState extends SocialStates {}

class SocialGetMessageErrorState extends SocialStates {}

class SocialChatImageSuccess extends SocialStates {}

class SocialChatImageError extends SocialStates {}

class CreateChatImageLoadingState extends SocialStates {}

class CreateChatImageSuccessState extends SocialStates {}

class CreateChatImageErrorState extends SocialStates {}

class RemoveImageChatState extends SocialStates {}

// Sign out
class SignOut extends SocialStates {}

class SignOutError extends SocialStates {}

// Delete Account
class DeleteAccount extends SocialStates {}

class DeleteAccountError extends SocialStates {}

// Search
class SocialSearchUserLoadingState extends SocialStates {}

class SocialSearchUserSuccessState extends SocialStates {}

class SocialSearchUserErrorState extends SocialStates {}

// FrindesProfile
class GetFriendProfileLoadingState extends SocialStates {}

class GetFriendProfileSuccessState extends SocialStates {}

class GetFriendProfileErrorState extends SocialStates {}

// Add Friend
class AddFriendLoadingState extends SocialStates {}

class AddFriendSuccessState extends SocialStates {}

class AddFriendErrorState extends SocialStates {}

class GetFriendLoadingState extends SocialStates {}

class GetFriendSuccessState extends SocialStates {}

class CheckFriendState extends SocialStates {}

class UnFriendLoadingState extends SocialStates {}

class UnFriendSuccessState extends SocialStates {}

class UnFriendErrorState extends SocialStates {}

class FriendRequestLoadingState extends SocialStates {}

class FriendRequestSuccessState extends SocialStates {}

class FriendRequestErrorState extends SocialStates {}

class CheckFriendRequestState extends SocialStates {}

class DeleteFriendRequestLoadingState extends SocialStates {}

class DeleteFriendRequestSuccessState extends SocialStates {}

class DeleteFriendRequestErrorState extends SocialStates {}

// get Token
class GetTokenLoadingState extends SocialStates {}

class GetTokenSuccessState extends SocialStates {}

// send Notification
class SendNotificationSuccessState extends SocialStates {}

class SendAppNotificationLoadingState extends SocialStates {}

class SendAppNotificationSuccessState extends SocialStates {}

class SendAppNotificationErrorState extends SocialStates {}

class SetNotificationIdSuccessState extends SocialStates {}

class GetNotificationIdSuccessState extends SocialStates {}

class GetNotificationIdLoadingState extends SocialStates {}

class ReadNotificationSuccessState extends SocialStates {}

class UnReadNotificationSuccessState extends SocialStates {}

class DeleteNotificationSuccessState extends SocialStates {}

//get user
class UserLoadingState extends SocialStates {}

class UserSuccessState extends SocialStates {}

class UserErrorState extends SocialStates {}

// get single post
class GetPostLoadingState extends SocialStates {}

class GetSinglePostSuccessState extends SocialStates {}

class GetPostErrorState extends SocialStates {}

// recentMessage
class SetSenderRecentMessageSuccess extends SocialStates {}

class SetSenderRecentMessageError extends SocialStates {}

class SetReciverRecentMessageSuccess extends SocialStates {}

class SetReciverRecentMessageError extends SocialStates {}

class GetRecentMessageSuccess extends SocialStates {}

class ReadRecentMessage extends SocialStates {}

class UnReadRecentMessage extends SocialStates {}

//delete message
class deleteForMeSuccess extends SocialStates {}

class deleteForeveryOneSuccess extends SocialStates {}
