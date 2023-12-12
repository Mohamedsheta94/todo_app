import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:todo_application/auth/login/login_navigator.dart';
import 'package:todo_application/auth/login/login_screen_view_modal.dart';
import 'package:todo_application/auth/register/register.dart';
import 'package:todo_application/component/custom_text_field.dart';
import 'package:todo_application/dialog_utils.dart';
import 'package:todo_application/home/home_page.dart';
import 'package:todo_application/my_theme.dart';
import 'package:todo_application/provider/app_config_provider.dart';

class LoginScreen extends StatefulWidget {
  static const String routeName = "login";

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> implements LoginNavigator {
  LoginScreenViewModal viewModal = LoginScreenViewModal();

  @override
  void initState() {
    super.initState();
    viewModal.navigator = this;
  }

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<AppConfigProvider>(context);
    return ChangeNotifierProvider(
      create: (context) => viewModal,
      child: Scaffold(
          // resizeToAvoidBottomInset: false,
          body: SingleChildScrollView(
        child: Stack(
          alignment: AlignmentDirectional.topCenter,
          children: [
            Image.asset("assets/images/main_background.png",
                width: double.infinity, fit: BoxFit.fill),
            Padding(
              padding: EdgeInsets.symmetric(
                  vertical: MediaQuery.of(context).size.height * 0.07),
              child: Text(
                AppLocalizations.of(context)!.login,
                style: TextStyle(
                  color: MyTheme.whiteColor,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                  vertical: MediaQuery.of(context).size.height * 0.4,
                  horizontal: MediaQuery.of(context).size.width * 0.07),
              child: Form(
                key: viewModal.formState,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    CustomTextFormField(
                      label: "Email Address",
                      keyboardType: TextInputType.emailAddress,
                      controller: viewModal.emailController,
                      validator: (text) {
                        if (text!.trim().isEmpty || text == null) {
                          return "please enter your email";
                        }
                        bool emailValid = RegExp(
                                r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                            .hasMatch(text);
                        if (!emailValid) {
                          return "pelese enter valid email";
                        }
                        return null;
                      },
                    ),
                    CustomTextFormField(
                      label: "Password",
                      keyboardType: TextInputType.number,
                      controller: viewModal.passwordController,
                      validator: (text) {
                        if (text!.trim().isEmpty || text == null) {
                          return "please enter your password";
                        }
                        if (text.length < 6) {
                          return "password should be at least 6 char";
                        }
                        return null;
                      },
                      isPassword: true,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: ElevatedButton(
                        onPressed: () {
                          viewModal.login(context);
                        },
                        child: Text(
                          "Login",
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                        style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(vertical: 12)),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: InkWell(
                        onTap: () {
                          Navigator.of(context)
                              .pushReplacementNamed(RegisterScreen.routeName);
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Don't have an Account",
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                              TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pushReplacementNamed(
                                        RegisterScreen.routeName);
                                  },
                                  child: Text(
                                    "Sign up",
                                    style: TextStyle(
                                      fontSize: 18,
                                    ),
                                  ))
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      )),
    );
  }

  @override
  void hideMyLoading() {
    DialogUtils.hideLoading(context);
  }

  @override
  void showMyLoading() {
    DialogUtils.showLoading(context, "Loading");
  }

  @override
  void showMyMessage(String message) {
    DialogUtils.showMessage(context, message, posActionName: "ok",
        posAction: () {
      Navigator.pushReplacementNamed(context, HomePage.routeName);
    });
  }

  @override
  void showMyMessageError(String message) {
    DialogUtils.showMessage(context, message,
        title: "Error", posActionName: "ok");
  }
}
