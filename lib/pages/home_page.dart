import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:organizare_timp/pages/group/group_page.dart';
import 'package:organizare_timp/pages/settings_page.dart';
import 'package:organizare_timp/pages/user_home_page.dart';
import 'package:flutter/material.dart';
import 'calendar/calendar_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int selectedIndex = 0;

  void navigateBottomBar(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  final List<Widget> pages = [
    UserHomePage(),
    CalendarPage(),
    GroupPage(),
    SettingPage()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[selectedIndex],
      bottomNavigationBar: Container(
        color: Colors.grey.shade200,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
          child: GNav(
              backgroundColor: Colors.grey.shade200,
              hoverColor: Colors.grey.shade700,
              activeColor: Colors.purple[100],
              tabBackgroundColor: Colors.purple.shade300,
              gap: 8,
              onTabChange: navigateBottomBar,
              padding: const EdgeInsets.all(16),
              tabs: const [
                GButton(
                  icon: Icons.home,
                  text: 'Acasa',
                ),
                GButton(
                  icon: Icons.calendar_month,
                  text: 'Calendar',
                ),
                GButton(
                  icon: Icons.group,
                  text: 'Grupuri',
                ),
                GButton(
                  icon: Icons.settings,
                  text: 'Setari',
                )
              ]),
        ),
      ),
    );
  }
}
