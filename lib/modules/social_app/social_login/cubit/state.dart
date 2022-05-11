abstract class SocialLoginStates {}

class SocialLoginInitialStates extends SocialLoginStates {}

class SocialLoginSuccessStates extends SocialLoginStates {
  final String uId;

  SocialLoginSuccessStates(this.uId);
}

class SocialLoginLoadingStates extends SocialLoginStates {}

class SocialChangePasswordVisibilityStates extends SocialLoginStates {}

class SocialLoginErrorStates extends SocialLoginStates {
  final String error;
  SocialLoginErrorStates(this.error);
}
