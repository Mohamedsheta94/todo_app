import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:todo_application/dialog_utils.dart';
import 'package:todo_application/firebase_utils.dart';
import 'package:todo_application/model/tasks.dart';
import 'package:todo_application/my_theme.dart';
import 'package:todo_application/provider/app_config_provider.dart';
import 'package:todo_application/provider/auth_provider.dart';

class AddBottomSheet extends StatefulWidget {
  @override
  State<AddBottomSheet> createState() => _AddBottomSheetState();
}

class _AddBottomSheetState extends State<AddBottomSheet> {
  // String formattedDate = DateFormat('yyyy-MM-dd – kk:mm').format(selectedDate);

  DateTime selectedDate = DateTime.now();
  String title = "";
  String description = "";
  var formKey = GlobalKey<FormState>();
  late AppConfigProvider provider;

  @override
  Widget build(BuildContext context) {
    provider = Provider.of<AppConfigProvider>(context);
    return Container(
      padding: EdgeInsets.all(15),
      child: Column(
        children: [
          Text(
            AppLocalizations.of(context)!.add_new_task,
            style: Theme
                .of(context)
                .textTheme
                .bodyMedium,
          ),
          Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: TextFormField(
                      onChanged: (text) {
                        title = text;
                      },
                      validator: (value) {
                        if (value!.isEmpty || value == null) {
                          return "please enter your title";
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                          errorStyle: TextStyle(fontSize: 10),
                          hintText:
                          AppLocalizations.of(context)!.enter_your_task,
                          hintStyle: Theme
                              .of(context)
                              .textTheme
                              .bodyLarge,
                          border: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: MyTheme.grayColor,
                              ))),
                      style: Theme
                          .of(context)
                          .textTheme
                          .titleLarge,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: TextFormField(
                      onChanged: (text) {
                        description = text;
                      },
                      validator: (value) {
                        if (value!.isEmpty || value == null) {
                          return "please enter your details";
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                          errorStyle: TextStyle(fontSize: 10),
                          hintText: AppLocalizations.of(context)!
                              .enter_your_task_details,
                          hintStyle: Theme
                              .of(context)
                              .textTheme
                              .bodyLarge,
                          border: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: MyTheme.grayColor,
                              ))),
                      style: Theme
                          .of(context)
                          .textTheme
                          .titleLarge,
                      maxLines: 4,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Text(
                      AppLocalizations.of(context)!.select_date,
                      style: Theme
                          .of(context)
                          .textTheme
                          .headlineMedium,
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      showCalendar();
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Text(
                        "${selectedDate.day}/${selectedDate
                            .month}/${selectedDate.year}",
                        style: Theme
                            .of(context)
                            .textTheme
                            .headlineLarge,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  ElevatedButton(
                      onPressed: () {
                        addTask();
                      },
                      child: Text(
                        AppLocalizations.of(context)!.add,
                        style: Theme
                            .of(context)
                            .textTheme
                            .titleLarge,
                      ))
                ],
              )),
        ],
      ),
    );
  }

  void showCalendar() async {
    var chossenDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: DateTime.now().add(Duration(days: 365)));
    if (chossenDate != null) {
      selectedDate = chossenDate;
      setState(() {});
    }
  }

  void addTask() {
    if (formKey.currentState?.validate() == true) {
      Tasks tasks =
      Tasks(
          title: title,
          dateTime: selectedDate,
          description: description
      );
      var authProvider = Provider.of<AuthProvider>(context, listen: false);
      DialogUtils.showLoading(context, "Waiting...");
      FirebaseUtils.addTaskToFirebase(tasks, authProvider.currentUser?.id ?? "")
          .then((value) {
        DialogUtils.hideLoading(context);
        DialogUtils.showMessage(
            context, "Task added Successfully", posActionName: "ok",
            posAction: () {
              Navigator.of(context).pop();
            });
      })
          .timeout(
          Duration(milliseconds: 500),
          onTimeout: () {
            provider.getAllTasksFromFireStore(
                authProvider.currentUser?.id ?? "");
          }
      );
    }
  }
}
