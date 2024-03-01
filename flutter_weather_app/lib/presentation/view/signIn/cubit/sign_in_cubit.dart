import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../data/local_services/cache_services.dart';
import '../../../../domain/app_data.dart';

part 'sign_in_state.dart';

class SignInCubit extends Cubit<SignInState> {
  SignInCubit() : super(SignInInitial());

  bool observeText = true;
  final email = TextEditingController();
  final password = TextEditingController();

  void toggle() {
    observeText = !observeText;
    emit(SignInRefreshState());
  }

  signIn() async {
    emit(SignInLoadingState());
    try {
      await CacheService.getInstance();
      final res = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email.text, password: password.text);
      User? user = res.user;
      if (user != null) {
        // User signed in successfully
        String? idToken = await user.getIdToken();
        AppData.accessToken = idToken!;

        CacheService.setAccessToken(AppData.accessToken);
      }

      emit(SignInSuccessState());
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        emit(SignInErrorState('No user found for that email.'));
      } else if (e.code == 'wrong-password') {
        emit(SignInErrorState('Wrong password provided for that user.'));
      } else {
        emit(SignInErrorState(e.message.toString()));
      }
    } catch (e) {
      print(e.toString());
    }
  }
}
