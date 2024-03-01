part of 'sign_in_cubit.dart';

abstract class SignInState{}

class SignInInitial extends SignInState{}


class SignInRefreshState extends SignInState{}
class SignInLoadingState extends SignInState{}
class SignInSuccessState extends SignInState{}
class SignInErrorState extends SignInState{
  String msg = "";

  SignInErrorState(this.msg);

}