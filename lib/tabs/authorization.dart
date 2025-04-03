import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'login.dart'; // Import the login page for redirection
import 'package:provider/provider.dart'; // Import Provider package
import 'theme_provider.dart'; // Import ThemeProvider

class Authorization extends StatefulWidget {
  const Authorization({super.key});

  @override
  _AuthorizationState createState() => _AuthorizationState();
}

class _AuthorizationState extends State<Authorization> {
  @override
  Widget build(BuildContext context) {
    // Get the current theme from ThemeProvider
    bool isDarkMode = Provider.of<ThemeProvider>(context).isDarkMode;

    return CupertinoApp(
      debugShowCheckedModeBanner: false, // Remove the debug watermark
      theme: CupertinoThemeData(
        brightness: isDarkMode ? Brightness.dark : Brightness.light, // Toggle between light and dark themes
      ),
      home: CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          middle: const Text('Authorization'),
          leading: CupertinoButton(
            padding: EdgeInsets.zero,
            child: const Icon(CupertinoIcons.power),
            onPressed: () async {
              try {
                await FirebaseAuth.instance.signOut(); // Firebase sign-out
                print("User signed out");
                Navigator.pushReplacement(
                  context,
                  CupertinoPageRoute(builder: (context) => const LoginPage()), // Navigate to login page
                );
              } catch (e) {
                print("Error signing out: $e");
              }
            },
          ),
          trailing: CupertinoSwitch(
            value: isDarkMode,
            onChanged: (value) {
              // Toggle dark mode using the ThemeProvider
              Provider.of<ThemeProvider>(context, listen: false)
                  .toggleDarkMode(value);
            },
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Content for Authorization
              const Expanded(
                child: Center(
                  child: Text(
                    'This is Authorization',
                    style: TextStyle(fontSize: 24),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
