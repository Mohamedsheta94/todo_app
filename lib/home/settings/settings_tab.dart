import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:todo_application/my_theme.dart';
import 'package:todo_application/provider/app_config_provider.dart';

import 'change_language.dart';
import 'change_theme.dart';

class SettingsTab extends StatefulWidget {
  @override
  State<SettingsTab> createState() => _SettingsTabState();
}

class _SettingsTabState extends State<SettingsTab> {
  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<AppConfigProvider>(context);
    return Padding(
      padding: const EdgeInsets.all(30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(AppLocalizations.of(context)!.language,
              style: provider.appTheme == ThemeMode.dark
                  ? Theme.of(context)
                      .textTheme
                      .titleLarge!
                      .copyWith(color: MyTheme.whiteColor)
                  : Theme.of(context).textTheme.titleLarge),
          InkWell(
            onTap: () {
              showChangeLanguage();
            },
            child: Container(
              margin: EdgeInsets.symmetric(
                vertical: MediaQuery.of(context).size.height * 0.04,
                horizontal: MediaQuery.of(context).size.height * 0.01,
              ),
              padding: EdgeInsets.symmetric(
                vertical: MediaQuery.of(context).size.height * 0.01,
                horizontal: MediaQuery.of(context).size.height * 0.01,
              ),
              decoration: BoxDecoration(
                  border: Border.all(width: 1, color: Color(0xff5D9CEC))),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    provider.appLanguage == "en"
                        ? AppLocalizations.of(context)!.english
                        : AppLocalizations.of(context)!.arabic,
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  Icon(
                    Icons.arrow_drop_down,
                    color: MyTheme.primaryColor,
                  )
                ],
              ),
            ),
          ),
          Text(AppLocalizations.of(context)!.theme,
              style: provider.appTheme == ThemeMode.dark
                  ? Theme.of(context)
                      .textTheme
                      .titleLarge!
                      .copyWith(color: MyTheme.whiteColor)
                  : Theme.of(context).textTheme.titleLarge),
          InkWell(
            onTap: () {
              showChangeTheme();
            },
            child: Container(
              margin: EdgeInsets.symmetric(
                vertical: MediaQuery.of(context).size.height * 0.04,
                horizontal: MediaQuery.of(context).size.height * 0.01,
              ),
              padding: EdgeInsets.symmetric(
                vertical: MediaQuery.of(context).size.height * 0.01,
                horizontal: MediaQuery.of(context).size.height * 0.01,
              ),
              decoration: BoxDecoration(
                  border: Border.all(width: 1, color: Color(0xff5D9CEC))),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    provider.appTheme == ThemeMode.dark
                        ? AppLocalizations.of(context)!.dark
                        : AppLocalizations.of(context)!.light,
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  Icon(
                    Icons.arrow_drop_down,
                    color: MyTheme.primaryColor,
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void showChangeLanguage() {
    showModalBottomSheet(
        context: context, builder: (context) => ScreenChangeLanguage());
  }

  void showChangeTheme() {
    showModalBottomSheet(
        context: context, builder: (context) => ScreenChangeTheme());
  }
}
