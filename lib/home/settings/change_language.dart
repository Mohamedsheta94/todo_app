import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:todo_application/my_theme.dart';
import 'package:todo_application/provider/app_config_provider.dart';

class ScreenChangeLanguage extends StatefulWidget {
  @override
  State<ScreenChangeLanguage> createState() => _ScreenChangeLanguageState();
}

class _ScreenChangeLanguageState extends State<ScreenChangeLanguage> {
  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<AppConfigProvider>(context);
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          InkWell(
              onTap: () {
                provider.changeLanguage("en");
              },
              child: provider.appLanguage == "en"
                  ? getSelectedItem(AppLocalizations.of(context)!.english)
                  : getUnSelectedItem(AppLocalizations.of(context)!.english)),
          InkWell(
              onTap: () {
                provider.changeLanguage("ar");
              },
              child: provider.appLanguage == "ar"
                  ? getSelectedItem(AppLocalizations.of(context)!.arabic)
                  : getUnSelectedItem(AppLocalizations.of(context)!.arabic)),
        ],
      ),
    );
  }

  Widget getSelectedItem(String text) {
    return Container(
      margin: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width * 0.02,
          vertical: MediaQuery.of(context).size.height * 0.02),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(text,
              style: Theme.of(context)
                  .textTheme
                  .titleSmall!
                  .copyWith(color: MyTheme.primaryColor)),
          Icon(
            Icons.check,
            color: MyTheme.primaryColor,
          )
        ],
      ),
    );
  }

  Widget getUnSelectedItem(String text) {
    return Container(
        margin: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width * 0.02,
            vertical: MediaQuery.of(context).size.height * 0.02),
        child: Text(
          text,
          style: Theme.of(context).textTheme.titleLarge!.copyWith(
                fontSize: 15,
              ),
        ));
  }
}
