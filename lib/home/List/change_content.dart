import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:todo_application/dialog_utils.dart';
import 'package:todo_application/firebase_utils.dart';
import 'package:todo_application/model/tasks.dart';
import 'package:todo_application/provider/app_config_provider.dart';
import 'package:todo_application/provider/auth_provider.dart';

import '../../my_theme.dart';

class ChangeContent extends StatefulWidget {
  static const String routeName = "change_content";

  @override
  State<ChangeContent> createState() => _ChangeContentState();
}

class _ChangeContentState extends State<ChangeContent> {
  var formKey = GlobalKey<FormState>();
  late AppConfigProvider provider;
  var titleController = TextEditingController();
  var descController = TextEditingController();
  DateTime? selectedDate = DateTime.now();
  String? id;
  Tasks? args;

  @override
  Widget build(BuildContext context) {
    provider = Provider.of<AppConfigProvider>(context);
    if (args == null) {
      args = ModalRoute.of(context)!.settings.arguments as Tasks;
      titleController.text = args!.title!;
      descController.text = args!.description!;
      selectedDate = args!.dateTime!;
    }
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(
          "To Do List",
          style: Theme.of(context)
              .textTheme
              .titleLarge!
              .copyWith(color: MyTheme.whiteColor),
        ),
      ),
      body: Container(
        alignment: AlignmentDirectional.center,
        margin: EdgeInsets.symmetric(
          vertical: MediaQuery.of(context).size.height * 0.08,
          horizontal: MediaQuery.of(context).size.height * 0.05,
        ),
        decoration: BoxDecoration(
            color: provider.appTheme == ThemeMode.dark
                ? MyTheme.blackColorDark
                : MyTheme.whiteColor,
            borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            children: [
              Text(
                AppLocalizations.of(context)!.edit_task,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              Form(
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: TextFormField(
                          controller: titleController,
                          validator: (value) {
                            if (value!.isEmpty || value == null) {
                              return "please enter your title";
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                              errorStyle: TextStyle(fontSize: 10),
                              hintText:
                                  AppLocalizations.of(context)!.this_is_title,
                              hintStyle: Theme.of(context).textTheme.bodyLarge,
                              border: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                color: MyTheme.grayColor,
                              ))),
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: TextFormField(
                          controller: descController,
                          validator: (value) {
                            if (value!.isEmpty || value == null) {
                              return "please enter your details";
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                              errorStyle: TextStyle(fontSize: 10),
                              hintText:
                                  AppLocalizations.of(context)!.task_details,
                              hintStyle: Theme.of(context).textTheme.bodyLarge,
                              border: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                color: MyTheme.grayColor,
                              ))),
                          style: Theme.of(context).textTheme.titleLarge,
                          maxLines: 4,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: Text(
                          AppLocalizations.of(context)!.select_date,
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          showCalendar();
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Text(
                            "${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}",
                            style: Theme.of(context).textTheme.headlineLarge,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: MediaQuery.of(context).size.height * 0.07,
                            horizontal:
                                MediaQuery.of(context).size.width * 0.03),
                        child: ElevatedButton(
                          onPressed: () {
                            changeDataTask();
                          },
                          child: Text(
                            AppLocalizations.of(context)!.save_changes,
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge!
                                .copyWith(color: Colors.white30),
                          ),
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Theme.of(context).primaryColor,
                              padding: EdgeInsets.symmetric(
                                vertical:
                                    MediaQuery.of(context).size.height * 0.02,
                              ),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30))),
                        ),
                      ),
                    ],
                  )),
            ],
          ),
        ),
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

  void changeDataTask() {
    args!.title = titleController.text;
    args!.description = descController.text;
    args!.dateTime = selectedDate;
    var authprovider = Provider.of<AuthProvider>(context, listen: false);
    DialogUtils.showLoading(context, "Waiting...");
    FirebaseUtils.updateTask(args!, authprovider.currentUser!.id ?? "")
        .then((value) {
      DialogUtils.hideLoading(context);
    }).timeout(Duration(milliseconds: 500), onTimeout: () {
      provider.getAllTasksFromFireStore(authprovider.currentUser!.id ?? "");
      Navigator.pop(context);
    });
  }
}
