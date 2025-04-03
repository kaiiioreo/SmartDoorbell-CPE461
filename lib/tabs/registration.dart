import 'package:firebase_auth/firebase_auth.dart'; // Import Firebase Auth
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart'; // Import Provider package
import 'theme_provider.dart'; // Import ThemeProvider
import 'login.dart'; // Import your login page

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});

  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // Function to handle user registration
  Future<void> _registerUser() async {
    // Get email, password, and name from text fields
    String name = _nameController.text.trim();
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();

    // Check if any field is empty
    if (name.isEmpty || email.isEmpty || password.isEmpty) {
      // Show an alert if any field is empty
      showCupertinoDialog(
        context: context,
        builder: (context) => CupertinoAlertDialog(
          title: const Text('Missing Fields'),
          content: const Text('One or more missing fields'),
          actions: <Widget>[
            CupertinoDialogAction(
              child: const Text('OK'),
              onPressed: () {
                Navigator.pop(context); // Close the dialog
              },
            ),
          ],
        ),
      );
      return; // Prevent registration if fields are missing
    }

    try {
      // Register user with Firebase Authentication
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Optionally, you can save the user's full name to Firestore
      // For now, we just print success
      print("User registered successfully: ${userCredential.user?.email}");

      // After successful registration, show the success dialog
      showCupertinoDialog(
        context: context,
        builder: (context) => CupertinoAlertDialog(
          title: const Text('Success'),
          content: const Text('User Registered Successfully'),
          actions: <Widget>[
            CupertinoDialogAction(
              child: const Text('OK'),
              onPressed: () {
                Navigator.pop(context); // Close the success dialog
                Navigator.pushReplacement(
                  context,
                  CupertinoPageRoute(builder: (context) => LoginPage()), // Navigate to Login page
                );
              },
            ),
          ],
        ),
      );
    } catch (e) {
      print("Error: $e");
      // Handle errors, e.g., show a message to the user
      showCupertinoDialog(
        context: context,
        builder: (context) => CupertinoAlertDialog(
          title: const Text('Error'),
          content: Text(e.toString()),
          actions: [
            CupertinoDialogAction(
              child: const Text('OK'),
              onPressed: () {
                Navigator.pop(context); // Close the error dialog
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
          middle: const Text('Sign Up'),
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
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Full Name TextField
                  CupertinoTextField(
                    controller: _nameController,
                    placeholder: 'Full Name',
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    style: const TextStyle(fontSize: 18),
                  ),
                  const SizedBox(height: 16),

                  // Email TextField
                  CupertinoTextField(
                    controller: _emailController,
                    placeholder: 'Email',
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    style: const TextStyle(fontSize: 18),
                  ),
                  const SizedBox(height: 16),

                  // Password TextField
                  CupertinoTextField(
                    controller: _passwordController,
                    placeholder: 'Password',
                    obscureText: true,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    style: const TextStyle(fontSize: 18),
                  ),
                  const SizedBox(height: 24),

                  // Sign Up Button
                  CupertinoButton.filled(
                    child: const Text('Sign Up'),
                    onPressed: _registerUser, // Trigger registration
                  ),
                  const SizedBox(height: 16),

                  // Link to Login Page
                  CupertinoButton(
                    child: const Text('Already have an account? Login'),
                    onPressed: () {
                      Navigator.pop(context); // Go back to login page
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
