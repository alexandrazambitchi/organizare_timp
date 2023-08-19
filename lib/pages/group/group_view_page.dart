import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:organizare_timp/model/activity.dart';
import 'package:organizare_timp/pages/activity/activity_edit_page.dart';
import 'package:organizare_timp/services/activity_service.dart';
import 'package:provider/provider.dart';

import '../../model/group.dart';
import 'group_edit_page.dart';

class GroupViewingPage extends StatelessWidget {
  final Group group;

  final String objId;

  const GroupViewingPage({Key? key, required this.group, required this.objId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: CloseButton(),
        ),
      body: ListView(
        padding: EdgeInsets.all(32),
        children: <Widget>[
          Text(group.name, style: TextStyle(fontSize: 24),),
          Text(group.description!, style: TextStyle(fontSize: 16),),
          Text(group.leader, style: TextStyle(fontSize: 16),),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: Icon(Icons.delete),
                onPressed: () {}
                //   final provider = Provider.of<ActivityProvider>(context, listen: false);

                //   provider.deleteActivity(activity);
                //   Navigator.pop(context);}
                ,),

              const SizedBox(
                width: 25,
              ),
              IconButton(
                icon: Icon(Icons.edit),
                onPressed: () =>   Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => GroupEditPage(group: group,)))
                ,),
              
            ],
          ),
        ],
      )
    );    
  }
}