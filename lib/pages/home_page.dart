import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:organizare_timp/pages/activity/activity_view_notif_page.dart';
import 'package:organizare_timp/pages/group/group_page.dart';
import 'package:organizare_timp/pages/settings_page.dart';
import 'package:organizare_timp/pages/user_home_page.dart';
import 'package:flutter/material.dart';
import '../services/notification_service.dart';
import 'calendar/calendar_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();

    NotificationService().initNotification();
    listenNotifications();
  }

  void listenNotifications() =>
      NotificationService().onNotification.stream.listen(onClickedNotification);

  void onClickedNotification(String? payload) =>
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => ActivityViewNotifPage(
                payload: payload,
              )));

  FirebaseAuth auth = FirebaseAuth.instance;
  int selectedIndex = 0;

  void navigateBottomBar(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  final List<Widget> pages = [
    const UserHomePage(),
    const CalendarPage(),
    const GroupPage(),
    const SettingPage()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[selectedIndex],
      bottomNavigationBar: Container(
        color: const Color.fromARGB(255, 102, 178, 255),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
          child: GNav(
              backgroundColor: const Color.fromARGB(255, 102, 178, 255),
              hoverColor: Colors.grey.shade700,
              activeColor: Colors.white,
              tabBackgroundColor: const Color.fromARGB(180, 102, 178, 255),
              textStyle: const TextStyle(color: Colors.white),
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
