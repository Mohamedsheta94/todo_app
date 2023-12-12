import 'package:todo_application/firebase_utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_application/dialog_utils.dart';
import 'package:todo_application/model/my_user.dart';
import 'package:todo_application/provider/auth_provider.dart';
import '../../home/home_page.dart';

class RegisterScreenViewModal extends ChangeNotifier {
  void register(
      String email, String password, String name, BuildContext context) async {
    DialogUtils.showLoading(context, "Loading");
    try {
      final credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      MyUser myUser =
          MyUser(id: credential.user?.uid ?? "", name: name, email: email);
      var authProvider = Provider.of<AuthProvider>(context, listen: false);
      authProvider.updateUser(myUser);
      FirebaseUtils.addUserToFireStore(myUser);
      DialogUtils.hideLoading(context);
      DialogUtils.showMessage(context, "Register Successfully",
          posActionName: "ok", posAction: () {
        Navigator.pushReplacementNamed(context, HomePage.routeName);
      });
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
        DialogUtils.hideLoading(context);
        DialogUtils.showMessage(context, 'The password provided is too weak.',
            title: "Error", posActionName: "ok", posAction: () {
          Navigator.pushReplacementNamed(context, HomePage.routeName);
        });
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
        DialogUtils.hideLoading(context);
        DialogUtils.showMessage(
            context, 'The account already exists for that email.',
            title: "Error", posActionName: "ok");
      }
    } catch (e) {
      DialogUtils.hideLoading(context);
      DialogUtils.showMessage(context, e.toString(),
          title: "Error", posActionName: "ok");
      print(e);
    }
  }
}
