import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:organizare_timp/components/button.dart';
import 'package:organizare_timp/pages/group/group_list_page.dart';
import 'package:organizare_timp/pages/group_activity/group_activities_day_view_page.dart';
import 'package:organizare_timp/pages/group_activity/group_activity_edit_page.dart';
import 'package:organizare_timp/services/group_service.dart';

import '../../model/group.dart';
import 'group_edit_page.dart';

class GroupViewingPage extends StatefulWidget {
  final Group group;

  final String objId;

  const GroupViewingPage({Key? key, required this.group, required this.objId})
      : super(key: key);

  @override
  State<GroupViewingPage> createState() => _GroupViewingPageState();
}

class _GroupViewingPageState extends State<GroupViewingPage> {
  FirebaseAuth auth = FirebaseAuth.instance;

  void leaveGroup() async {
    final GroupService groupService = GroupService();

    groupService.leaveGroup(widget.objId);

    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => GroupListPage()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: BackButton(),
        ),
        body: ListView(
          padding: const EdgeInsets.all(32),
          children: <Widget>[
            Text(
              widget.group.name,
              style: const TextStyle(fontSize: 24),
            ),
            Text(
              widget.group.description!,
              style: const TextStyle(fontSize: 16),
            ),
            Text(
              widget.group.leader,
              style: const TextStyle(fontSize: 16),
            ),
            Button(
                onTap: () => Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                        builder: (context) =>
                            GroupActivityDayViewPage(groupId: widget.objId))),
                text: "Vezi activitatile de azi"),
            adminControls(),
            Button(onTap: leaveGroup, text: "Iesi din grup")
          ],
        ));
  }

  Widget adminControls() {
    if (auth.currentUser!.uid == widget.group.leader) {
      return Row(
        children: [
          IconButton(
              onPressed: () =>
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (context) => GroupActivityEditPage(
                            groupId: widget.objId,
                          ))),
              icon: const Icon(Icons.add)),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              final groupService = GroupService();

              groupService.deleteGroup(widget.objId);
              Navigator.of(context).pop();
            },
          ),
          const SizedBox(
            width: 25,
          ),
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () =>
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (context) => GroupEditPage(
                          group: widget.group,
                          objId: widget.objId,
                        ))),
          ),
        ],
      );
    } else {
      return Container();
    }
  }
}
