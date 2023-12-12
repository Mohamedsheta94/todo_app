import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:todo_application/auth/login/login.dart';
import 'package:todo_application/home/List/add_bottom_sheet.dart';
import 'package:todo_application/home/List/list_tab.dart';
import 'package:todo_application/home/settings/settings_tab.dart';
import 'package:todo_application/my_theme.dart';
import 'package:todo_application/provider/auth_provider.dart';

class HomePage extends StatefulWidget {
  static const String routeName = "Home";

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    // var provider = Provider.of<AppConfigProvider>(context);
    var authProvider = Provider.of<AuthProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          selectedIndex == 0
              ? "To Do List ${authProvider.currentUser!.name}"
              : AppLocalizations.of(context)!.settings,
          style: Theme.of(context)
              .textTheme
              .titleLarge!
              .copyWith(color: MyTheme.whiteColor),
        ),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.pushReplacementNamed(context, LoginScreen.routeName);
              },
              icon: Icon(Icons.exit_to_app))
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        notchMargin: 10,
        child: BottomNavigationBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          currentIndex: selectedIndex,
          onTap: (index) {
            selectedIndex = index;
            setState(() {});
          },
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.list),
              label: AppLocalizations.of(context)!.list,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: AppLocalizations.of(context)!.settings,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showAddBottomSheet();
        },
        child: Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      body: tabs[selectedIndex],
    );
  }

  List<Widget> tabs = [ListTab(), SettingsTab()];

  void showAddBottomSheet() {
    showModalBottomSheet(
        context: context, builder: (context) => AddBottomSheet());
  }
}
