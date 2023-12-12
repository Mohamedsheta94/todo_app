import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_application/firebase_utils.dart';
import 'package:todo_application/model/tasks.dart';
import 'package:todo_application/my_theme.dart';

class AppConfigProvider extends ChangeNotifier {
  String appLanguage = "en";
  ThemeMode appTheme = ThemeMode.light;
  List<Tasks> tasksList = [];
  DateTime selectDate = DateTime.now();
  Tasks? currentTask;

  void updateUser(Tasks newTask) {
    currentTask = newTask;
    notifyListeners();
  }

  void getAllTasksFromFireStore(String uId) async {
    QuerySnapshot<Tasks> querySnapshot =
        await FirebaseUtils.getTasksCollection(uId).get();
    tasksList = querySnapshot.docs.map((doc) {
      return doc.data();
    }).toList();

    tasksList = tasksList.where((task) {
      if (task.dateTime?.day == selectDate.day &&
          task.dateTime?.month == selectDate.month &&
          task.dateTime?.year == selectDate.year) {
        return true;
      }
      return false;
    }).toList();
    tasksList.sort((Tasks tasks1, Tasks tasks2) {
      return tasks1.dateTime!.compareTo(tasks2.dateTime!);
    });
    notifyListeners();
  }

  void changeDate(DateTime date, String uId) {
    selectDate = date;
    getAllTasksFromFireStore(uId);
    notifyListeners();
  }

  void changeLanguage(String newLanguage) async {
    if (appLanguage == newLanguage) {
      return;
    }
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    appLanguage = newLanguage;
    sharedPreferences.setString("language", appLanguage);
    notifyListeners();
  }

  void changeTheme(ThemeMode newTheme) async {
    if (appTheme == newTheme) {
      return;
    }

    appTheme = newTheme;
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString(
        "isDark", appTheme == ThemeMode.dark ? "dark" : "light");
    notifyListeners();
  }

  bool isDarkMode() {
    return appTheme == MyTheme.darkMode;
  }
}
