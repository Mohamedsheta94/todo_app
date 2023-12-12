import 'package:calendar_timeline/calendar_timeline.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_application/home/List/task_widget.dart';
import 'package:todo_application/my_theme.dart';
import 'package:todo_application/provider/app_config_provider.dart';
import 'package:todo_application/provider/auth_provider.dart';

class ListTab extends StatefulWidget {
  @override
  State<ListTab> createState() => _ListTabState();
}

class _ListTabState extends State<ListTab> {
  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<AppConfigProvider>(context);
    var authProvider = Provider.of<AuthProvider>(context);
    provider.getAllTasksFromFireStore(authProvider.currentUser?.id ?? "");
    return Column(
      children: [
        CalendarTimeline(
          initialDate: provider.selectDate,
          firstDate: DateTime.now(),
          lastDate: DateTime.now().add(Duration(days: 365)),
          onDateSelected: (date) {
            provider.changeDate(date, authProvider.currentUser?.id ?? "");
          },
          leftMargin: 20,
          monthColor: Colors.blueGrey,
          dayColor: Colors.teal[200],
          activeDayColor: Colors.white,
          activeBackgroundDayColor: MyTheme.primaryColor,
          dotsColor: MyTheme.whiteColor,
          locale: provider.appLanguage,
        ),
        Expanded(
          child: ListView.builder(
              itemCount: provider.tasksList.length,
              itemBuilder: (context, index) {
                return TaskWidgetItem(
                  tasks: provider.tasksList[index],
                );
              }),
        )
      ],
    );
  }
}
