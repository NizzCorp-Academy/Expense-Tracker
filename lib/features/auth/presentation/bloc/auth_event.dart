abstract class AuthEvent {}

class SignInEvent extends AuthEvent {
  final String email;
  final String password;

  SignInEvent(this.email, this.password);
}

class SignOutEvent extends AuthEvent {}

class CheckAuthStatusEvent extends AuthEvent {}

class GoogleSignInEvent extends AuthEvent {}

class SignUpEvent extends AuthEvent {
  final String name;
  final String email;
  final String password;

  SignUpEvent(this.name, this.email, this.password);
}