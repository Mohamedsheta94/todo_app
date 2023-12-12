import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_application/auth/login/login_navigator.dart';
import 'package:todo_application/firebase_utils.dart';
import 'package:todo_application/provider/auth_provider.dart';

class LoginScreenViewModal extends ChangeNotifier {
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var formState = GlobalKey<FormState>();

  late LoginNavigator navigator;

  void login(BuildContext context) async {
    if (formState.currentState!.validate() == true) {
      navigator.showMyLoading();
      try {
        final credential =
            await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text,
        );
        var user = await FirebaseUtils.readUserFromFireStore(
            credential.user?.uid ?? "");
        if (user == null) {
          return;
        }
        var authProvider = Provider.of<AuthProvider>(context, listen: false);

        authProvider.updateUser(user);

        navigator.hideMyLoading();

        navigator.showMyMessage("Login Successfully");

        print(credential.user?.uid);
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          navigator.hideMyLoading();
          navigator.showMyMessageError('No user found for that email.');
          print('No user found for that email.');
        } else if (e.code == 'wrong-password') {
          navigator.hideMyLoading();

          navigator
              .showMyMessageError('Wrong password provided for that user.');
          print('Wrong password provided for that user.');
        }
      } catch (e) {
        navigator.hideMyLoading();
        navigator.showMyMessageError(e.toString());
        print(e);
      }
    }
  }
}
