import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart'; // Import Provider package
import 'theme_provider.dart'; // Import ThemeProvider
import 'login.dart'; // Import login page for redirection
import 'authorization.dart'; // Import the authorization page
import 'settings.dart'; // Import the settings page

class DataLogs extends StatefulWidget {
  const DataLogs({super.key});

  @override
  State<DataLogs> createState() => _DataLogsState();
}

class _DataLogsState extends State<DataLogs> {
  int _selectedSegment = 0; // Default to "Motion Detected"
  int _selectedTab = 0; // To track the selected tab for bottom navigation

  // Sign out function
  Future<void> _signOut() async {
    try {
      await FirebaseAuth.instance.signOut(); // Firebase sign-out
      print("User signed out");
      Navigator.pushReplacement(
        context,
        CupertinoPageRoute(builder: (context) => const LoginPage()), // Navigate to login page
      );
    } catch (e) {
      print("Error signing out: $e");
      // Optionally, show an error message (e.g., using a dialog or a snackbar)
    }
  }

  @override
  Widget build(BuildContext context) {
    // Get the current theme from ThemeProvider
    bool isDarkMode = Provider.of<ThemeProvider>(context).isDarkMode;

    return CupertinoApp(
      debugShowCheckedModeBanner: false, // Remove the debug watermark
      theme: CupertinoThemeData(
        brightness: isDarkMode ? Brightness.dark : Brightness.light, // Toggle between light and dark themes
      ),
      home: CupertinoTabScaffold(
        tabBar: CupertinoTabBar(
          currentIndex: _selectedTab,
          onTap: (index) {
            setState(() {
              _selectedTab = index;
            });
          },
          items: const [
            BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.text_badge_checkmark),
              label: 'Data Logs', // Data Logs on the left
            ),
            BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.person_2_fill),
              label: 'Authorization', // Authorization in the middle
            ),
            BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.settings),
              label: 'Settings', // Settings on the right
            ),
          ],
        ),
        tabBuilder: (context, index) {
          switch (index) {
            case 0:
              return CupertinoPageScaffold(
                navigationBar: CupertinoNavigationBar(
                  leading: CupertinoButton(
                    padding: EdgeInsets.zero,
                    child: const Icon(CupertinoIcons.power),
                    onPressed: _signOut, // Call sign-out function
                  ),
                  middle: const Text('Data Logs'),
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
                      // Sliding Control for Motion Detected and Doorbell Pressed
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: CupertinoSlidingSegmentedControl<int>(
                          backgroundColor: CupertinoColors.systemGrey5,
                          thumbColor: CupertinoColors.systemGrey,
                          groupValue: _selectedSegment,
                          onValueChanged: (int? value) {
                            if (value != null) {
                              setState(() {
                                _selectedSegment = value;
                              });
                            }
                          },
                          children: const {
                            0: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 20),
                              child: Text('Motion Detected'),
                            ),
                            1: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 20),
                              child: Text('Doorbell Pressed'),
                            ),
                          },
                        ),
                      ),

                      // Display content based on selected segment
                      Expanded(
                        child: Center(
                          child: Text(
                            _selectedSegment == 0
                                ? 'Showing Motion Detected Logs'
                                : 'Showing Doorbell Pressed Logs',
                            style: const TextStyle(fontSize: 20),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );

            case 1:
              return const Authorization(); // Authorization page in the middle

            case 2:
              return const Settings(); // Settings page on the right

            default:
              return CupertinoPageScaffold(
                navigationBar: const CupertinoNavigationBar(
                  middle: Text('Data Logs'),
                ),
                child: SafeArea(
                  child: Center(child: const Text('Unknown Page')),
                ),
              );
          }
        },
      ),
    );
  }
}
