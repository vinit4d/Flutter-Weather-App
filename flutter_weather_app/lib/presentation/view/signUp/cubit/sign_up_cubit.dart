import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'sign_up_state.dart';

class SignUpCubit extends Cubit<SignUpState> {
  SignUpCubit() : super(SignUpInitial());

  bool observeText = true;
  bool observeText2 = true;

  final email = TextEditingController();
  final password = TextEditingController();
  final cPassword = TextEditingController();

  void toggle() {
    observeText = !observeText;
    emit(SignUpRefreshState());
  }

  void cToggle() {
    observeText2 = !observeText2;
    emit(SignUpRefreshState());
  }

  signUp() async {
    emit(SignUpLoadingState());
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email.text,
        password: cPassword.text,
      );
      emit(SignUpSuccessState());
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        emit(SignUpErrorState('The password provided is too weak.'));
      } else if (e.code == 'email-already-in-use') {
        emit(SignUpErrorState('The account already exists for that email.'));
      } else {
        emit(SignUpErrorState(e.message.toString()));
      }
    } catch (e) {
      print(e.toString());
    }
  }
}
