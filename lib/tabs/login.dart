import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart'; // Import Provider package
import 'registration.dart'; // For navigation to registration page
import 'data_logs.dart'; // Import data_logs.dart for navigation after login
import 'theme_provider.dart'; // Import ThemeProvider

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // Login function using FirebaseAuth
  Future<void> _login() async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );
      // If login is successful, navigate to the next screen (data_logs.dart)
      print("User logged in: ${userCredential.user?.email}");
      Navigator.pushReplacement(
        context,
        CupertinoPageRoute(builder: (context) => const DataLogs()), // Navigate to data_logs.dart
      );
    } catch (e) {
      print("Login failed: $e");
      // Show an error message to the user (using a dialog or snack bar)
      showCupertinoDialog(
        context: context,
        builder: (BuildContext context) => CupertinoAlertDialog(
          title: const Text('Login Failed'),
          content: const Text('Incorrect Email or Password'), // Display the error message
          actions: <Widget>[
            CupertinoDialogAction(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Get the current theme from ThemeProvider
    bool isDarkMode = Provider.of<ThemeProvider>(context).isDarkMode;

    return CupertinoApp(
      debugShowCheckedModeBanner: false,
      theme: CupertinoThemeData(
        brightness: isDarkMode ? Brightness.dark : Brightness.light,
      ),
      home: CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          middle: const Text('Login'),
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
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Centered Text for "Smart Doorbell" and "Group MMR"
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 80.0),
                child: Column(
                  children: [
                    Text('Smart Doorbell', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
                    Text('by Group MMR', style: TextStyle(fontSize: 18, fontWeight: FontWeight.normal)),
                  ],
                ),
              ),
              // Email Textfield
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: CupertinoTextField(
                  controller: _emailController,
                  placeholder: 'Email',
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
                  style: const TextStyle(fontSize: 18),
                ),
              ),
              const SizedBox(height: 20),
              // Password Textfield
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: CupertinoTextField(
                  controller: _passwordController,
                  placeholder: 'Password',
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
                  style: const TextStyle(fontSize: 18),
                  obscureText: true,
                ),
              ),
              const SizedBox(height: 40),
              // Login Button
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: CupertinoButton.filled(
                  child: const Text('Log In'),
                  onPressed: _login, // Call the login function
                ),
              ),
              const SizedBox(height: 20),
              // Sign Up Button
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: CupertinoButton(
                  child: const Text(
                    'Don\'t have an account? Sign Up',
                    style: TextStyle(color: CupertinoColors.activeBlue),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      CupertinoPageRoute(builder: (context) => const RegistrationPage()),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
