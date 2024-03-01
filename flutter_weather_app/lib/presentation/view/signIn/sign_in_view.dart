import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_weather_app/config/extenstions/imagePaths.dart';

import '../../../config/app_route.dart';
import '../../theme/theme_config.dart';
import '../../widget/c_button.dart';
import '../../widget/c_text_field.dart';
import 'cubit/sign_in_cubit.dart';

class SignInScreen extends StatelessWidget {
  SignInScreen({super.key});

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    SignInCubit cubit = context.watch<SignInCubit>();
    return BlocConsumer<SignInCubit, SignInState>(
      listener: (BuildContext context, SignInState state) {
        if (state is SignInSuccessState) {
          Navigator.pushNamedAndRemoveUntil(
              context, AppRoute.homeRoute, (route) => false);
        }
      },
      builder: (context, state) {
        return Scaffold(
            appBar: AppBar(),
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      PTextField(
                        controller: cubit.email,
                        textCapitalization: TextCapitalization.none,
                        textInputAction: TextInputAction.next,
                        prefixIcon: const Icon(Icons.email),
                        hint: ThemeConfig.strings.email,
                        validator: (value) {
                          if (value!.isEmpty) {
                            // return ThemeConfig.strings.basicErrorMsg;
                          }
                          // if (!Validator.isValidEmail(value)) {
                          //   return ThemeConfig.strings.emailErrorMsg;
                          // }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      PTextField(
                        controller: cubit.password,
                        observeText: cubit.observeText,
                        suffixIcon: InkWell(
                          onTap: () {
                            cubit.toggle();
                          },
                          splashColor: Colors.transparent,
                          child: Icon(
                            cubit.observeText
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: ThemeConfig.colors.textFormFieldColor,
                          ),
                        ),
                        textInputAction: TextInputAction.next,
                        prefixIcon: const Icon(Icons.lock),
                        hint: ThemeConfig.strings.password,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return ThemeConfig.strings.basicErrorMsg;
                          }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Align(
                          alignment: Alignment.topRight,
                          child: GestureDetector(
                              onTap: () {
                                // Navigator.pushNamed(
                                //     context, AppRoute.forgetPassword,
                                //     arguments: "forgetPassword");
                              },
                              child: Text(
                                "Forgotten password?",
                                style: ThemeConfig.dimens.width > 500
                                    ? ThemeConfig.styles.style10
                                    : ThemeConfig.styles.style14,
                              ))),
                      const SizedBox(
                        height: 10,
                      ),
                      SizedBox(
                          width: ThemeConfig.dimens.width,
                          height: ThemeConfig.dimens.width > 500 ? 80 : 45,
                          child: CButton(
                              title: state is SignInLoadingState
                                  ? Center(
                                      child: CircularProgressIndicator(
                                      strokeAlign: 0.2,
                                      color: ThemeConfig.colors.whiteColor,
                                    ))
                                  : Text(
                                      ThemeConfig.strings.signIn,
                                      style: ThemeConfig.styles.style14
                                          .copyWith(
                                              color: ThemeConfig
                                                  .colors.whiteColor),
                                    ),
                              onTap: () {
                                if (_formKey.currentState!.validate()) {
                                  cubit.signIn();
                                }
                              },
                              color: ThemeConfig.colors.appColor,
                              titleStyle: ThemeConfig.styles.style16.copyWith(
                                  color: ThemeConfig.colors.whiteColor))),
                      SizedBox(
                        height: ThemeConfig.dimens.width > 500 ? 50 : 30,
                      ),

                      const SizedBox(
                        height: 30,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            bottomNavigationBar: Wrap(
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                  child: Center(
                    child: RichText(
                      text: TextSpan(
                          text: ThemeConfig.strings.haveNotAccount,
                          style: ThemeConfig.dimens.width > 500
                              ? ThemeConfig.styles.style12
                                  .copyWith(fontWeight: FontWeight.w600)
                              : ThemeConfig.styles.style14
                                  .copyWith(fontWeight: FontWeight.w600),
                          children: <TextSpan>[
                            TextSpan(
                                text: ThemeConfig.strings.signUp,
                                style: ThemeConfig.dimens.width > 500
                                    ? ThemeConfig.styles.style09
                                    : ThemeConfig.styles.style12,
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    Navigator.of(context).pushReplacementNamed(
                                        AppRoute.signUpRoute);
                                    // navigate to desired screen
                                  })
                          ]),
                    ),
                  ),
                ),
              ],
            ));
      },
    );
  }
}
