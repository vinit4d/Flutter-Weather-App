part of 'sign_up_cubit.dart';

abstract class SignUpState{}

class SignUpInitial extends SignUpState{}


class SignUpRefreshState extends SignUpState{}

class SignUpLoadingState extends SignUpState{}
class SignUpSuccessState extends SignUpState{}
class SignUpErrorState extends SignUpState{
  String msg = "";

  SignUpErrorState(this.msg);

}