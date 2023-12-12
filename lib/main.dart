import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_application/auth/login/login.dart';
import 'package:todo_application/auth/register/register.dart';
import 'package:todo_application/home/List/change_content.dart';
import 'package:todo_application/home/List/edit_task_screen.dart';
import 'package:todo_application/provider/app_config_provider.dart';
import 'package:todo_application/provider/auth_provider.dart';
import 'home/home_page.dart';
import 'my_theme.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  // await FirebaseFirestore.instance.disableNetwork();
  // FirebaseFirestore.instance.settings =
  //     Settings(cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED);
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (context) => AppConfigProvider()),
    ChangeNotifierProvider(create: (context) => AuthProvider()),
  ], child: MyApp()));
}

class MyApp extends StatelessWidget {
  late AppConfigProvider provider;

  @override
  Widget build(BuildContext context) {
    provider = Provider.of<AppConfigProvider>(context);
    initShared();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: RegisterScreen.routeName,
      routes: {
        HomePage.routeName: (context) => HomePage(),
        RegisterScreen.routeName: (context) => RegisterScreen(),
        LoginScreen.routeName: (context) => LoginScreen(),
        ChangeContent.routeName: (context) => ChangeContent(),
        EditTaskScreen.routeName: (context) => EditTaskScreen()
      },
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: Locale(provider.appLanguage),
      theme: MyTheme.lightMode,
      darkTheme: MyTheme.darkMode,
      themeMode: provider.appTheme,
      // darkTheme: MyTheme.darkMode,
    );
  }

  Future<void> initShared() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var language = await sharedPreferences.getString("language");
    if (language != null) {
      provider.changeLanguage(language);
    }
    var isDark = await sharedPreferences.get("isDark");
    if (isDark == "dark") {
      provider.changeTheme(ThemeMode.dark);
    } else if (isDark == "light") {
      provider.changeTheme(ThemeMode.light);
    }
  }
}