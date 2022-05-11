abstract class SocialRegisterStates {}

class SocialRegisterInitialStates extends SocialRegisterStates {}

class SocialRegisterSuccessStates extends SocialRegisterStates {}

class SocialRegisterLoadingStates extends SocialRegisterStates {}

class SocialChangeRegisterPasswordVisibilityStates
    extends SocialRegisterStates {}

class SocialRegisterErrorStates extends SocialRegisterStates {
  final String error;
  SocialRegisterErrorStates(this.error);
}

class SocialCreateUserErrorStates extends SocialRegisterStates {
  final String error;
  SocialCreateUserErrorStates(this.error);
}

class SocialCreateUserSuccessStates extends SocialRegisterStates {
  final String uId;

  SocialCreateUserSuccessStates(this.uId);
}
