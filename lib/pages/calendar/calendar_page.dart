import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:organizare_timp/services/activity_service.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import '../../model/activity.dart';
import '../../model/activity_datasource.dart';
import '../activity/activity_edit_page.dart';
import 'task_page.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {

  // var collection = FirebaseFirestore.instance.collection("users");
  // late List<Map<String, dynamic>> activitiesRaw;
  // late List<Activity> activities = [];

  void getActivityList(List<Activity> activities) async {
    List<Activity> tempList = [];
   
    for (var element in activities) {
      if(element.user == FirebaseAuth.instance.currentUser!.uid){
        tempList.add(element);
      }
    }

     activities = tempList;
  }
  

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ActivityService>(context, listen: true);

    // provider.getActivitiesFromDataBase(FirebaseAuth.instance.currentUser!.uid);

    // final activities = Provider.of<ActivityProvider>(context).activities;
    // getActivityList(activities);
    return Scaffold(
      appBar: AppBar(
        actions: [
            IconButton(
              icon: const Icon(Icons.note_add_rounded),
              onPressed: () =>  Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => ActivityEditPage(),))
            )
          ],
          
        ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center, 
              children: [
                // getDataFromDatabase(),
                // SfCalendar(
                //   view: CalendarView.month,
                //   firstDayOfWeek: 1,
                //   dataSource: ActivityDataSource(activities),
                //   onLongPress: (details) {
                //     provider.setDate(details.date!);

                //     showModalBottomSheet(
                //       context: context, 
                //       builder: (context) => TasksWidget() );
                //   },
                // ),
              ]
            )
          )
        )
      ),
      
    );
  }

  // Widget getDataFromDatabase(){
  //   return StreamBuilder<QuerySnapshot>(stream: FirebaseFirestore.instance.collection('activities').snapshots(),
  //   builder: (context, snapshot) {
  //     if(snapshot.hasError){
  //       return const Text('error');
  //     }

  //     if(snapshot.connectionState == ConnectionState.waiting){
  //       return const Text('loading');
  //     }

  //     return Container(
  //       height: 300,
  //       child: ListView(
  //             children: snapshot.data!.docs.map<Widget>((doc) => activityItem(doc)).toList(),
  //           ),
  //     );

  //   });
  //   // 
  // }

  // Widget activityItem(DocumentSnapshot documentSnapshot){
  //   Map<String, dynamic> data = documentSnapshot.data()! as Map<String, dynamic>;
    
  //   if(FirebaseAuth.instance.currentUser!.email == data['email'])
  //   {
  //     return ListTile(
  //       title: Text(data['activity_tile']),
        
  //     );
  //   } else{
  //     return Container();
  //   }
  // }
}