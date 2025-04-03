import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart'; // Import Provider package
import 'tabs/login.dart'; // Import the login page
import 'tabs/theme_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      child: Builder(
        builder: (context) {
          // Get the current theme from ThemeProvider
          bool isDarkMode = Provider.of<ThemeProvider>(context).isDarkMode;
          return CupertinoApp(
            debugShowCheckedModeBanner: false,
            theme: CupertinoThemeData(
              brightness: isDarkMode ? Brightness.dark : Brightness.light,
            ),
            home: const LoginPage(),
          );
        },
      ),
    );
  }
}
