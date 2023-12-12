import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_application/dialog_utils.dart';
import 'package:todo_application/firebase_utils.dart';
import 'package:todo_application/model/tasks.dart';
import 'package:todo_application/my_theme.dart';
import 'package:todo_application/provider/app_config_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:todo_application/provider/auth_provider.dart';

class EditTaskScreen extends StatefulWidget {
  static const String routeName = 'edit_task';

  @override
  State<EditTaskScreen> createState() => _EditTaskScreenState();
}

class _EditTaskScreenState extends State<EditTaskScreen> {
  DateTime selectedDate = DateTime.now();
  var titleController = TextEditingController();
  var descriptionController = TextEditingController();
  var formKey = GlobalKey<FormState>();
  late AppConfigProvider provider;
  Tasks? task;

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery
        .of(context)
        .size;
    provider = Provider.of<AppConfigProvider>(context);

    if (task == null) {
      var task = ModalRoute
          .of(context)!
          .settings
          .arguments as Tasks;
      titleController.text = task.title ?? "";
      descriptionController.text = task.description ?? "";
      selectedDate = task.dateTime!;
    }

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(
            'TO DO LIST '
        ),
      ),
      body: Column(
        children: [
          Stack(

            children: [
              Container(
                height: screenSize.height * .1,
                color: MyTheme.primaryColor,
              ),
              Center(
                child: Container(
                  height: screenSize.height * .7,
                  width: screenSize.width * .8,
                  margin: EdgeInsets.only(top: screenSize.height * 0.04),

                  decoration: BoxDecoration(
                      borderRadius: BorderRadiusDirectional.circular(20),

                      color: Colors.white
                  ),
                  padding: EdgeInsets.all(15),
                  child: Column(
                    children: [
                      Text(
                        'EDIT TASK',
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
                                      AppLocalizations.of(context)!
                                          .enter_your_task,
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
                                  controller: descriptionController,
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
                                    editTask();
                                  },
                                  child: Text(
                                    'Save Changes ',
                                    style: Theme
                                        .of(context)
                                        .textTheme
                                        .titleLarge,
                                  ))
                            ],
                          )),
                    ],
                  ),
                ),
              )
            ],
          )
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

  void editTask() {
    if (formKey.currentState?.validate() == true) {
      task!.title = titleController.text;
      task!.description = descriptionController.text;
      task!.dateTime = selectedDate;

      var authProvider = Provider.of<AuthProvider>(context, listen: false);
      DialogUtils.showLoading(context, "Waiting...");

      FirebaseUtils.editTask(task!, authProvider.currentUser?.id ?? "").then((
          value) {
        DialogUtils.hideLoading(context);
        DialogUtils.showMessage(
            context, "Task edited Successfully", posActionName: "ok",
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
