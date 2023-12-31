import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:organizare_timp/components/button.dart';
import 'package:organizare_timp/pages/group/group_list_page.dart';
import 'package:organizare_timp/pages/group_activity/group_activities_calendar_view_page.dart';
import 'package:organizare_timp/pages/group_activity/group_activities_day_view_page.dart';
import 'package:organizare_timp/pages/group_activity/group_activity_edit_page.dart';
import 'package:organizare_timp/services/auth_service.dart';
import 'package:organizare_timp/services/group_service.dart';

import '../../model/group.dart';
import '../../model/user_model.dart';
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
  AuthService authService = AuthService();

  List<UserModel> usersData = [];
  List<UserModel> groupMembers = [];

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
          leading: const BackButton(),
          title: const Text('Detalii grup'),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(32),
                children: <Widget>[
                  Text(
                    widget.group.name,
                    style: const TextStyle(fontSize: 24),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(
                    width: 25,
                  ),
                  const Text(
                    'Detalii:',
                    style: TextStyle(fontSize: 16),
                  ),
                  Text(
                    widget.group.description!,
                    style: const TextStyle(fontSize: 18),
                  ),
                  const SizedBox(
                    height: 15.0,
                  ),
                  const Text(
                    'Id leader:',
                    style: TextStyle(fontSize: 16),
                  ),
                  Text(
                    widget.group.leader,
                    style: const TextStyle(fontSize: 18),
                  ),
                  const SizedBox(
                    height: 15.0,
                  ),
                  showMembers(),
                  const SizedBox(
                    height: 15.0,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Button(
                  onTap: () => Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                          builder: (context) =>
                              GroupActivityDayViewPage(groupId: widget.objId))),
                  text: "Vezi activitatile de azi"),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Button(
                  onTap: () => Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                          builder: (context) => GroupActivityCalendarPage(
                              groupId: widget.objId))),
                  text: "Vezi activitatile in calendar"),
            ),
            adminControls(),
          ],
        ));
  }

  Widget adminControls() {
    if (auth.currentUser!.uid == widget.group.leader) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 45.0, top: 20.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
                iconSize: 30.0,
                onPressed: () =>
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (context) => GroupActivityEditPage(
                              groupId: widget.objId,
                            ))),
                icon: const Icon(Icons.add)),
            const SizedBox(
              width: 25,
            ),
            IconButton(
              iconSize: 30.0,
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
              iconSize: 30.0,
              icon: const Icon(Icons.edit),
              onPressed: () =>
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (context) => GroupEditPage(
                            group: widget.group,
                            objId: widget.objId,
                          ))),
            ),
          ],
        ),
      );
    } else {
      return Padding(
        padding: const EdgeInsets.only(bottom: 40.0),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Button(onTap: leaveGroup, text: "Iesi din grup"),
        ),
      );
    }
  }


  Widget showMembers() {
    List<String> tempMembersList = widget.group.members.toList();

    if (tempMembersList.isEmpty) {
      return const Text("Nu exista niciun membru");
    }
    return Wrap(
      children: tempMembersList.map((e) => Chip(label: Text(e))).toList(),
    );
  }


}
