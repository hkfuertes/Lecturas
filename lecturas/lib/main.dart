import 'package:flutter/services.dart';
import 'package:lecturas/Model/Settings.dart';
import 'package:provider/provider.dart';

import 'Model/Rosary.dart';
import 'Screens/mainScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'Util.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Settings settings = Settings();
  await settings.retrieveConfig();
  settings.rosary = await Rosary.getFromAsset(
      "assets/rosary.json", "assets/rosary.skeleton.es.html");
  runApp(ChangeNotifierProvider(create: (context) => settings, child: MyApp()));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    var _settings = Provider.of<Settings>(context);
    return MaterialApp(
      title: 'Lecturas',
      debugShowCheckedModeBanner: false,
      themeMode: (_settings.useDarkTheme()) ? ThemeMode.dark : ThemeMode.light,
      theme: Util.getLightTheme(),
      darkTheme: Util.getDarkTheme(),
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate, // if it's a RTL language
      ],
      supportedLocales: [
        const Locale('es', 'ES'), // include country code too
      ],
      home: MainScreen(),
    );
  }
}
