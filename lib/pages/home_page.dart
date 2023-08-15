import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:organizare_timp/pages/calendar_page.dart';
import 'package:organizare_timp/pages/group_page.dart';
import 'package:organizare_timp/pages/settings_page.dart';
import 'package:organizare_timp/pages/user_home_page.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int selectedIndex = 0;

  void navigateBottomBar(int index){
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
            ]
            ),
        ),
      ),
      
    );
  }

  

  // Widget build_userlist() {
  //   return StreamBuilder<QuerySnapshot>(stream: FirebaseFirestore.instance.collection('users').snapshots(),
  //     builder: (context, snapshot){
  //       if(snapshot.hasError) {
  //         return const Text('error');
  //       }
  //       if(snapshot.connectionState == ConnectionState.waiting) {
  //         return const Text('loading...');
  //       }
  //       return ListView(
  //         children: snapshot.data!.docs.map<Widget>((doc) => userlistitem(doc)).toList(),
  //       );
  //     }
  //   );
  // }
 
  // Widget userlistitem(DocumentSnapshot documentSnapshot){
  //   Map<String, dynamic> data = documentSnapshot.data()! as Map<String, dynamic>;

  //   if(_firebaseAuth.currentUser!.email != data['email']) {
  //     return ListTile(
  //       title: Text(data['email']),
  //     );
  //   }
  //   else {
  //     return Container();
  //   }

  // }

}

// List<Appointment> getAppointments() {
//   List<Appointment> meetings = <Appointment>[];
//   final DateTime today = DateTime.now();
//   final DateTime startTime = DateTime(today.year, today.month, today.day, 9, 0, 0);

//   final DateTime endTime = startTime.add(const Duration(hours: 2));

//   meetings.add(Appointment(startTime: startTime, endTime: endTime, subject: 'Conference', color: Colors.blue));

//   return meetings;
// }

// class MeetingDataSource extends CalendarDataSource{
//   MeetingDataSource(List<Appointment> source){
//     appointments = source;
//   }
// }