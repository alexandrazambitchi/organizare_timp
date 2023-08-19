import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:organizare_timp/model/activity.dart';
import 'package:organizare_timp/pages/activity/activity_edit_page.dart';
import 'package:organizare_timp/provider/activity_provider.dart';
import 'package:provider/provider.dart';

class ActivityViewingPage extends StatelessWidget {
  final Activity activity;

  const ActivityViewingPage({Key? key, required this.activity}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: CloseButton(),
        ),
      body: ListView(
        padding: EdgeInsets.all(32),
        children: <Widget>[
          Text(activity.title, style: TextStyle(fontSize: 24),),
          buildDateTime(activity),
          SizedBox(height: 10,),
          Text(activity.description, style: TextStyle(fontSize: 16),),
          Text(activity.category, style: TextStyle(fontSize: 16),),
          Text(activity.priority, style: TextStyle(fontSize: 16),),
          Text(activity.location, style: TextStyle(fontSize: 16),),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: Icon(Icons.delete),
                onPressed: () {
                  // final provider = Provider.of<ActivityProvider>(context, listen: false);

                  // provider.deleteActivity(activity);
                  Navigator.pop(context);
                },),

              const SizedBox(
                width: 25,
              ),
              IconButton(
                icon: Icon(Icons.edit),
                onPressed: () =>   Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => ActivityEditPage(activity: activity,)))
                ,),
              
            ],
          ),
        ],
      )
    );

    
  }
  Widget buildDateTime(Activity activity){
    return Column(
      children: [
        buildDate(activity.isAllDay ? 'Toata ziua' : 'De la ', activity.startTime),
        if(!activity.isAllDay) buildDate('Pana la ', activity.endTime)
      ],
    );
  }

  Widget buildDate(String title, DateTime date){
    final dateFormated = DateFormat('EEE, d/M/y').format(date);
    final time = DateFormat.Hm().format(date);

    return Row(
      children: [
        Text(title),
        Text('$dateFormated $time')
      ],
    );
  }
}